import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hang_up_call.use_case.provider.g.dart';

/// Provides the use case that hangs up a Telnyx call.
@riverpod
Future<HangUpCallUseCase> hangUpCallUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return HangUpCallUseCase(callRepository: repository);
}
