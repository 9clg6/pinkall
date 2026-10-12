import 'package:core_domain/domain/entities/objection_knowledge_entry.entity.dart';
import 'package:core_domain/domain/params/create_custom_objection.param.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';

/// Adds or updates a custom answer for one objection.
final class CreateCustomObjectionUseCase {
  /// Creates the use case.
  const CreateCustomObjectionUseCase({
    required CoachingRepository coachingRepository,
  }) : _repository = coachingRepository;

  final CoachingRepository _repository;

  /// Executes the command.
  Future<ObjectionKnowledgeEntryEntity> call(
    CreateCustomObjectionParam params,
  ) => _repository.createCustomObjection(params);
}
