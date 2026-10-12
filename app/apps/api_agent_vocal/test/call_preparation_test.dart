import 'package:api_agent_vocal/src/domain/call_preparation.dart';
import 'package:test/test.dart';

void main() {
  test('normalizes valid Markdown without stripping its structure', () {
    expect(
      normalizeCallPreparationMarkdown(
        '  # Objectif\r\n\r\n- Découvrir le budget\r- Confirmer le délai 🚀  ',
      ),
      '# Objectif\n\n- Découvrir le budget\n- Confirmer le délai 🚀',
    );
    expect(normalizeCallPreparationMarkdown(' \n\t '), isNull);
  });

  test('enforces the UTF-8 byte limit rather than Dart character count', () {
    expect(
      normalizeCallPreparationMarkdown(
        List<String>.filled(maxCallPreparationMarkdownBytes ~/ 4, '🚀').join(),
      ),
      isNotNull,
    );
    expect(
      () => normalizeCallPreparationMarkdown(
        '${List<String>.filled(maxCallPreparationMarkdownBytes ~/ 4, '🚀').join()}a',
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects binary controls and malformed Unicode', () {
    expect(
      () => normalizeCallPreparationMarkdown('# Objectif\u0000secret'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => normalizeCallPreparationMarkdown(String.fromCharCode(0xD800)),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => normalizeCallPreparationMarkdown(String.fromCharCode(0xDC00)),
      throwsA(isA<FormatException>()),
    );
  });
}
