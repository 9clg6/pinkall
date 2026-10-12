import 'dart:convert';

/// Maximum UTF-8 size accepted for the workspace's reusable sales pitch.
const int maxWorkspacePitchMarkdownBytes = 16 * 1024;

/// Immutable, versioned company and product context used for sales coaching.
final class WorkspaceSalesContext {
  const WorkspaceSalesContext._({
    required this.companyName,
    required this.productName,
    required this.pitchMarkdown,
    required this.revision,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkspaceSalesContext.create({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required DateTime now,
  }) {
    final DateTime timestamp = now.toUtc();
    return WorkspaceSalesContext._(
      companyName: _normalizeName(companyName, 'company_name'),
      productName: _normalizeName(productName, 'product_name'),
      pitchMarkdown: _normalizePitchMarkdown(pitchMarkdown),
      revision: 1,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  factory WorkspaceSalesContext.fromJson(Map<String, Object?> json) {
    final int revision = _requiredRevision(json['revision']);
    final DateTime createdAt = _requiredTimestamp(
      json['created_at'],
      'created_at',
    );
    final DateTime updatedAt = _requiredTimestamp(
      json['updated_at'],
      'updated_at',
    );
    if (updatedAt.isBefore(createdAt)) {
      throw const FormatException(
        'updated_at cannot be earlier than created_at.',
      );
    }
    return WorkspaceSalesContext._(
      companyName: _normalizeName(
        _requiredString(json['company_name'], 'company_name'),
        'company_name',
      ),
      productName: _normalizeName(
        _requiredString(json['product_name'], 'product_name'),
        'product_name',
      ),
      pitchMarkdown: _normalizePitchMarkdown(
        _requiredString(json['pitch_markdown'], 'pitch_markdown'),
      ),
      revision: revision,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final String companyName;
  final String productName;
  final String pitchMarkdown;
  final int revision;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkspaceSalesContext update({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required DateTime now,
  }) {
    final DateTime candidate = now.toUtc();
    final DateTime nextUpdatedAt = candidate.isAfter(updatedAt)
        ? candidate
        : updatedAt.add(const Duration(microseconds: 1));
    return WorkspaceSalesContext._(
      companyName: _normalizeName(companyName, 'company_name'),
      productName: _normalizeName(productName, 'product_name'),
      pitchMarkdown: _normalizePitchMarkdown(pitchMarkdown),
      revision: revision + 1,
      createdAt: createdAt,
      updatedAt: nextUpdatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'company_name': companyName,
      'product_name': productName,
      'pitch_markdown': pitchMarkdown,
      'revision': revision,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }
}

/// Optimistic concurrency failure for a workspace-context update.
final class WorkspaceSalesContextRevisionConflict implements Exception {
  const WorkspaceSalesContextRevisionConflict({
    required this.expectedRevision,
    required this.actualRevision,
  });

  final int? expectedRevision;
  final int? actualRevision;

  @override
  String toString() => 'WorkspaceSalesContextRevisionConflict';
}

String _normalizeName(String raw, String field) {
  _validateUnicodeScalars(raw, field);
  final String normalized = raw.trim();
  if (normalized.isEmpty) {
    throw FormatException('$field is required.');
  }
  for (final int rune in normalized.runes) {
    if (rune < 0x20 || (rune >= 0x7F && rune <= 0x9F)) {
      throw FormatException(
        '$field contains an unsupported control character.',
      );
    }
  }
  if (utf8.encode(normalized).length > 512) {
    throw FormatException('$field exceeds the 512-byte UTF-8 limit.');
  }
  return normalized;
}

String _normalizePitchMarkdown(String raw) {
  _validateUnicodeScalars(raw, 'pitch_markdown');
  final String normalized = raw
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .trim();
  if (normalized.isEmpty) {
    throw const FormatException('pitch_markdown is required.');
  }
  for (final int rune in normalized.runes) {
    final bool allowedWhitespace = rune == 0x09 || rune == 0x0A;
    final bool controlCharacter = rune < 0x20 || (rune >= 0x7F && rune <= 0x9F);
    if (controlCharacter && !allowedWhitespace) {
      throw const FormatException(
        'pitch_markdown contains an unsupported control character.',
      );
    }
  }
  if (utf8.encode(normalized).length > maxWorkspacePitchMarkdownBytes) {
    throw const FormatException(
      'pitch_markdown exceeds the 16 KiB UTF-8 limit.',
    );
  }
  return normalized;
}

String _requiredString(Object? value, String field) {
  if (value is! String) {
    throw FormatException('$field must be a string.');
  }
  return value;
}

int _requiredRevision(Object? value) {
  if (value is! int || value < 1) {
    throw const FormatException('revision must be a positive integer.');
  }
  return value;
}

DateTime _requiredTimestamp(Object? value, String field) {
  if (value is! String) {
    throw FormatException('$field must be an ISO-8601 timestamp.');
  }
  final DateTime? parsed = DateTime.tryParse(value);
  if (parsed == null) {
    throw FormatException('$field must be an ISO-8601 timestamp.');
  }
  return parsed.toUtc();
}

void _validateUnicodeScalars(String value, String field) {
  for (int index = 0; index < value.length; index += 1) {
    final int unit = value.codeUnitAt(index);
    if (unit >= 0xD800 && unit <= 0xDBFF) {
      if (index + 1 >= value.length) {
        throw FormatException('$field must contain valid Unicode.');
      }
      final int next = value.codeUnitAt(index + 1);
      if (next < 0xDC00 || next > 0xDFFF) {
        throw FormatException('$field must contain valid Unicode.');
      }
      index += 1;
      continue;
    }
    if (unit >= 0xDC00 && unit <= 0xDFFF) {
      throw FormatException('$field must contain valid Unicode.');
    }
  }
}
