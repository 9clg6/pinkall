import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('ResultState', () {
    test('stores successful data', () {
      const ResultState<int> result = ResultState<int>.success(42);

      expect(result, isA<ResultSuccess<int>>());
      expect((result as ResultSuccess<int>).data, 42);
    });

    test('stores a failure exception', () {
      final Exception exception = Exception('failure');
      final ResultState<int> result = ResultState<int>.failure(exception);

      expect(result, isA<ResultFailure<int>>());
      expect((result as ResultFailure<int>).exception, same(exception));
    });
  });
}
