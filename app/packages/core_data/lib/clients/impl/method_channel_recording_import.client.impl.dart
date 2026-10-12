import 'package:core_data/clients/recording_import.client.dart';
import 'package:flutter/services.dart';

/// iOS and Android recording-import client backed by one stable channel.
final class MethodChannelRecordingImportClientImpl
    implements RecordingImportClient {
  /// Creates the production client or injects a channel for tests.
  const MethodChannelRecordingImportClientImpl({
    MethodChannel channel = const MethodChannel(_channelName),
  }) : _channel = channel;

  static const String _channelName = 'com.pinkall.recording_import/methods';
  static const int _maximumBytes = 200 * 1024 * 1024;
  final MethodChannel _channel;

  @override
  Future<RecordingImportAction?> consumePendingAction() async {
    try {
      final Object? response = await _channel.invokeMethod<Object?>(
        'consumePendingAction',
      );
      if (response == null) return null;
      final Map<String, Object?> values = _stringMap(response);
      return switch (values['kind']) {
        'pick_recording' => const RecordingImportPickerRequested(),
        'audio_file' => _decodeAudioImport(values),
        _ => throw const RecordingImportException(
          RecordingImportFailure.invalidResponse,
          'Native recording import returned an unknown action.',
        ),
      };
    } on RecordingImportException {
      rethrow;
    } on MissingPluginException {
      throw const RecordingImportException(
        RecordingImportFailure.unsupportedPlatform,
        'Recording import is unavailable on this platform.',
      );
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    }
  }

  @override
  Future<RecordingAudioImport?> pickRecording() async {
    try {
      final Object? response = await _channel.invokeMethod<Object?>(
        'pickRecording',
      );
      if (response == null) return null;
      final Map<String, Object?> values = _stringMap(response);
      if (values['kind'] != 'audio_file') {
        throw const RecordingImportException(
          RecordingImportFailure.invalidResponse,
          'Native recording picker returned an invalid action.',
        );
      }
      return _decodeAudioImport(values);
    } on RecordingImportException {
      rethrow;
    } on MissingPluginException {
      throw const RecordingImportException(
        RecordingImportFailure.unsupportedPlatform,
        'Recording import is unavailable on this platform.',
      );
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    }
  }

  @override
  Future<void> discardImport(String id) async {
    final String normalized = id.trim();
    if (!_validId(normalized)) {
      throw const RecordingImportException(
        RecordingImportFailure.invalidResponse,
        'The temporary recording identifier is invalid.',
      );
    }
    try {
      await _channel.invokeMethod<void>('discardImport', <String, Object?>{
        'id': normalized,
      });
    } on MissingPluginException {
      throw const RecordingImportException(
        RecordingImportFailure.unsupportedPlatform,
        'Recording import is unavailable on this platform.',
      );
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    }
  }

  static RecordingAudioImport _decodeAudioImport(Map<String, Object?> values) {
    final String id = _requiredString(values, 'id');
    final String name = _requiredString(values, 'name');
    final String mimeType = _requiredString(values, 'mime_type').toLowerCase();
    final String path = _requiredString(values, 'path');
    final Object? rawSize = values['size_bytes'];
    if (!_validId(id) ||
        name.length > 255 ||
        name.contains('/') ||
        name.contains(r'\') ||
        !mimeType.startsWith('audio/') ||
        !path.startsWith('/') ||
        rawSize is! int ||
        rawSize <= 0) {
      throw const RecordingImportException(
        RecordingImportFailure.invalidResponse,
        'Native recording metadata is invalid.',
      );
    }
    if (rawSize > _maximumBytes) {
      throw const RecordingImportException(
        RecordingImportFailure.tooLarge,
        'The recording exceeds the 200 MiB import limit.',
      );
    }
    return RecordingAudioImport(
      id: id,
      name: name,
      mimeType: mimeType,
      path: path,
      sizeBytes: rawSize,
    );
  }

  static Map<String, Object?> _stringMap(Object value) {
    if (value is! Map<Object?, Object?>) {
      throw const RecordingImportException(
        RecordingImportFailure.invalidResponse,
        'Native recording import returned invalid metadata.',
      );
    }
    return value.map<String, Object?>(
      (Object? key, Object? item) =>
          MapEntry<String, Object?>(key?.toString() ?? '', item),
    );
  }

  static String _requiredString(Map<String, Object?> values, String key) {
    final Object? raw = values[key];
    if (raw is! String || raw.trim().isEmpty) {
      throw RecordingImportException(
        RecordingImportFailure.invalidResponse,
        'Native recording import is missing $key.',
      );
    }
    return raw.trim();
  }

  static bool _validId(String value) =>
      RegExp(r'^[A-Za-z0-9_-]{8,80}$').hasMatch(value);

  static RecordingImportException _platformFailure(PlatformException error) {
    final RecordingImportFailure failure = switch (error.code) {
      'unsupported_audio' => RecordingImportFailure.unsupportedAudio,
      'recording_too_large' => RecordingImportFailure.tooLarge,
      'import_io_failure' => RecordingImportFailure.ioFailure,
      _ => RecordingImportFailure.invalidResponse,
    };
    return RecordingImportException(
      failure,
      error.message ?? 'Native recording import failed.',
    );
  }
}
