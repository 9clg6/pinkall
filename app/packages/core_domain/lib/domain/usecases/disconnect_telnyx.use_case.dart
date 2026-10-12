import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Disconnects the Telnyx WebRTC client.
final class DisconnectTelnyxUseCase extends FutureUseCase<void> {
  /// Creates the use case with its [callRepository].
  DisconnectTelnyxUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke() => _callRepository.disconnect();
}
