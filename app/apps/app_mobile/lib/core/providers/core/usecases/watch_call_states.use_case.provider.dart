import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_call_states.use_case.provider.g.dart';

/// Provides the real Telnyx call-state stream use case.
@riverpod
Future<WatchCallStatesUseCase> watchCallStatesUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return WatchCallStatesUseCase(callRepository: repository);
}
