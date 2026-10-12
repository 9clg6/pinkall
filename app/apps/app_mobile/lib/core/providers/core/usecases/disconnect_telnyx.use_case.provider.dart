import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'disconnect_telnyx.use_case.provider.g.dart';

/// Provides the use case that disconnects the Telnyx client.
@riverpod
Future<DisconnectTelnyxUseCase> disconnectTelnyxUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return DisconnectTelnyxUseCase(callRepository: repository);
}
