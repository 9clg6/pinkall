import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/usecases/create_custom_objection.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/list_objections.use_case.provider.dart';
import 'package:pinkall/features/coaching/presentation/screens/objections/objection_library.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'objection_library.view_model.g.dart';

/// Loads and mutates the objection library.
@riverpod
final class ObjectionLibraryViewModel extends _$ObjectionLibraryViewModel {
  @override
  Future<ObjectionLibraryState> build() async {
    return ObjectionLibraryState(
      entries: await ref.read(listObjectionsUseCaseProvider).call(),
    );
  }

  /// Reloads entries from the backend.
  Future<void> refresh() async {
    state = const AsyncLoading<ObjectionLibraryState>();
    state = await AsyncValue.guard(build);
  }

  /// Saves a custom answer and refreshes its merged entry.
  Future<bool> addCustom(CreateCustomObjectionParam params) async {
    final ObjectionLibraryState? current = state.value;
    if (current == null || current.isSaving) {
      return false;
    }
    state = AsyncData<ObjectionLibraryState>(current.copyWith(isSaving: true));
    try {
      await ref.read(createCustomObjectionUseCaseProvider).call(params);
      final List<ObjectionKnowledgeEntryEntity> entries = await ref
          .read(listObjectionsUseCaseProvider)
          .call();
      state = AsyncData<ObjectionLibraryState>(
        ObjectionLibraryState(entries: entries),
      );
      return true;
    } on Object {
      state = AsyncData<ObjectionLibraryState>(
        current.copyWith(isSaving: false),
      );
      return false;
    }
  }
}
