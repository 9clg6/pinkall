import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connect_telnyx.use_case.provider.g.dart';

/// Provides the use case that registers the Telnyx client.
@riverpod
Future<ConnectTelnyxUseCase> connectTelnyxUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return ConnectTelnyxUseCase(callRepository: repository);
}
