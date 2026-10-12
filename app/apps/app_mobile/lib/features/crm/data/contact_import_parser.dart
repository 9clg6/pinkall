import 'dart:convert';

import 'package:core_domain/core_domain.dart';

/// Parses user-pasted CSV or JSON into normalized backend import rows.
final class ContactImportParser {
  const ContactImportParser._();

  /// Parses [rawInput] without persisting or inventing any contact data.
  static List<ContactImportRowParam> parse(String rawInput) {
    final String input = rawInput.trim();
    if (input.isEmpty) {
      throw const FormatException('Colle au moins un contact CSV ou JSON.');
    }
    if (input.startsWith('[') || input.startsWith('{')) {
      return _parseJson(input);
    }
    return _parseCsv(input);
  }

  static List<ContactImportRowParam> _parseJson(String input) {
    final Object? decoded = jsonDecode(input);
    final List<dynamic> rows;
    if (decoded is List<dynamic>) {
      rows = decoded;
    } else if (decoded is Map<String, dynamic>) {
      final Object? nested = decoded['items'] ?? decoded['contacts'];
      rows = nested is List<dynamic> ? nested : <dynamic>[decoded];
    } else {
      throw const FormatException(
        'Le JSON doit être un objet contact ou une liste de contacts.',
      );
    }
    return _normalizeRows(rows);
  }

  static List<ContactImportRowParam> _parseCsv(String input) {
    final List<String> lines = const LineSplitter()
        .convert(input)
        .where((String line) => line.trim().isNotEmpty)
        .toList(growable: false);
    if (lines.length < 2) {
      throw const FormatException(
        'Le CSV doit contenir un en-tête et au moins une ligne.',
      );
    }
    final List<String> headers = _parseCsvRow(
      lines.first,
    ).map<String>(_normalizedKey).toList(growable: false);
    final List<Map<String, dynamic>> rows = <Map<String, dynamic>>[];
    for (final String line in lines.skip(1)) {
      final List<String> values = _parseCsvRow(line);
      final Map<String, dynamic> row = <String, dynamic>{};
      for (int index = 0; index < headers.length; index += 1) {
        row[headers[index]] = index < values.length ? values[index].trim() : '';
      }
      rows.add(row);
    }
    return _normalizeRows(rows);
  }

  static List<ContactImportRowParam> _normalizeRows(List<dynamic> rawRows) {
    final List<ContactImportRowParam> rows = <ContactImportRowParam>[];
    for (int index = 0; index < rawRows.length; index += 1) {
      final dynamic rawRow = rawRows[index];
      if (rawRow is! Map<dynamic, dynamic>) {
        throw FormatException('Le contact ${index + 1} n’est pas un objet.');
      }
      final Map<String, dynamic> row = rawRow.map<String, dynamic>(
        (dynamic key, dynamic value) =>
            MapEntry<String, dynamic>(_normalizedKey(key.toString()), value),
      );
      final String phone = _string(
        row['phone_number'] ??
            row['phone'] ??
            row['number'] ??
            row['telephone'],
      );
      if (phone.isEmpty) {
        throw FormatException(
          'Le contact ${index + 1} n’a pas de numéro (phone_number).',
        );
      }
      rows.add(
        ContactImportRowParam(
          phoneNumber: phone,
          market: _market(row['market']),
          firstName: _nullableString(row['first_name'] ?? row['firstname']),
          lastName: _nullableString(row['last_name'] ?? row['lastname']),
          company: _nullableString(row['company']),
          jobTitle: _nullableString(row['job_title'] ?? row['jobtitle']),
          email: _nullableString(row['email']),
          hasPriorConsent: _nullableBool(
            row['has_prior_consent'] ?? row['prior_consent'],
          ),
          hasOptedOut: _nullableBool(row['has_opted_out'] ?? row['opted_out']),
          professionalRelevanceConfirmed: _nullableBool(
            row['professional_relevance_confirmed'] ??
                row['professional_relevance'],
          ),
        ),
      );
    }
    if (rows.isEmpty) {
      throw const FormatException('Aucun contact exploitable dans cet import.');
    }
    return List<ContactImportRowParam>.unmodifiable(rows);
  }

  static List<String> _parseCsvRow(String line) {
    final List<String> values = <String>[];
    final StringBuffer current = StringBuffer();
    bool quoted = false;
    for (int index = 0; index < line.length; index += 1) {
      final String character = line[index];
      if (character == '"') {
        final bool escaped =
            quoted && index + 1 < line.length && line[index + 1] == '"';
        if (escaped) {
          current.write('"');
          index += 1;
        } else {
          quoted = !quoted;
        }
      } else if (character == ',' && !quoted) {
        values.add(current.toString());
        current.clear();
      } else {
        current.write(character);
      }
    }
    if (quoted) {
      throw const FormatException('Guillemet CSV non fermé.');
    }
    values.add(current.toString());
    return values;
  }

  static String _normalizedKey(String value) => value
      .trim()
      .replaceAll(RegExp(r'([a-z0-9])([A-Z])'), r'$1_$2')
      .toLowerCase()
      .replaceAll(RegExp(r'[\s-]+'), '_');

  static ContactMarket _market(Object? value) =>
      switch (_string(value).toLowerCase()) {
        'b2b' || 'business' || 'professionnel' => ContactMarket.b2b,
        'b2c' || 'consumer' || 'particulier' => ContactMarket.b2c,
        _ => ContactMarket.unknown,
      };

  static bool? _nullableBool(Object? value) {
    if (value is bool) {
      return value;
    }
    return switch (_string(value).toLowerCase()) {
      'true' || '1' || 'yes' || 'oui' => true,
      'false' || '0' || 'no' || 'non' => false,
      _ => null,
    };
  }

  static String _string(Object? value) => value?.toString().trim() ?? '';

  static String? _nullableString(Object? value) {
    final String text = _string(value);
    return text.isEmpty ? null : text;
  }
}
