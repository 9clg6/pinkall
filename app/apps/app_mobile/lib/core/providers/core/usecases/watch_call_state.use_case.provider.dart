import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_call_state.use_case.provider.g.dart';

/// Provides the replaying state stream for one real Telnyx call.
@riverpod
Future<WatchCallStateUseCase> watchCallStateUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return WatchCallStateUseCase(callRepository: repository);
}
