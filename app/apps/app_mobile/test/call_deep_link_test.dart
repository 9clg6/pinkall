import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/calls/domain/deep_links/call_deep_link.dart';

void main() {
  group('parseCallDeepLink', () {
    test(
      'accepts the Pinkall custom scheme and normalizes national numbers',
      () {
        final CallDeepLink? link = parseCallDeepLink(
          Uri.parse('pinkall://call?number=06%2049%2045%2023%2025'),
        );

        expect(link?.phoneNumber, '+33649452325');
      },
    );

    test('accepts the canonical Pinkall HTTPS host', () {
      expect(
        parseCallDeepLink(
          Uri.parse('https://www.pinkall.app/call?number=0712345678'),
        )?.phoneNumber,
        '+33712345678',
      );
    });

    test('preserves a literal unencoded plus in the query value', () {
      final CallDeepLink? link = parseCallDeepLink(
        Uri.parse('pinkall://call?number=+33612345678'),
      );

      expect(link?.phoneNumber, '+33612345678');
    });

    test('accepts unrelated query parameters without changing the number', () {
      final CallDeepLink? link = parseCallDeepLink(
        Uri.parse(
          'https://www.pinkall.app/call?source=crm&number=%2B442079460958',
        ),
      );

      expect(link?.phoneNumber, '+442079460958');
    });

    test('treats schemes and hosts as case insensitive', () {
      final CallDeepLink? link = parseCallDeepLink(
        Uri.parse('PINKALL://CALL?number=0649452325'),
      );

      expect(link?.phoneNumber, '+33649452325');
    });

    test('rejects unsupported schemes', () {
      expect(
        parseCallDeepLink(
          Uri.parse('http://www.pinkall.app/call?number=%2B33612345678'),
        ),
        isNull,
      );
      expect(parseCallDeepLink(Uri.parse('tel:+33612345678')), isNull);
    });

    test('rejects unsupported hosts', () {
      expect(
        parseCallDeepLink(Uri.parse('pinkall://dial?number=%2B33612345678')),
        isNull,
      );
      expect(
        parseCallDeepLink(
          Uri.parse('https://pinkall.app/call?number=%2B33612345678'),
        ),
        isNull,
      );
      expect(
        parseCallDeepLink(
          Uri.parse(
            'https://pinkall.app.example.com/call?number=%2B33612345678',
          ),
        ),
        isNull,
      );
    });

    test('rejects unknown or non-canonical paths', () {
      expect(
        parseCallDeepLink(
          Uri.parse('pinkall://call/history?number=%2B33612345678'),
        ),
        isNull,
      );
      expect(
        parseCallDeepLink(
          Uri.parse('https://www.pinkall.app/?number=%2B33612345678'),
        ),
        isNull,
      );
      expect(
        parseCallDeepLink(
          Uri.parse('https://www.pinkall.app/call/?number=%2B33612345678'),
        ),
        isNull,
      );
    });

    test('rejects missing, empty, or duplicate number values', () {
      expect(parseCallDeepLink(Uri.parse('pinkall://call')), isNull);
      expect(parseCallDeepLink(Uri.parse('pinkall://call?number=')), isNull);
      expect(
        parseCallDeepLink(
          Uri.parse(
            'pinkall://call?number=%2B33612345678&number=%2B33712345678',
          ),
        ),
        isNull,
      );
    });

    test('rejects invalid or unsupported phone number forms', () {
      expect(
        parseCallDeepLink(Uri.parse('pinkall://call?number=064945')),
        isNull,
      );
      expect(
        parseCallDeepLink(Uri.parse('pinkall://call?number=1234567890')),
        isNull,
      );
      expect(
        parseCallDeepLink(Uri.parse('pinkall://call?number=%2B33ABC')),
        isNull,
      );
    });

    test('rejects user info and non-default ports', () {
      expect(
        parseCallDeepLink(
          Uri.parse('https://user@pinkall.app/call?number=%2B33612345678'),
        ),
        isNull,
      );
      expect(
        parseCallDeepLink(
          Uri.parse('https://pinkall.app:444/call?number=%2B33612345678'),
        ),
        isNull,
      );
    });
  });
}
