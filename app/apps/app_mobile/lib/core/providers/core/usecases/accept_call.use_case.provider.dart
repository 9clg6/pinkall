import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accept_call.use_case.provider.g.dart';

/// Provides the use case that accepts an incoming Telnyx call.
@riverpod
Future<AcceptCallUseCase> acceptCallUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return AcceptCallUseCase(callRepository: repository);
}
