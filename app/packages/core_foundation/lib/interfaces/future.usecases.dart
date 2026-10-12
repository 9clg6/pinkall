import 'dart:async';

import 'package:core_foundation/interfaces/results.usecases.dart';
import 'package:core_foundation/interfaces/usecase.interfaces.dart';

/// Default maximum duration of an asynchronous use case execution.
const Duration defaultFutureUseCaseTimeout = Duration(seconds: 15);

/// Base class for an asynchronous use case without parameters.
abstract class FutureUseCase<T> implements BaseUseCase<Future<ResultState<T>>> {
  /// Creates a use case with an optional execution [timeout].
  const FutureUseCase({Duration timeout = defaultFutureUseCaseTimeout})
    : _timeout = timeout;

  final Duration _timeout;

  @override
  Future<ResultState<T>> execute() => _futureCatcher<T>(invoke, _timeout);

  /// Performs the operation implemented by a concrete use case.
  Future<T> invoke();
}

/// Base class for an asynchronous use case with [P] parameters.
abstract class FutureUseCaseWithParams<T, P>
    implements BaseUseCaseWithParams<Future<ResultState<T>>, P> {
  /// Creates a use case with an optional execution [timeout].
  const FutureUseCaseWithParams({
    Duration timeout = defaultFutureUseCaseTimeout,
  }) : _timeout = timeout;

  final Duration _timeout;

  @override
  Future<ResultState<T>> execute(P params) =>
      _futureCatcher<T>(() => invoke(params), _timeout);

  /// Performs the operation implemented by a concrete use case.
  Future<T> invoke(P params);
}

Future<ResultState<T>> _futureCatcher<T>(
  Future<T> Function() operation,
  Duration timeout,
) async {
  try {
    final T value = await operation().timeout(timeout);
    return ResultState<T>.success(value);
  } on Exception catch (exception) {
    return ResultState<T>.failure(exception);
  } catch (error) {
    return ResultState<T>.failure(Exception(error.toString()));
  }
}
