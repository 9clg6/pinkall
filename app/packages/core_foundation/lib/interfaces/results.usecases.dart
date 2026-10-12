import 'package:freezed_annotation/freezed_annotation.dart';

part 'results.usecases.freezed.dart';

/// Immutable result returned by a use case.
@freezed
sealed class ResultState<T> with _$ResultState<T> {
  /// Creates a successful result containing [data].
  const factory ResultState.success(T data) = ResultSuccess<T>;

  /// Creates a failed result containing [exception].
  const factory ResultState.failure(Exception exception) = ResultFailure<T>;
}
