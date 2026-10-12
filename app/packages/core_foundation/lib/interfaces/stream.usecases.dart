import 'package:core_foundation/interfaces/results.usecases.dart';
import 'package:core_foundation/interfaces/usecase.interfaces.dart';

/// Base class for a stream use case without parameters.
abstract class StreamUseCase<T> implements BaseUseCase<Stream<ResultState<T>>> {
  /// Creates a stream use case.
  const StreamUseCase();

  @override
  Stream<ResultState<T>> execute() => _streamCatcher<T>(invoke);

  /// Produces the values implemented by a concrete use case.
  Stream<T> invoke();
}

/// Base class for a stream use case with [P] parameters.
abstract class StreamUseCaseWithParams<T, P>
    implements BaseUseCaseWithParams<Stream<ResultState<T>>, P> {
  /// Creates a parameterized stream use case.
  const StreamUseCaseWithParams();

  @override
  Stream<ResultState<T>> execute(P params) =>
      _streamCatcher<T>(() => invoke(params));

  /// Produces the values implemented by a concrete use case.
  Stream<T> invoke(P params);
}

Stream<ResultState<T>> _streamCatcher<T>(
  Stream<T> Function() operation,
) async* {
  try {
    await for (final T value in operation()) {
      yield ResultState<T>.success(value);
    }
  } on Exception catch (exception) {
    yield ResultState<T>.failure(exception);
  } catch (error) {
    yield ResultState<T>.failure(Exception(error.toString()));
  }
}
