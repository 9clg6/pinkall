import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dial_call.use_case.provider.g.dart';

/// Provides the use case that places a real Telnyx call.
@riverpod
Future<DialCallUseCase> dialCallUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return DialCallUseCase(callRepository: repository);
}
