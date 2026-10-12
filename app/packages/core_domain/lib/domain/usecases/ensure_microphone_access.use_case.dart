import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Ensures that the microphone can be opened for a voice call.
final class EnsureMicrophoneAccessUseCase extends FutureUseCase<void> {
  /// Creates the use case with its [callRepository].
  EnsureMicrophoneAccessUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke() => _callRepository.ensureMicrophoneAccess();
}
