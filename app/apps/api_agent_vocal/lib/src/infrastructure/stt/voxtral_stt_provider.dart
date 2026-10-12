import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:http/http.dart' as http;

/// Official Mistral Voxtral Realtime protocol implemented behind [SttProvider].
final class VoxtralSttProvider implements SttProvider {
  VoxtralSttProvider({
    required String apiKey,
    required this.realtimeBaseUrl,
    required this.realtimeModel,
    required this.batchBaseUrl,
    required this.batchModel,
    required this.targetDelayMs,
    http.Client? httpClient,
  }) : _apiKey = apiKey,
       _httpClient = httpClient ?? http.Client();

  final String _apiKey;
  final String realtimeBaseUrl;
  final String realtimeModel;
  final String batchBaseUrl;
  final String batchModel;
  final int targetDelayMs;
  final http.Client _httpClient;

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  String get name => 'mistral_voxtral';

  @override
  bool get providesSemanticTurnBoundaries => false;

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) {
    if (!isConfigured) {
      throw StateError('MISTRAL_API_KEY is not configured.');
    }
    return VoxtralRealtimeSession.connect(
      apiKey: _apiKey,
      baseUrl: realtimeBaseUrl,
      model: realtimeModel,
      audioFormat: audioFormat,
      targetDelayMs: targetDelayMs,
    );
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) async {
    if (!isConfigured) {
      throw StateError('MISTRAL_API_KEY is not configured.');
    }
    if (pcmBytes.isEmpty) {
      throw ArgumentError.value(pcmBytes, 'pcmBytes', 'Audio cannot be empty.');
    }
    if (audioFormat.encoding != 'pcm_s16le') {
      throw UnsupportedError(
        'Batch WAV currently requires pcm_s16le, got ${audioFormat.encoding}.',
      );
    }

    final Uri endpoint = _appendPath(
      Uri.parse(batchBaseUrl),
      '/v1/audio/transcriptions',
    );
    final http.MultipartRequest request =
        http.MultipartRequest('POST', endpoint)
          ..headers['Authorization'] = 'Bearer $_apiKey'
          ..fields['model'] = batchModel
          ..fields['timestamp_granularities'] = 'segment'
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              _createWaveFile(
                pcmBytes,
                sampleRate: audioFormat.sampleRate,
                channels: 1,
              ),
              filename: fileName,
            ),
          );

    final http.StreamedResponse streamed = await _httpClient.send(request);
    final String body = await streamed.stream.bytesToString();
    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw HttpException(
        'Mistral batch transcription failed (${streamed.statusCode}): '
        '${_safeProviderError(body)}',
        uri: endpoint,
      );
    }

    final Object? decoded = jsonDecode(body);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Mistral response was not a JSON object.');
    }
    final String text = decoded['text'] is String
        ? decoded['text']! as String
        : '';
    final List<BatchTranscriptSegment> segments = <BatchTranscriptSegment>[];
    final Object? rawSegments = decoded['segments'];
    if (rawSegments is List<Object?>) {
      for (final Object? raw in rawSegments) {
        if (raw is! Map<String, Object?> || raw['text'] is! String) {
          continue;
        }
        segments.add(
          BatchTranscriptSegment(
            text: raw['text']! as String,
            startSeconds: _double(raw['start']) ?? 0,
            endSeconds: _double(raw['end']) ?? 0,
          ),
        );
      }
    }
    return BatchTranscript(
      text: text,
      language: decoded['language'] is String
          ? decoded['language']! as String
          : null,
      segments: segments,
      provider: '$name:$batchModel',
    );
  }

  static Uri _appendPath(Uri base, String suffix) {
    final String basePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    return base.replace(path: '$basePath$suffix');
  }

  static String _safeProviderError(String body) {
    final String normalized = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    return normalized.length <= 500 ? normalized : normalized.substring(0, 500);
  }

  static double? _double(Object? value) {
    return switch (value) {
      num number => number.toDouble(),
      String text => double.tryParse(text),
      _ => null,
    };
  }

  static Uint8List _createWaveFile(
    List<int> pcmBytes, {
    required int sampleRate,
    required int channels,
  }) {
    final int dataLength = pcmBytes.length;
    final Uint8List output = Uint8List(44 + dataLength);
    final ByteData header = ByteData.sublistView(output);
    void writeAscii(int offset, String value) {
      output.setRange(offset, offset + value.length, ascii.encode(value));
    }

    writeAscii(0, 'RIFF');
    header.setUint32(4, 36 + dataLength, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little);
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, sampleRate * channels * 2, Endian.little);
    header.setUint16(32, channels * 2, Endian.little);
    header.setUint16(34, 16, Endian.little);
    writeAscii(36, 'data');
    header.setUint32(40, dataLength, Endian.little);
    output.setRange(44, output.length, pcmBytes);
    return output;
  }
}

/// One raw Mistral WebSocket session, following their official SDK messages.
final class VoxtralRealtimeSession implements RealtimeSttSession {
  VoxtralRealtimeSession._(this._socket);

  static const int _maxDecodedChunkBytes = 262144;
  static const Duration _handshakeTimeout = Duration(seconds: 10);
  static const Duration _completionTimeout = Duration(seconds: 15);

  final WebSocket _socket;
  final StreamController<SttEvent> _events = StreamController<SttEvent>();
  final Completer<void> _sessionCreated = Completer<void>();
  final Completer<void> _transcriptionDone = Completer<void>();
  bool _closed = false;

  /// Opens the official `/v1/audio/transcriptions/realtime` endpoint.
  static Future<VoxtralRealtimeSession> connect({
    required String apiKey,
    required String baseUrl,
    required String model,
    required SttAudioFormat audioFormat,
    required int targetDelayMs,
  }) async {
    final Uri base = Uri.parse(baseUrl);
    final String basePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final Uri endpoint = base.replace(
      path: '$basePath/v1/audio/transcriptions/realtime',
      queryParameters: <String, String>{'model': model},
    );
    final WebSocket socket = await WebSocket.connect(
      endpoint.toString(),
      headers: <String, String>{
        'Authorization': 'Bearer $apiKey',
        'User-Agent': 'pinkall-api-agent-vocal/0.1',
      },
    );
    final VoxtralRealtimeSession session = VoxtralRealtimeSession._(socket);
    session._listen();
    try {
      await session._sessionCreated.future.timeout(_handshakeTimeout);
    } on Object {
      await socket.close(WebSocketStatus.normalClosure);
      await session._closeEvents();
      rethrow;
    }
    session._socket.add(
      jsonEncode(<String, Object?>{
        'type': 'session.update',
        'session': <String, Object?>{
          'audio_format': <String, Object?>{
            'encoding': audioFormat.encoding,
            'sample_rate': audioFormat.sampleRate,
          },
          'target_streaming_delay_ms': targetDelayMs,
        },
      }),
    );
    return session;
  }

  @override
  Stream<SttEvent> get events => _events.stream;

  @override
  Future<void> addAudio(List<int> pcmBytes) async {
    if (_closed) {
      throw StateError('Voxtral realtime connection is closed.');
    }
    for (
      int start = 0;
      start < pcmBytes.length;
      start += _maxDecodedChunkBytes
    ) {
      final int end = (start + _maxDecodedChunkBytes).clamp(0, pcmBytes.length);
      _socket.add(
        jsonEncode(<String, Object?>{
          'type': 'input_audio.append',
          'audio': base64Encode(pcmBytes.sublist(start, end)),
        }),
      );
    }
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    try {
      _socket
        ..add(jsonEncode(<String, String>{'type': 'input_audio.flush'}))
        ..add(jsonEncode(<String, String>{'type': 'input_audio.end'}));
      await _transcriptionDone.future.timeout(_completionTimeout);
    } on TimeoutException {
      _emitFailure('Timed out waiting for Voxtral transcription.done.');
    } on Object catch (error) {
      _emitFailure('Voxtral realtime close failed: ${error.runtimeType}.');
    } finally {
      try {
        await _socket.close(WebSocketStatus.normalClosure);
      } on Object {
        // Realtime close is deliberately fail-soft. The buffered batch audio
        // remains the source of truth for post-call finalization.
      }
      await _closeEvents();
    }
  }

  void _listen() {
    _socket.listen(
      _handleMessage,
      onError: (Object error, StackTrace stackTrace) {
        final String message = 'Voxtral WebSocket failed: $error';
        if (!_sessionCreated.isCompleted) {
          _sessionCreated.completeError(StateError(message), stackTrace);
        }
        if (!_transcriptionDone.isCompleted) {
          _transcriptionDone.complete();
        }
        _emitFailure(message);
      },
      onDone: () {
        _closed = true;
        if (!_sessionCreated.isCompleted) {
          _sessionCreated.completeError(
            StateError('Voxtral closed before session.created.'),
          );
        }
        if (!_transcriptionDone.isCompleted) {
          _transcriptionDone.complete();
        }
        unawaited(_closeEvents());
      },
      cancelOnError: false,
    );
  }

  void _handleMessage(dynamic message) {
    if (message is! String) {
      _events.add(const SttFailure('Voxtral returned a non-text frame.'));
      return;
    }
    try {
      final Object? decoded = jsonDecode(message);
      if (decoded is! Map<String, Object?>) {
        throw const FormatException('Expected a JSON object.');
      }
      final String? type = decoded['type'] is String
          ? decoded['type']! as String
          : null;
      switch (type) {
        case 'session.created':
          if (!_sessionCreated.isCompleted) {
            _sessionCreated.complete();
          }
          break;
        case 'session.updated':
          break;
        case 'transcription.text.delta':
          final String? text = decoded['text'] is String
              ? decoded['text']! as String
              : null;
          if (text != null && text.isNotEmpty) {
            _events.add(SttTextDelta(text));
          }
          break;
        case 'transcription.segment':
          final String? text = decoded['text'] is String
              ? decoded['text']! as String
              : null;
          if (text != null && text.trim().isNotEmpty) {
            _events.add(
              SttSegment(
                text: text.trim(),
                startSeconds: _number(decoded['start']),
                endSeconds: _number(decoded['end']),
              ),
            );
          }
          break;
        case 'transcription.done':
          final String text = decoded['text'] is String
              ? decoded['text']! as String
              : '';
          _events.add(SttDone(text));
          if (!_transcriptionDone.isCompleted) {
            _transcriptionDone.complete();
          }
          break;
        case 'error':
          final String message = _readError(decoded);
          _emitFailure(message);
          if (!_sessionCreated.isCompleted) {
            _sessionCreated.completeError(StateError(message));
          }
          if (!_transcriptionDone.isCompleted) {
            _transcriptionDone.complete();
          }
          break;
        default:
          break;
      }
    } on Object catch (error) {
      _events.add(SttFailure('Invalid Voxtral event: $error'));
    }
  }

  static double _number(Object? value) {
    return switch (value) {
      num number => number.toDouble(),
      String text => double.tryParse(text) ?? 0,
      _ => 0,
    };
  }

  static String _readError(Map<String, Object?> event) {
    final Object? error = event['error'];
    if (error is Map<String, Object?>) {
      final Object? message = error['message'];
      if (message is String) {
        return 'Voxtral error: $message';
      }
      if (message is Map<String, Object?> && message['detail'] is String) {
        return 'Voxtral error: ${message['detail']}';
      }
    }
    return 'Voxtral realtime transcription error.';
  }

  void _emitFailure(String message) {
    if (!_events.isClosed) {
      _events.add(SttFailure(message));
    }
  }

  Future<void> _closeEvents() async {
    if (!_events.isClosed) {
      await _events.close();
    }
  }
}
