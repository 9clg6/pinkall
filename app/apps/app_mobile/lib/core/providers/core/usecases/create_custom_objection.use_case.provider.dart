import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_custom_objection.use_case.provider.g.dart';

/// Provides the custom objection command.
@riverpod
CreateCustomObjectionUseCase createCustomObjectionUseCase(Ref ref) {
  return CreateCustomObjectionUseCase(
    coachingRepository: ref.watch(coachingRepositoryProvider),
  );
}
