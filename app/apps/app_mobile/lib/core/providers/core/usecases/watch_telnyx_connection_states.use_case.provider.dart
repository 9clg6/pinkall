import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_telnyx_connection_states.use_case.provider.g.dart';

/// Provides the Telnyx connection-state stream use case.
@riverpod
Future<WatchTelnyxConnectionStatesUseCase> watchTelnyxConnectionStatesUseCase(
  Ref ref,
) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return WatchTelnyxConnectionStatesUseCase(callRepository: repository);
}
