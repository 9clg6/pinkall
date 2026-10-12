import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/calls/presentation/screens/home/dialer_phone_number.dart';

void main() {
  group('normalizeDialerPhoneNumber', () {
    test('converts French 06 and 07 national numbers to E.164', () {
      expect(normalizeDialerPhoneNumber('0649452325'), '+33649452325');
      expect(normalizeDialerPhoneNumber('0712345678'), '+33712345678');
    });

    test('accepts common spacing and punctuation in French numbers', () {
      expect(normalizeDialerPhoneNumber('06 49 45 23 25'), '+33649452325');
      expect(normalizeDialerPhoneNumber('07-12-34-56-78'), '+33712345678');
      expect(normalizeDialerPhoneNumber('06.49.45.23.25'), '+33649452325');
    });

    test('preserves already international numbers', () {
      expect(normalizeDialerPhoneNumber('+33649452325'), '+33649452325');
      expect(normalizeDialerPhoneNumber('+44 20 7946 0958'), '+442079460958');
      expect(normalizeDialerPhoneNumber('+1 (415) 555-2671'), '+14155552671');
    });

    test('accepts 00 prefix and French international trunk notation', () {
      expect(normalizeDialerPhoneNumber('0033 6 49 45 23 25'), '+33649452325');
      expect(
        normalizeDialerPhoneNumber('+33 (0)6 49 45 23 25'),
        '+33649452325',
      );
      expect(normalizeDialerPhoneNumber('0044 20 7946 0958'), '+442079460958');
    });
  });

  group('isValidDialerPhoneNumber', () {
    test('validates normalized French and general international input', () {
      expect(isValidDialerPhoneNumber('06 49 45 23 25'), isTrue);
      expect(isValidDialerPhoneNumber('07-12-34-56-78'), isTrue);
      expect(isValidDialerPhoneNumber('+442079460958'), isTrue);
    });

    test('rejects incomplete or non-international unsupported input', () {
      expect(isValidDialerPhoneNumber('064945'), isFalse);
      expect(isValidDialerPhoneNumber('1234567890'), isFalse);
      expect(isValidDialerPhoneNumber('+33ABC'), isFalse);
    });
  });
}
