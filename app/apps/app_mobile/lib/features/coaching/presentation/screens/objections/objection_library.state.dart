import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'objection_library.state.freezed.dart';

/// State of the objection knowledge library.
@freezed
abstract class ObjectionLibraryState with _$ObjectionLibraryState {
  /// Creates the screen state.
  const factory ObjectionLibraryState({
    @Default(<ObjectionKnowledgeEntryEntity>[])
    List<ObjectionKnowledgeEntryEntity> entries,
    @Default(false) bool isSaving,
  }) = _ObjectionLibraryState;
}
