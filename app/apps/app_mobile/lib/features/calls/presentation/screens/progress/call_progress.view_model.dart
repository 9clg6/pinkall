import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:pinkall/core/providers/core/usecases/get_coaching_progress.use_case.provider.dart';
import 'package:pinkall/features/calls/presentation/screens/progress/call_progress.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_progress.view_model.g.dart';

/// Loads and refreshes the workspace coaching progression.
@riverpod
final class CallProgressViewModel extends _$CallProgressViewModel {
  late GetCoachingProgressUseCase _getProgress;
  int _loadRevision = 0;

  @override
  Future<CallProgressState> build() async {
    _getProgress = await ref.watch(getCoachingProgressUseCaseProvider.future);
    return _load(windowSize: 5);
  }

  /// Changes the comparison window while keeping the dashboard responsive.
  Future<void> selectWindow(int windowSize) async {
    final CallProgressState? current = state.value;
    if (current == null || current.selectedWindow == windowSize) {
      return;
    }
    await _replaceWithLoad(
      current.copyWith(selectedWindow: windowSize, isRefreshing: true),
    );
  }

  /// Reloads the current comparison window from the durable API.
  Future<void> refresh() async {
    final CallProgressState? current = state.value;
    if (current == null || current.isRefreshing) {
      return;
    }
    await _replaceWithLoad(current.copyWith(isRefreshing: true));
  }

  Future<void> _replaceWithLoad(CallProgressState pending) async {
    final int revision = ++_loadRevision;
    state = AsyncData<CallProgressState>(pending);
    try {
      final CallProgressState next = await _load(
        windowSize: pending.selectedWindow,
      );
      if (revision == _loadRevision) {
        state = AsyncData<CallProgressState>(next);
      }
    } on Object catch (error, stackTrace) {
      if (revision == _loadRevision) {
        state = AsyncError<CallProgressState>(error, stackTrace);
      }
    }
  }

  Future<CallProgressState> _load({required int windowSize}) async {
    final ResultState<CoachingProgressEntity> result = await _getProgress
        .execute(
          GetCoachingProgressParam(windowSize: windowSize, recentLimit: 20),
        );
    return result.when<CallProgressState>(
      success: (CoachingProgressEntity data) =>
          CallProgressState(progress: data, selectedWindow: windowSize),
      failure: (Exception exception) => throw exception,
    );
  }
}
