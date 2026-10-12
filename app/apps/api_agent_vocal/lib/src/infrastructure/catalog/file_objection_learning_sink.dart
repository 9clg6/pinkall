import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';

/// Append-safe local learning document for objections awaiting human review.
final class FileObjectionLearningSink implements ObjectionKnowledgeStore {
  FileObjectionLearningSink(this.file);

  final File file;
  Future<void> _writeTail = Future<void>.value();

  @override
  bool get isAvailable => true;

  @override
  String? get unavailableReason => null;

  @override
  List<ObjectionKnowledgeEntry> listEntries() {
    final List<ObjectionKnowledgeEntry> entries = _entries(
      _readDocument(),
    ).map(_knowledgeEntryFromJson).toList(growable: false);
    return entries
      ..sort((ObjectionKnowledgeEntry left, ObjectionKnowledgeEntry right) {
        final int customOrder = right.hasCustomResponse.toString().compareTo(
          left.hasCustomResponse.toString(),
        );
        if (customOrder != 0) {
          return customOrder;
        }
        return right.lastSeenAt.compareTo(left.lastSeenAt);
      });
  }

  @override
  Future<ObjectionKnowledgeEntry> addCustom(CreateCustomObjection command) {
    return _enqueue<ObjectionKnowledgeEntry>(() {
      final String text = command.text.trim();
      final String responseContent = command.responseContent.trim();
      final String category = command.category.trim().toLowerCase();
      final String sourceType = command.responseSourceType.trim().toLowerCase();
      final String? sourceName = _safeSourceName(command.responseSourceName);
      _validateCustomInput(
        category: category,
        text: text,
        responseContent: responseContent,
        sourceType: sourceType,
        sourceName: sourceName,
      );
      final DateTime now = DateTime.now().toUtc();
      final String normalized = _normalize(text);
      final Map<String, Object?> document = _readDocument();
      final List<Map<String, Object?>> entries = _entries(document);
      final Map<String, Object?>? existing = _nearestEntry(
        entries,
        category: category,
        normalized: normalized,
      );
      final Map<String, Object?> entry;
      if (existing == null) {
        entry = _newCustomEntry(
          category: category,
          text: text,
          normalized: normalized,
          responseContent: responseContent,
          sourceType: sourceType,
          sourceName: sourceName,
          observedAt: now,
        );
        entries.add(entry);
      } else {
        entry = existing;
        final String previousOrigin = entry['origin'] as String? ?? 'detected';
        entry
          ..['canonical_text'] = _sanitize(text)
          ..['origin'] = previousOrigin == 'custom'
              ? 'custom'
              : 'detected_and_custom'
          ..['review_status'] = 'live'
          ..['last_seen_at'] = now.toIso8601String()
          ..['custom_response'] = _customResponse(
            content: responseContent,
            sourceType: sourceType,
            sourceName: sourceName,
            updatedAt: now,
          );
      }
      document
        ..['schema_version'] = 1
        ..['updated_at'] = now.toIso8601String()
        ..['entries'] = entries;
      _writeDocument(document);
      return _knowledgeEntryFromJson(entry);
    });
  }

  @override
  Future<ObjectionLearningResult> learn({
    required String sessionId,
    required List<PostCallObjection> objections,
    required List<TranscriptSegment> transcript,
    required DateTime observedAt,
  }) {
    return _enqueue<ObjectionLearningResult>(() {
      if (objections.isEmpty) {
        return const ObjectionLearningResult(
          detectedCount: 0,
          newCount: 0,
          updatedCount: 0,
        );
      }
      final Map<String, Object?> document = _readDocument();
      final List<Map<String, Object?>> entries = _entries(document);
      final Map<String, TranscriptSegment> evidenceById =
          <String, TranscriptSegment>{
            for (final TranscriptSegment segment in transcript)
              if (segment.isFinal && segment.speaker == SpeakerRole.prospect)
                segment.id: segment,
          };
      int newCount = 0;
      int updatedCount = 0;
      for (final PostCallObjection objection in objections) {
        final String normalized = _normalize(objection.text);
        if (normalized.isEmpty) {
          continue;
        }
        final Map<String, Object?>? existing = _nearestEntry(
          entries,
          category: objection.category.name,
          normalized: normalized,
        );
        if (existing == null) {
          entries.add(
            _newEntry(
              sessionId: sessionId,
              objection: objection,
              normalized: normalized,
              evidenceById: evidenceById,
              observedAt: observedAt,
            ),
          );
          newCount += 1;
        } else {
          _mergeEntry(
            existing,
            sessionId: sessionId,
            objection: objection,
            evidenceById: evidenceById,
            observedAt: observedAt,
          );
          updatedCount += 1;
        }
      }
      document
        ..['schema_version'] = 1
        ..['updated_at'] = observedAt.toUtc().toIso8601String()
        ..['entries'] = entries;
      _writeDocument(document);
      return ObjectionLearningResult(
        detectedCount: objections.length,
        newCount: newCount,
        updatedCount: updatedCount,
      );
    });
  }

  Future<T> _enqueue<T>(FutureOr<T> Function() action) {
    final Completer<T> completer = Completer<T>();
    _writeTail = _writeTail.then((_) async {
      try {
        completer.complete(await action());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  Map<String, Object?> _readDocument() {
    if (!file.existsSync()) {
      return <String, Object?>{
        'schema_version': 1,
        'updated_at': null,
        'entries': <Object?>[],
      };
    }
    final Object? decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?> || decoded['schema_version'] != 1) {
      throw const FormatException(
        'The discovered objection document must use schema_version 1.',
      );
    }
    return decoded;
  }

  static List<Map<String, Object?>> _entries(Map<String, Object?> document) {
    final Object? raw = document['entries'];
    if (raw is! List<Object?>) {
      throw const FormatException(
        'The discovered objection document entries field must be an array.',
      );
    }
    return raw
        .map((Object? item) {
          if (item is! Map<String, Object?>) {
            throw const FormatException(
              'Every discovered objection entry must be an object.',
            );
          }
          return Map<String, Object?>.from(item);
        })
        .toList(growable: true);
  }

  static Map<String, Object?>? _nearestEntry(
    List<Map<String, Object?>> entries, {
    required String category,
    required String normalized,
  }) {
    Map<String, Object?>? nearest;
    double nearestScore = 0;
    for (final Map<String, Object?> entry in entries) {
      if (entry['category'] != category) {
        continue;
      }
      final String candidate = entry['normalized_text'] as String? ?? '';
      final double score = _similarity(candidate, normalized);
      if (score > nearestScore) {
        nearest = entry;
        nearestScore = score;
      }
    }
    return nearestScore >= 0.72 ? nearest : null;
  }

  static Map<String, Object?> _newEntry({
    required String sessionId,
    required PostCallObjection objection,
    required String normalized,
    required Map<String, TranscriptSegment> evidenceById,
    required DateTime observedAt,
  }) {
    final String at = observedAt.toUtc().toIso8601String();
    return <String, Object?>{
      'id': 'objection_${_fnv1a('${objection.category.name}|$normalized')}',
      'category': objection.category.name,
      'canonical_text': _sanitize(objection.text),
      'normalized_text': normalized,
      'origin': 'detected',
      'review_status': 'candidate',
      'first_seen_at': at,
      'last_seen_at': at,
      'occurrence_count': 1,
      'response_candidates': <Object?>[
        _responseCandidate(objection, observedAt),
      ],
      'evidence_samples': _evidenceSamples(
        sessionId: sessionId,
        objection: objection,
        evidenceById: evidenceById,
        observedAt: observedAt,
      ),
    };
  }

  static Map<String, Object?> _newCustomEntry({
    required String category,
    required String text,
    required String normalized,
    required String responseContent,
    required String sourceType,
    required String? sourceName,
    required DateTime observedAt,
  }) {
    final String at = observedAt.toUtc().toIso8601String();
    return <String, Object?>{
      'id': 'objection_${_fnv1a('$category|$normalized')}',
      'category': category,
      'canonical_text': _sanitize(text),
      'normalized_text': normalized,
      'origin': 'custom',
      'review_status': 'live',
      'first_seen_at': at,
      'last_seen_at': at,
      'occurrence_count': 0,
      'response_candidates': <Object?>[],
      'evidence_samples': <Object?>[],
      'custom_response': _customResponse(
        content: responseContent,
        sourceType: sourceType,
        sourceName: sourceName,
        updatedAt: observedAt,
      ),
    };
  }

  static Map<String, Object?> _customResponse({
    required String content,
    required String sourceType,
    required String? sourceName,
    required DateTime updatedAt,
  }) {
    return <String, Object?>{
      'content': content,
      'source_type': sourceType,
      'source_name': sourceName,
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  static ObjectionKnowledgeEntry _knowledgeEntryFromJson(
    Map<String, Object?> json,
  ) {
    final Object? rawResponse = json['custom_response'];
    final Map<String, Object?>? response = rawResponse is Map<String, Object?>
        ? rawResponse
        : null;
    return ObjectionKnowledgeEntry(
      id: _requiredStoredString(json, 'id'),
      category: _requiredStoredString(json, 'category'),
      text: _requiredStoredString(json, 'canonical_text'),
      reviewStatus: _requiredStoredString(json, 'review_status'),
      origin: ObjectionKnowledgeOrigin.parse(
        json['origin'] as String? ?? 'detected',
      ),
      occurrenceCount: json['occurrence_count'] as int? ?? 0,
      firstSeenAt: DateTime.parse(
        _requiredStoredString(json, 'first_seen_at'),
      ).toUtc(),
      lastSeenAt: DateTime.parse(
        _requiredStoredString(json, 'last_seen_at'),
      ).toUtc(),
      responseContent: response?['content'] as String?,
      responseSourceType: response?['source_type'] as String?,
      responseSourceName: response?['source_name'] as String?,
    );
  }

  static String _requiredStoredString(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Stored objection $key must be a string.');
    }
    return value.trim();
  }

  static void _validateCustomInput({
    required String category,
    required String text,
    required String responseContent,
    required String sourceType,
    required String? sourceName,
  }) {
    PostCallObjectionCategory.parse(category);
    if (text.length < 3 || text.length > 1000) {
      throw const FormatException(
        'Objection text must contain between 3 and 1000 characters.',
      );
    }
    if (responseContent.isEmpty ||
        utf8.encode(responseContent).length > 32 * 1024) {
      throw const FormatException(
        'Custom response must contain between 1 byte and 32 KiB.',
      );
    }
    if (sourceType != 'text' && sourceType != 'file') {
      throw const FormatException('Response source type must be text or file.');
    }
    if (sourceType == 'file' && sourceName == null) {
      throw const FormatException('A file response requires a source name.');
    }
    if (sourceType == 'file' &&
        !_allowedResponseFileExtensions.any(
          (String extension) => sourceName!.toLowerCase().endsWith(extension),
        )) {
      throw const FormatException(
        'A file response must be a Markdown or plain-text document.',
      );
    }
  }

  static const Set<String> _allowedResponseFileExtensions = <String>{
    '.md',
    '.markdown',
    '.txt',
  };

  static String? _safeSourceName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final String normalized = value
        .trim()
        .replaceAll('\\', '/')
        .split('/')
        .last;
    if (normalized.length > 160 ||
        !RegExp(r'^[A-Za-z0-9À-ÿ._ ()-]+$').hasMatch(normalized)) {
      throw const FormatException('Invalid response source file name.');
    }
    return normalized;
  }

  static void _mergeEntry(
    Map<String, Object?> entry, {
    required String sessionId,
    required PostCallObjection objection,
    required Map<String, TranscriptSegment> evidenceById,
    required DateTime observedAt,
  }) {
    entry
      ..['last_seen_at'] = observedAt.toUtc().toIso8601String()
      ..['occurrence_count'] = (entry['occurrence_count'] as int? ?? 0) + 1;
    final List<Object?> responses = _objectList(entry['response_candidates']);
    final Map<String, Object?> response = _responseCandidate(
      objection,
      observedAt,
    );
    final String responseKey = _normalize(
      response['suggested_response']! as String,
    );
    final bool alreadyKnown = responses.whereType<Map<String, Object?>>().any(
      (Map<String, Object?> item) =>
          _normalize(item['suggested_response'] as String? ?? '') ==
          responseKey,
    );
    if (!alreadyKnown && responses.length < 5) {
      responses.add(response);
    }
    entry['response_candidates'] = responses;
    final List<Object?> samples = _objectList(entry['evidence_samples']);
    if (samples.length < 5) {
      samples.addAll(
        _evidenceSamples(
          sessionId: sessionId,
          objection: objection,
          evidenceById: evidenceById,
          observedAt: observedAt,
        ).take(5 - samples.length),
      );
    }
    entry['evidence_samples'] = samples;
  }

  static Map<String, Object?> _responseCandidate(
    PostCallObjection objection,
    DateTime observedAt,
  ) {
    return <String, Object?>{
      'response_angle': _sanitize(objection.responseAngle),
      'suggested_response': _sanitize(objection.suggestedResponse),
      'confidence': objection.confidence,
      'review_status': 'candidate',
      'observed_at': observedAt.toUtc().toIso8601String(),
    };
  }

  static List<Object?> _evidenceSamples({
    required String sessionId,
    required PostCallObjection objection,
    required Map<String, TranscriptSegment> evidenceById,
    required DateTime observedAt,
  }) {
    return objection.evidenceSegmentIds
        .map((String id) => evidenceById[id])
        .whereType<TranscriptSegment>()
        .take(3)
        .map<Object?>((TranscriptSegment segment) {
          return <String, Object?>{
            'session_ref': _fnv1a(sessionId),
            'segment_ref': _fnv1a(segment.id),
            'excerpt': _sanitize(segment.text),
            'observed_at': observedAt.toUtc().toIso8601String(),
          };
        })
        .toList(growable: false);
  }

  void _writeDocument(Map<String, Object?> document) {
    file.parent.createSync(recursive: true);
    final File temporary = File('${file.path}.tmp');
    temporary.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(document)}\n',
      flush: true,
    );
    temporary.renameSync(file.path);
  }

  static List<Object?> _objectList(Object? raw) {
    return raw is List<Object?> ? List<Object?>.from(raw) : <Object?>[];
  }

  static double _similarity(String left, String right) {
    if (left == right) {
      return 1;
    }
    final Set<String> leftTokens = _tokens(left);
    final Set<String> rightTokens = _tokens(right);
    if (leftTokens.isEmpty || rightTokens.isEmpty) {
      return 0;
    }
    final int intersection = leftTokens.intersection(rightTokens).length;
    final int union = leftTokens.union(rightTokens).length;
    return intersection / union;
  }

  static Set<String> _tokens(String text) {
    const Set<String> ignored = <String>{
      'a',
      'au',
      'aux',
      'ce',
      'ces',
      'de',
      'des',
      'du',
      'en',
      'et',
      'est',
      'il',
      'je',
      'la',
      'le',
      'les',
      'mais',
      'ne',
      'nous',
      'on',
      'pas',
      'pour',
      'que',
      'qui',
      'sur',
      'un',
      'une',
      'vous',
    };
    return _normalize(text)
        .split(' ')
        .where((String token) => token.length > 1 && !ignored.contains(token))
        .toSet();
  }

  static String _normalize(String value) {
    String normalized = value.toLowerCase().trim();
    const Map<String, String> replacements = <String, String>{
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'î': 'i',
      'ï': 'i',
      'ô': 'o',
      'ö': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ÿ': 'y',
      'œ': 'oe',
    };
    replacements.forEach((String source, String target) {
      normalized = normalized.replaceAll(source, target);
    });
    normalized = normalized
        .replaceAll(RegExp(r'\b(chere?|chers?|couteux|tarif|budget)\b'), 'prix')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return normalized;
  }

  static String _sanitize(String value) {
    String sanitized = value
        .replaceAll(
          RegExp(
            r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',
            caseSensitive: false,
          ),
          '[email]',
        )
        .replaceAll(RegExp(r'https?://\S+', caseSensitive: false), '[url]')
        .replaceAll(RegExp(r'\+?\d[\d .()\-]{7,}\d'), '[phone]')
        .replaceAll(RegExp(r'\b\d{6,}\b'), '[number]')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (sanitized.length > 280) {
      sanitized = '${sanitized.substring(0, 277)}...';
    }
    return sanitized;
  }

  static String _fnv1a(String value) {
    int hash = 0xcbf29ce484222325;
    for (final int byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0xffffffffffffffff;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
