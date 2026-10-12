/// Contract for a use case that does not require parameters.
abstract interface class BaseUseCase<R> {
  /// Executes the use case.
  R execute();
}

/// Contract for a use case that requires [P] parameters.
abstract interface class BaseUseCaseWithParams<R, P> {
  /// Executes the use case with [params].
  R execute(P params);
}
