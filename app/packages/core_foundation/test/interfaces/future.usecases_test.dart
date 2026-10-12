import 'dart:async';

import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  test('uses a fifteen second timeout by default', () {
    expect(defaultFutureUseCaseTimeout, const Duration(seconds: 15));
  });

  group('FutureUseCase', () {
    test('wraps a successful value', () async {
      final ResultState<String> result = await _SuccessfulUseCase().execute();

      expect(result, isA<ResultSuccess<String>>());
      expect((result as ResultSuccess<String>).data, 'success');
    });

    test('wraps an exception as a failure', () async {
      final Exception exception = Exception('failure');
      final ResultState<String> result = await _FailingUseCase(
        exception,
      ).execute();

      expect(result, isA<ResultFailure<String>>());
      expect((result as ResultFailure<String>).exception, same(exception));
    });

    test('fails when execution exceeds its timeout', () async {
      final ResultState<String> result = await _SlowUseCase().execute();

      expect(result, isA<ResultFailure<String>>());
      expect(
        (result as ResultFailure<String>).exception,
        isA<TimeoutException>(),
      );
    });
  });

  group('FutureUseCaseWithParams', () {
    test('passes parameters to invoke and wraps the result', () async {
      final ResultState<int> result = await _DoubleUseCase().execute(21);

      expect(result, isA<ResultSuccess<int>>());
      expect((result as ResultSuccess<int>).data, 42);
    });
  });
}

final class _SuccessfulUseCase extends FutureUseCase<String> {
  @override
  Future<String> invoke() async => 'success';
}

final class _FailingUseCase extends FutureUseCase<String> {
  _FailingUseCase(this._exception);

  final Exception _exception;

  @override
  Future<String> invoke() async => throw _exception;
}

final class _SlowUseCase extends FutureUseCase<String> {
  _SlowUseCase() : super(timeout: const Duration(milliseconds: 1));

  @override
  Future<String> invoke() async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return 'late';
  }
}

final class _DoubleUseCase extends FutureUseCaseWithParams<int, int> {
  @override
  Future<int> invoke(int params) async => params * 2;
}
