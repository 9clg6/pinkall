import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_call_debrief.use_case.provider.g.dart';

/// Provides grounded post-call artifacts through the domain use case.
@riverpod
Future<GetCallDebriefUseCase> getCallDebriefUseCase(Ref ref) async {
  return GetCallDebriefUseCase(
    conversationSessionRepository: ref.watch(
      conversationSessionRepositoryProvider,
    ),
  );
}
