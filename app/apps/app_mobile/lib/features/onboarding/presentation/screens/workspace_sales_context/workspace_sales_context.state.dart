import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_sales_context.state.freezed.dart';

/// Immutable state for the workspace sales-context setup screen.
@Freezed(copyWith: true)
abstract class WorkspaceSalesContextState with _$WorkspaceSalesContextState {
  /// Creates workspace sales-context state.
  const factory WorkspaceSalesContextState({
    required WorkspaceSalesContextEntity? context,
    required bool isSaving,
    required String? operationFailure,
  }) = _WorkspaceSalesContextState;
}
