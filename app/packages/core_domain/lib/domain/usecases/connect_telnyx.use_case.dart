import 'package:core_domain/domain/params/connect_telnyx.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Connects and registers the Telnyx WebRTC client.
final class ConnectTelnyxUseCase
    extends FutureUseCaseWithParams<void, ConnectTelnyxParam> {
  /// Creates the use case with its [callRepository].
  ConnectTelnyxUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke(ConnectTelnyxParam params) {
    return _callRepository.connect(params.configuration);
  }
}
