import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_call_muted.use_case.provider.g.dart';

/// Provides the Telnyx microphone-control use case.
@riverpod
Future<SetCallMutedUseCase> setCallMutedUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return SetCallMutedUseCase(callRepository: repository);
}
