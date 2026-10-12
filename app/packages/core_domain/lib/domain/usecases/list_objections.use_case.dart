import 'package:core_domain/domain/entities/objection_knowledge_entry.entity.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';

/// Lists learned and custom objections for the current workspace.
final class ListObjectionsUseCase {
  /// Creates the use case.
  const ListObjectionsUseCase({required CoachingRepository coachingRepository})
    : _repository = coachingRepository;

  final CoachingRepository _repository;

  /// Executes the query.
  Future<List<ObjectionKnowledgeEntryEntity>> call() =>
      _repository.listObjections();
}
