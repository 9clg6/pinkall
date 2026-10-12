import 'dart:convert';

/// Maximum UTF-8 size accepted for one call-preparation Markdown document.
const int maxCallPreparationMarkdownBytes = 32 * 1024;

/// Validates and normalizes user-provided Markdown used to prepare a call.
///
/// Markdown is intentionally treated as plain text. The backend does not
/// render HTML or interpret directives embedded in this value.
String? normalizeCallPreparationMarkdown(String? raw) {
  if (raw == null) {
    return null;
  }
  _validateUnicodeScalars(raw);
  final String normalized = raw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .trim();
  if (normalized.isEmpty) {
    return null;
  }
  for (final int rune in normalized.runes) {
    final bool allowedWhitespace = rune == 0x09 || rune == 0x0A;
    final bool controlCharacter = rune < 0x20 || (rune >= 0x7F && rune <= 0x9F);
    if (controlCharacter && !allowedWhitespace) {
      throw const FormatException(
        'preparation_markdown contains an unsupported control character.',
      );
    }
  }
  if (utf8.encode(normalized).length > maxCallPreparationMarkdownBytes) {
    throw const FormatException(
      'preparation_markdown exceeds the 32 KiB UTF-8 limit.',
    );
  }
  return normalized;
}

void _validateUnicodeScalars(String value) {
  for (int index = 0; index < value.length; index += 1) {
    final int unit = value.codeUnitAt(index);
    if (unit >= 0xD800 && unit <= 0xDBFF) {
      if (index + 1 >= value.length) {
        throw const FormatException(
          'preparation_markdown must contain valid Unicode.',
        );
      }
      final int next = value.codeUnitAt(index + 1);
      if (next < 0xDC00 || next > 0xDFFF) {
        throw const FormatException(
          'preparation_markdown must contain valid Unicode.',
        );
      }
      index += 1;
      continue;
    }
    if (unit >= 0xDC00 && unit <= 0xDFFF) {
      throw const FormatException(
        'preparation_markdown must contain valid Unicode.',
      );
    }
  }
}
