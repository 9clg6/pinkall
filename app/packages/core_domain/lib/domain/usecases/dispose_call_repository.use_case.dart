import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Releases Telnyx streams and native resources.
final class DisposeCallRepositoryUseCase extends FutureUseCase<void> {
  /// Creates the use case with its [callRepository].
  DisposeCallRepositoryUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke() => _callRepository.dispose();
}
