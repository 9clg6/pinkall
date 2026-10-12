import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('StreamUseCase', () {
    test('wraps every emitted value as a success', () async {
      final List<ResultState<int>> results = await _CounterUseCase()
          .execute()
          .toList();

      expect(results, hasLength(3));
      expect(
        results.map((ResultState<int> result) => result).toList(),
        everyElement(isA<ResultSuccess<int>>()),
      );
      expect(
        results.cast<ResultSuccess<int>>().map(
          (ResultSuccess<int> result) => result.data,
        ),
        <int>[1, 2, 3],
      );
    });

    test('converts stream errors to a failure result', () async {
      final List<ResultState<int>> results = await _FailingStreamUseCase()
          .execute()
          .toList();

      expect(results.first, isA<ResultSuccess<int>>());
      expect(results.last, isA<ResultFailure<int>>());
    });
  });

  test('StreamUseCaseWithParams forwards its parameters', () async {
    final List<ResultState<int>> results = await _RangeUseCase()
        .execute(2)
        .toList();

    expect(
      results.cast<ResultSuccess<int>>().map(
        (ResultSuccess<int> result) => result.data,
      ),
      <int>[0, 1],
    );
  });
}

final class _CounterUseCase extends StreamUseCase<int> {
  @override
  Stream<int> invoke() => Stream<int>.fromIterable(<int>[1, 2, 3]);
}

final class _FailingStreamUseCase extends StreamUseCase<int> {
  @override
  Stream<int> invoke() async* {
    yield 1;
    throw Exception('stream failure');
  }
}

final class _RangeUseCase extends StreamUseCaseWithParams<int, int> {
  @override
  Stream<int> invoke(int params) => Stream<int>.fromIterable(
    List<int>.generate(params, (int index) => index),
  );
}
