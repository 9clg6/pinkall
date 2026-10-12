import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_progress.state.freezed.dart';

/// Immutable state of the longitudinal coaching dashboard.
@freezed
abstract class CallProgressState with _$CallProgressState {
  /// Creates a loaded progress dashboard state.
  const factory CallProgressState({
    required CoachingProgressEntity progress,
    required int selectedWindow,
    @Default(false) bool isRefreshing,
  }) = _CallProgressState;
}
