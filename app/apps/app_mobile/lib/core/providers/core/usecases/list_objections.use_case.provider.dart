import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_objections.use_case.provider.g.dart';

/// Provides the objection library query.
@riverpod
ListObjectionsUseCase listObjectionsUseCase(Ref ref) {
  return ListObjectionsUseCase(
    coachingRepository: ref.watch(coachingRepositoryProvider),
  );
}
