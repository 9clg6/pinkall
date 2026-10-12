import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_coaching_progress.use_case.provider.g.dart';

/// Provides the workspace-level historical coaching profile.
@riverpod
Future<GetCoachingProgressUseCase> getCoachingProgressUseCase(Ref ref) async {
  return GetCoachingProgressUseCase(
    conversationSessionRepository: ref.watch(
      conversationSessionRepositoryProvider,
    ),
  );
}
