import 'dart:io';
import 'dart:typed_data';

import 'package:core_data/clients/pinkall_binary_http.client.dart';
import 'package:core_data/clients/pinkall_file_http.client.dart';
import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/exceptions/pinkall_backend.exception.dart';
import 'package:dio/dio.dart';

/// Real configurable Dio implementation of [PinkallHttpClient].
final class DioPinkallHttpClientImpl
    implements
        PinkallHttpClient,
        PinkallBinaryHttpClient,
        PinkallFileHttpClient {
  /// Creates an authenticated HTTP client for an absolute HTTP(S) [baseUri].
  DioPinkallHttpClientImpl({
    required Uri baseUri,
    required PinkallAccessTokenProvider accessTokenProvider,
    Duration connectTimeout = const Duration(seconds: 10),
    // Final batch transcription and the grounded post-call pass can exceed
    // the short timeout used by CRUD calls on a real conversation.
    Duration receiveTimeout = const Duration(minutes: 2),
  }) : _accessTokenProvider = accessTokenProvider,
       _dio = Dio(
         BaseOptions(
           baseUrl: _normalizedBaseUrl(baseUri),
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           headers: const <String, String>{
             'Accept': 'application/json',
             'Content-Type': 'application/json',
           },
         ),
       );

  final Dio _dio;
  final PinkallAccessTokenProvider _accessTokenProvider;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _request(path, method: 'GET', queryParameters: queryParameters);

  @override
  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _request(path, method: 'PATCH', body: body);

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _request(path, method: 'POST', body: body);

  @override
  Future<Map<String, dynamic>> postBinary(
    String path, {
    required Uint8List body,
    required String contentType,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    path,
    method: 'POST',
    binaryBody: body,
    contentType: contentType,
    queryParameters: queryParameters,
  );

  @override
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) => _request(path, method: 'PUT', body: body);

  @override
  Future<Map<String, dynamic>> putFile(
    String path, {
    required String filePath,
    required int sizeBytes,
    required String contentType,
  }) async {
    if (sizeBytes <= 0) {
      throw ArgumentError.value(sizeBytes, 'sizeBytes', 'Must be positive.');
    }
    final File file = File(filePath);
    final int actualSize = await file.length();
    if (actualSize != sizeBytes) {
      throw ArgumentError(
        'Temporary recording size changed before upload: '
        '$actualSize != $sizeBytes.',
      );
    }
    return _request(
      path,
      method: 'PUT',
      streamBody: file.openRead(),
      contentLength: sizeBytes,
      contentType: contentType,
    );
  }

  Future<Map<String, dynamic>> _request(
    String path, {
    required String method,
    Map<String, dynamic>? body,
    Uint8List? binaryBody,
    Stream<List<int>>? streamBody,
    int? contentLength,
    String? contentType,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final String? token = await _accessTokenProvider();
      final Options options = Options(
        method: method,
        contentType: contentType,
        headers: <String, Object?>{
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          if (contentLength != null) Headers.contentLengthHeader: contentLength,
        },
      );
      final Response<dynamic> response = await _dio.request<dynamic>(
        path,
        data: streamBody ?? binaryBody ?? body,
        queryParameters: queryParameters,
        options: options,
      );
      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map<dynamic, dynamic>) {
        return data.map<String, dynamic>(
          (dynamic key, dynamic value) =>
              MapEntry<String, dynamic>(key.toString(), value),
        );
      }
      throw PinkallBackendException(
        message: 'Expected a JSON object response.',
        path: path,
        statusCode: response.statusCode,
      );
    } on PinkallBackendException {
      rethrow;
    } on DioException catch (exception) {
      throw PinkallBackendException(
        message: exception.message ?? 'Pinkall HTTP request failed.',
        path: path,
        statusCode: exception.response?.statusCode,
        cause: exception,
      );
    }
  }

  static String _normalizedBaseUrl(Uri baseUri) {
    if (!baseUri.isAbsolute ||
        (baseUri.scheme != 'http' && baseUri.scheme != 'https')) {
      throw ArgumentError.value(
        baseUri,
        'baseUri',
        'An absolute HTTP(S) URI is required.',
      );
    }
    final String value = baseUri.toString();
    return value.endsWith('/') ? value : '$value/';
  }
}
