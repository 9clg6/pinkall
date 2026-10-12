import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:pinkall/core/providers/core/usecases/get_workspace_sales_context.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/upsert_workspace_sales_context.use_case.provider.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_sales_context.view_model.g.dart';

/// Loads and updates the workspace's durable commercial context.
@riverpod
class WorkspaceSalesContextViewModel extends _$WorkspaceSalesContextViewModel {
  late GetWorkspaceSalesContextUseCase _getContextUseCase;
  late UpsertWorkspaceSalesContextUseCase _upsertContextUseCase;

  @override
  Future<WorkspaceSalesContextState> build() async {
    _getContextUseCase = await ref.watch(
      getWorkspaceSalesContextUseCaseProvider.future,
    );
    _upsertContextUseCase = await ref.watch(
      upsertWorkspaceSalesContextUseCaseProvider.future,
    );
    final ResultState<WorkspaceSalesContextEntity?> result =
        await _getContextUseCase.execute();
    return result.when<WorkspaceSalesContextState>(
      success: (WorkspaceSalesContextEntity? context) =>
          WorkspaceSalesContextState(
            context: context,
            isSaving: false,
            operationFailure: null,
          ),
      failure: (Exception exception) => throw exception,
    );
  }

  /// Persists a new context revision and returns whether it succeeded.
  Future<bool> save({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
  }) async {
    final WorkspaceSalesContextState? current = state.value;
    if (current == null || current.isSaving) {
      return false;
    }
    state = AsyncData<WorkspaceSalesContextState>(
      current.copyWith(isSaving: true, operationFailure: null),
    );
    final ResultState<WorkspaceSalesContextEntity> result =
        await _upsertContextUseCase.execute(
          UpsertWorkspaceSalesContextParam(
            companyName: companyName.trim(),
            productName: productName.trim(),
            pitchMarkdown: pitchMarkdown.trim(),
            expectedRevision: current.context?.revision,
          ),
        );
    return result.when<bool>(
      success: (WorkspaceSalesContextEntity context) {
        state = AsyncData<WorkspaceSalesContextState>(
          current.copyWith(
            context: context,
            isSaving: false,
            operationFailure: null,
          ),
        );
        return true;
      },
      failure: (Exception exception) {
        state = AsyncData<WorkspaceSalesContextState>(
          current.copyWith(
            isSaving: false,
            operationFailure: 'workspace_context_save_error',
          ),
        );
        return false;
      },
    );
  }
}
