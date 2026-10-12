import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/call_eligibility.remote.data_source.dart';
import 'package:core_data/model/remote/call_eligibility.remote.model.dart';

/// HTTP implementation of [CallEligibilityRemoteDataSource].
final class CallEligibilityRemoteDataSourceImpl
    implements CallEligibilityRemoteDataSource {
  /// Creates the source from a real configurable backend [httpClient].
  const CallEligibilityRemoteDataSourceImpl({
    required PinkallHttpClient httpClient,
  }) : _httpClient = httpClient;

  final PinkallHttpClient _httpClient;

  @override
  Future<CallEligibilityRemoteModel> evaluate(Map<String, dynamic> body) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/call-eligibility/evaluate',
      body: body,
    );
    return CallEligibilityRemoteModel.fromJson(json);
  }
}
