import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ensure_microphone_access.use_case.provider.g.dart';

/// Provides the microphone preflight required before a real WebRTC call.
@riverpod
Future<EnsureMicrophoneAccessUseCase> ensureMicrophoneAccessUseCase(
  Ref ref,
) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return EnsureMicrophoneAccessUseCase(callRepository: repository);
}
