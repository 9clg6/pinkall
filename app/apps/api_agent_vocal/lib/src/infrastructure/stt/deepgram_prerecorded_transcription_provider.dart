import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:http/http.dart' as http;

/// Deepgram prerecorded transcription with provider-side speaker diarization.
///
/// Speaker numbers remain opaque [DiarizedRecordingSegment.voiceId] values.
/// Human roles are assigned later by the application only after the user
/// explicitly identifies their own voice.
final class DeepgramPrerecordedTranscriptionProvider
    implements RecordedCallTranscriptionProvider {
  DeepgramPrerecordedTranscriptionProvider({
    required String apiKey,
    required this.baseUrl,
    required this.model,
    required this.diarizeModel,
    http.Client? httpClient,
    this.requestTimeout = const Duration(minutes: 12),
  }) : _apiKey = apiKey,
       _httpClient = httpClient ?? http.Client();

  static const int _maxResponseBytes = 32 * 1024 * 1024;

  final String _apiKey;
  final String baseUrl;
  final String model;
  final String diarizeModel;
  final Duration requestTimeout;
  final http.Client _httpClient;

  @override
  bool get isConfigured =>
      _apiKey.isNotEmpty &&
      baseUrl.isNotEmpty &&
      model.isNotEmpty &&
      diarizeModel.isNotEmpty;

  @override
  String get name => 'deepgram_prerecorded';

  @override
  Future<DiarizedRecordingTranscript> transcribe({
    required RecordedAudioInput audio,
    required String locale,
  }) async {
    if (!isConfigured) {
      throw const RecordedTranscriptionException(
        code: 'provider_unavailable',
        message: 'Deepgram prerecorded transcription is not configured.',
        retryable: true,
      );
    }
    if (audio.sizeBytes <= 0) {
      throw const RecordedTranscriptionException(
        code: 'empty_audio',
        message: 'The recording is empty.',
        retryable: false,
      );
    }

    final Uri endpoint = _listenEndpoint(Uri.parse(baseUrl), locale: locale);
    final http.StreamedRequest request = http.StreamedRequest('POST', endpoint)
      ..headers[HttpHeaders.authorizationHeader] = 'Token $_apiKey'
      ..headers[HttpHeaders.contentTypeHeader] = audio.mimeType
      ..contentLength = audio.sizeBytes;
    late final http.StreamedResponse response;
    try {
      final Future<http.StreamedResponse> responseFuture = _httpClient
          .send(request)
          .timeout(requestTimeout);
      await request.sink.addStream(audio.openRead());
      await request.sink.close();
      response = await responseFuture;
    } on TimeoutException {
      throw const RecordedTranscriptionException(
        code: 'provider_timeout',
        message: 'Deepgram did not finish transcription in time.',
        retryable: true,
      );
    } on RecordedTranscriptionException {
      rethrow;
    } on Object {
      throw const RecordedTranscriptionException(
        code: 'provider_unreachable',
        message: 'Deepgram prerecorded transcription is unreachable.',
        retryable: true,
      );
    }

    final Uint8List responseBytes;
    try {
      responseBytes = await _readBounded(
        response.stream,
        maxBytes: _maxResponseBytes,
      );
    } on Object {
      throw const RecordedTranscriptionException(
        code: 'invalid_provider_response',
        message: 'Deepgram returned an unreadable response.',
        retryable: true,
      );
    }
    final String responseBody = utf8.decode(
      responseBytes,
      allowMalformed: true,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RecordedTranscriptionException(
        code: response.statusCode == HttpStatus.tooManyRequests
            ? 'provider_rate_limited'
            : 'provider_rejected_audio',
        message: _safeProviderFailure(response.statusCode, responseBody),
        retryable:
            response.statusCode == HttpStatus.tooManyRequests ||
            response.statusCode >= HttpStatus.internalServerError,
      );
    }

    final Map<String, Object?> document = _jsonObject(responseBody);
    final Map<String, Object?> metadata = _object(document['metadata']);
    final double? durationSeconds = _double(metadata['duration']);
    if (durationSeconds == null ||
        !durationSeconds.isFinite ||
        durationSeconds <= 0) {
      throw const RecordedTranscriptionException(
        code: 'missing_audio_duration',
        message: 'Deepgram did not return a valid audio duration.',
        retryable: true,
      );
    }
    final Map<String, Object?> results = _object(document['results']);
    List<DiarizedRecordingSegment> segments = _utteranceSegments(
      results['utterances'],
    );
    segments = segments.isEmpty ? _wordSegments(results['channels']) : segments;
    if (segments.isEmpty) {
      throw const RecordedTranscriptionException(
        code: 'diarization_missing',
        message: 'No diarized speech was detected in the recording.',
        retryable: false,
      );
    }
    return DiarizedRecordingTranscript(
      durationSeconds: durationSeconds,
      language: _detectedLanguage(results) ?? _language(locale),
      segments: List<DiarizedRecordingSegment>.unmodifiable(segments),
      provider: '$name:$model:$diarizeModel',
    );
  }

  @override
  Future<void> dispose() async {
    _httpClient.close();
  }

  Uri _listenEndpoint(Uri base, {required String locale}) {
    final String trimmedPath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final String path = trimmedPath.endsWith('/v1/listen')
        ? trimmedPath
        : '$trimmedPath/v1/listen';
    return base.replace(
      path: path,
      queryParameters: <String, String>{
        ...base.queryParameters,
        'model': model,
        'language': _language(locale),
        'smart_format': 'true',
        'punctuate': 'true',
        'utterances': 'true',
        'diarize_model': diarizeModel,
        'mip_opt_out': 'true',
      },
    );
  }

  static List<DiarizedRecordingSegment> _utteranceSegments(Object? raw) {
    if (raw is! List<Object?>) {
      return const <DiarizedRecordingSegment>[];
    }
    final List<DiarizedRecordingSegment> segments =
        <DiarizedRecordingSegment>[];
    for (final Object? value in raw) {
      if (value is! Map<String, Object?>) {
        continue;
      }
      final String text = value['transcript'] is String
          ? (value['transcript']! as String).trim()
          : '';
      final String? voiceId = _voiceId(value['speaker']);
      final double? start = _double(value['start']);
      final double? end = _double(value['end']);
      if (text.isEmpty ||
          voiceId == null ||
          start == null ||
          end == null ||
          !start.isFinite ||
          !end.isFinite ||
          start < 0 ||
          end < start) {
        continue;
      }
      segments.add(
        DiarizedRecordingSegment(
          voiceId: voiceId,
          text: text,
          startSeconds: start,
          endSeconds: end,
          confidence: _confidence(value['confidence']),
        ),
      );
    }
    segments.sort(
      (DiarizedRecordingSegment left, DiarizedRecordingSegment right) =>
          left.startSeconds.compareTo(right.startSeconds),
    );
    return segments;
  }

  static List<DiarizedRecordingSegment> _wordSegments(Object? rawChannels) {
    if (rawChannels is! List<Object?> || rawChannels.isEmpty) {
      return const <DiarizedRecordingSegment>[];
    }
    final Object? firstChannel = rawChannels.first;
    if (firstChannel is! Map<String, Object?>) {
      return const <DiarizedRecordingSegment>[];
    }
    final Object? rawAlternatives = firstChannel['alternatives'];
    if (rawAlternatives is! List<Object?> || rawAlternatives.isEmpty) {
      return const <DiarizedRecordingSegment>[];
    }
    final Object? firstAlternative = rawAlternatives.first;
    if (firstAlternative is! Map<String, Object?> ||
        firstAlternative['words'] is! List<Object?>) {
      return const <DiarizedRecordingSegment>[];
    }
    final List<_DiarizedWord> words = <_DiarizedWord>[];
    for (final Object? rawWord in firstAlternative['words']! as List<Object?>) {
      if (rawWord is! Map<String, Object?>) {
        continue;
      }
      final String? voiceId = _voiceId(rawWord['speaker']);
      final double? start = _double(rawWord['start']);
      final double? end = _double(rawWord['end']);
      final String text = switch (rawWord['punctuated_word']) {
        final String punctuated when punctuated.trim().isNotEmpty =>
          punctuated.trim(),
        _ when rawWord['word'] is String => (rawWord['word']! as String).trim(),
        _ => '',
      };
      if (voiceId == null ||
          start == null ||
          end == null ||
          text.isEmpty ||
          start < 0 ||
          end < start) {
        continue;
      }
      words.add(
        _DiarizedWord(
          voiceId: voiceId,
          text: text,
          startSeconds: start,
          endSeconds: end,
          confidence: _confidence(rawWord['confidence']),
        ),
      );
    }
    final List<DiarizedRecordingSegment> segments =
        <DiarizedRecordingSegment>[];
    _WordTurn? turn;
    for (final _DiarizedWord word in words) {
      final bool startsNewTurn =
          turn == null ||
          turn.voiceId != word.voiceId ||
          word.startSeconds - turn.endSeconds > 1.2;
      if (startsNewTurn) {
        if (turn != null) {
          segments.add(turn.segment);
        }
        turn = _WordTurn.fromWord(word);
      } else {
        turn.add(word);
      }
    }
    if (turn != null) {
      segments.add(turn.segment);
    }
    return segments;
  }

  static String? _detectedLanguage(Map<String, Object?> results) {
    final Object? channels = results['channels'];
    if (channels is! List<Object?> || channels.isEmpty) {
      return null;
    }
    final Object? first = channels.first;
    if (first is! Map<String, Object?>) {
      return null;
    }
    final Object? detected = first['detected_language'];
    return detected is String && detected.trim().isNotEmpty
        ? detected.trim()
        : null;
  }

  static String _language(String locale) {
    return locale.trim().split(RegExp('[-_]')).first.toLowerCase();
  }

  static Map<String, Object?> _jsonObject(String body) {
    try {
      final Object? decoded = jsonDecode(body);
      if (decoded is Map<String, Object?>) {
        return decoded;
      }
    } on FormatException {
      // Converted to a provider-safe error below.
    }
    throw const RecordedTranscriptionException(
      code: 'invalid_provider_response',
      message: 'Deepgram returned invalid JSON.',
      retryable: true,
    );
  }

  static Map<String, Object?> _object(Object? value) {
    return value is Map<String, Object?> ? value : const <String, Object?>{};
  }

  static String? _voiceId(Object? value) {
    return switch (value) {
      int number when number >= 0 => number.toString(),
      String text when text.trim().isNotEmpty => text.trim(),
      _ => null,
    };
  }

  static double? _double(Object? value) {
    return switch (value) {
      num number => number.toDouble(),
      String text => double.tryParse(text),
      _ => null,
    };
  }

  static double? _confidence(Object? value) {
    final double? confidence = _double(value);
    return confidence != null &&
            confidence.isFinite &&
            confidence >= 0 &&
            confidence <= 1
        ? confidence
        : null;
  }

  static String _safeProviderFailure(int statusCode, String body) {
    String? detail;
    try {
      final Object? decoded = jsonDecode(body);
      if (decoded is Map<String, Object?>) {
        final Object? raw = decoded['err_msg'] ?? decoded['message'];
        if (raw is String && raw.trim().isNotEmpty) {
          detail = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
        }
      }
    } on FormatException {
      detail = null;
    }
    if (detail != null && detail.length > 240) {
      detail = detail.substring(0, 240);
    }
    return detail == null
        ? 'Deepgram rejected the recording ($statusCode).'
        : 'Deepgram rejected the recording ($statusCode): $detail';
  }

  static Future<Uint8List> _readBounded(
    Stream<List<int>> stream, {
    required int maxBytes,
  }) async {
    final BytesBuilder builder = BytesBuilder(copy: false);
    int length = 0;
    await for (final List<int> chunk in stream) {
      length += chunk.length;
      if (length > maxBytes) {
        throw const FormatException('Provider response is too large.');
      }
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}

final class _DiarizedWord {
  const _DiarizedWord({
    required this.voiceId,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.confidence,
  });

  final String voiceId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final double? confidence;
}

final class _WordTurn {
  _WordTurn.fromWord(_DiarizedWord word)
    : voiceId = word.voiceId,
      startSeconds = word.startSeconds,
      endSeconds = word.endSeconds,
      _words = <String>[word.text],
      _confidences = <double>[if (word.confidence != null) word.confidence!];

  final String voiceId;
  final double startSeconds;
  double endSeconds;
  final List<String> _words;
  final List<double> _confidences;

  void add(_DiarizedWord word) {
    _words.add(word.text);
    endSeconds = word.endSeconds;
    if (word.confidence != null) {
      _confidences.add(word.confidence!);
    }
  }

  DiarizedRecordingSegment get segment {
    final String joined = _words
        .join(' ')
        .replaceAll(RegExp(r'\s+([,.!?;:])'), r'$1');
    final double? confidence = _confidences.isEmpty
        ? null
        : _confidences.reduce((double left, double right) => left + right) /
              _confidences.length;
    return DiarizedRecordingSegment(
      voiceId: voiceId,
      text: joined,
      startSeconds: startSeconds,
      endSeconds: endSeconds,
      confidence: confidence,
    );
  }
}
