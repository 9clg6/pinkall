import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';

/// Deepgram Flux for turn-aware realtime STT with a replaceable batch adapter.
///
/// Flux is deliberately used only for realtime transcription. Pinkall keeps
/// the existing provider-neutral final transcription contract and delegates
/// it to [batchProvider], currently Voxtral.
final class DeepgramFluxSttProvider implements SttProvider {
  DeepgramFluxSttProvider({
    required String apiKey,
    required this.realtimeBaseUrl,
    required this.model,
    required this.languageHint,
    required this.endOfTurnThreshold,
    required this.eagerEndOfTurnThreshold,
    required this.endOfTurnTimeoutMs,
    required this.batchProvider,
  }) : _apiKey = apiKey;

  final String _apiKey;
  final String realtimeBaseUrl;
  final String model;
  final String? languageHint;
  final double endOfTurnThreshold;
  final double? eagerEndOfTurnThreshold;
  final int endOfTurnTimeoutMs;
  final SttProvider batchProvider;

  @override
  bool get isConfigured => _apiKey.isNotEmpty && batchProvider.isConfigured;

  @override
  String get name => 'deepgram_flux';

  @override
  bool get providesSemanticTurnBoundaries => true;

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) {
    if (_apiKey.isEmpty) {
      throw StateError('DEEPGRAM_API_KEY is not configured.');
    }
    return DeepgramFluxRealtimeSession.connect(
      apiKey: _apiKey,
      baseUrl: realtimeBaseUrl,
      model: model,
      languageHint: languageHint,
      endOfTurnThreshold: endOfTurnThreshold,
      eagerEndOfTurnThreshold: eagerEndOfTurnThreshold,
      endOfTurnTimeoutMs: endOfTurnTimeoutMs,
      audioFormat: audioFormat,
    );
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) {
    return batchProvider.transcribeFinal(
      pcmBytes: pcmBytes,
      audioFormat: audioFormat,
      fileName: fileName,
    );
  }
}

/// One direct `/v2/listen` Flux WebSocket for exactly one mono Telnyx track.
final class DeepgramFluxRealtimeSession implements RealtimeSttSession {
  DeepgramFluxRealtimeSession._({
    required WebSocket socket,
    required int audioChunkBytes,
  }) : _socket = socket,
       _audioChunkBytes = audioChunkBytes;

  static const Duration _completionTimeout = Duration(seconds: 15);
  static const int _recommendedChunkDurationMs = 80;
  static const Set<int> _supportedSampleRates = <int>{
    8000,
    16000,
    24000,
    44100,
    48000,
  };

  final WebSocket _socket;
  final int _audioChunkBytes;
  final StreamController<SttEvent> _events = StreamController<SttEvent>();
  final Completer<void> _finished = Completer<void>();
  final List<int> _audioBuffer = <int>[];
  final List<String> _finalTurns = <String>[];
  final Set<int> _finalizedTurnIndexes = <int>{};
  final Set<int> _receivedSequenceIds = <int>{};

  bool _closing = false;
  bool _closed = false;
  bool _failureEmitted = false;
  bool _interimDiverged = false;
  int? _currentTurnIndex;
  String _lastEmittedInterim = '';

  /// Opens the official Deepgram Flux `/v2/listen` endpoint.
  static Future<DeepgramFluxRealtimeSession> connect({
    required String apiKey,
    required String baseUrl,
    required String model,
    required String? languageHint,
    required double endOfTurnThreshold,
    required double? eagerEndOfTurnThreshold,
    required int endOfTurnTimeoutMs,
    required SttAudioFormat audioFormat,
  }) async {
    if (apiKey.isEmpty) {
      throw StateError('DEEPGRAM_API_KEY is not configured.');
    }
    if (audioFormat.encoding != 'pcm_s16le') {
      throw UnsupportedError(
        'Deepgram Flux requires pcm_s16le input, got '
        '${audioFormat.encoding}.',
      );
    }
    if (!_supportedSampleRates.contains(audioFormat.sampleRate)) {
      throw UnsupportedError(
        'Deepgram Flux does not support ${audioFormat.sampleRate} Hz.',
      );
    }
    if (model != 'flux-general-en' && model != 'flux-general-multi') {
      throw ArgumentError.value(model, 'model', 'Unsupported Flux model.');
    }
    if (languageHint != null && model != 'flux-general-multi') {
      throw ArgumentError(
        'languageHint is supported only by flux-general-multi.',
      );
    }

    final Uri endpoint = _buildEndpoint(
      baseUrl: baseUrl,
      model: model,
      languageHint: languageHint,
      endOfTurnThreshold: endOfTurnThreshold,
      eagerEndOfTurnThreshold: eagerEndOfTurnThreshold,
      endOfTurnTimeoutMs: endOfTurnTimeoutMs,
      audioFormat: audioFormat,
    );
    final WebSocket socket = await WebSocket.connect(
      endpoint.toString(),
      headers: <String, String>{
        'Authorization': 'Token $apiKey',
        'User-Agent': 'pinkall-api-agent-vocal/0.1',
      },
      compression: CompressionOptions.compressionOff,
    );
    final int chunkBytes =
        audioFormat.sampleRate *
        2 *
        _recommendedChunkDurationMs ~/
        Duration.millisecondsPerSecond;
    final DeepgramFluxRealtimeSession session = DeepgramFluxRealtimeSession._(
      socket: socket,
      audioChunkBytes: chunkBytes,
    );
    session._listen();
    return session;
  }

  @override
  Stream<SttEvent> get events => _events.stream;

  @override
  Future<void> addAudio(List<int> pcmBytes) async {
    if (_closing || _closed) {
      throw StateError('Deepgram Flux realtime connection is closed.');
    }
    if (pcmBytes.isEmpty) {
      return;
    }
    _audioBuffer.addAll(pcmBytes);
    _sendFullAudioChunks();
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    if (_closing) {
      await _finished.future;
      return;
    }
    _closing = true;
    try {
      _flushAudioBuffer();
      _socket.add(jsonEncode(const <String, String>{'type': 'CloseStream'}));
      await _finished.future.timeout(_completionTimeout);
    } on TimeoutException {
      _emitFailure('Timed out waiting for Deepgram Flux to close the stream.');
    } on Object catch (error) {
      _emitFailure(
        'Deepgram Flux realtime close failed: ${error.runtimeType}.',
      );
    } finally {
      if (!_closed) {
        try {
          await _socket.close(WebSocketStatus.normalClosure);
        } on Object {
          // Final batch transcription is still available through Voxtral.
        }
        await _finish(requested: true);
      }
    }
  }

  static Uri _buildEndpoint({
    required String baseUrl,
    required String model,
    required String? languageHint,
    required double endOfTurnThreshold,
    required double? eagerEndOfTurnThreshold,
    required int endOfTurnTimeoutMs,
    required SttAudioFormat audioFormat,
  }) {
    final Uri base = Uri.parse(baseUrl);
    if (base.scheme != 'ws' && base.scheme != 'wss') {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'Deepgram realtime URL must use ws:// or wss://.',
      );
    }
    final String normalizedBasePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final String endpointPath = normalizedBasePath.endsWith('/v2/listen')
        ? normalizedBasePath
        : '$normalizedBasePath/v2/listen';
    final Map<String, String> query = <String, String>{
      ...base.queryParameters,
      'model': model,
      'encoding': 'linear16',
      'sample_rate': audioFormat.sampleRate.toString(),
      'eot_threshold': endOfTurnThreshold.toString(),
      'eot_timeout_ms': endOfTurnTimeoutMs.toString(),
      if (languageHint != null) 'language_hint': languageHint,
      if (eagerEndOfTurnThreshold != null)
        'eager_eot_threshold': eagerEndOfTurnThreshold.toString(),
    };
    return base.replace(path: endpointPath, queryParameters: query);
  }

  void _listen() {
    _socket.listen(
      _handleMessage,
      onError: (Object error, StackTrace stackTrace) {
        _emitFailure('Deepgram Flux WebSocket failed: ${error.runtimeType}.');
      },
      onDone: () {
        unawaited(_finish(requested: _closing));
      },
      cancelOnError: false,
    );
  }

  void _handleMessage(Object? frame) {
    if (_closed) {
      return;
    }
    if (frame is! String) {
      _emitFailure('Deepgram Flux returned a non-text control frame.');
      return;
    }
    try {
      final Object? raw = jsonDecode(frame);
      if (raw is! Map) {
        throw const FormatException('Expected a JSON object.');
      }
      final Map<String, Object?> message = Map<String, Object?>.from(raw);
      final int? sequenceId = _integer(message['sequence_id']);
      if (sequenceId != null && !_receivedSequenceIds.add(sequenceId)) {
        return;
      }
      final String? type = message['type'] is String
          ? message['type']! as String
          : null;
      if (type == 'TurnInfo') {
        _handleTurnInfo(message);
        return;
      }
      if (type == 'Error' || message['code'] is String) {
        _emitFailure(_providerError(message));
      }
      // Metadata and future non-transcript control events are safe to ignore.
    } on Object catch (error) {
      _emitFailure('Invalid Deepgram Flux event: ${error.runtimeType}.');
    }
  }

  void _handleTurnInfo(Map<String, Object?> message) {
    final String? event = message['event'] is String
        ? message['event']! as String
        : null;
    final int? turnIndex = _integer(message['turn_index']);
    if (event != null) {
      _events.add(
        SttTurnTelemetry(
          event: event,
          turnIndex: turnIndex,
          sequenceId: _integer(message['sequence_id']),
          audioWindowStart: _number(message['audio_window_start']),
          audioWindowEnd: _number(message['audio_window_end']),
          endOfTurnConfidence: _number(message['end_of_turn_confidence']),
        ),
      );
    }
    switch (event) {
      case 'Update':
      case 'StartOfTurn':
        _emitInterim(message, turnIndex);
      case 'EagerEndOfTurn':
        _emitInterim(message, turnIndex);
        _emitEagerTurnEnd(message, turnIndex);
      case 'TurnResumed':
        _emitInterim(message, turnIndex);
        _events.add(SttTurnResumed(providerTurnId: _providerTurnId(turnIndex)));
      case 'EndOfTurn':
        _emitEndOfTurn(message, turnIndex);
      case null:
        _emitFailure('Deepgram Flux TurnInfo event is missing its event type.');
      default:
        // Forward-compatible: unknown state-machine events are ignored.
        break;
    }
  }

  void _emitEagerTurnEnd(Map<String, Object?> message, int? turnIndex) {
    final String transcript = _transcript(message);
    if (transcript.isEmpty) {
      return;
    }
    final ({double start, double end}) timing = _timing(message);
    _events.add(
      SttEagerTurnEnd(
        text: transcript,
        startSeconds: timing.start,
        endSeconds: timing.end,
        providerTurnId: _providerTurnId(turnIndex),
      ),
    );
  }

  void _emitInterim(Map<String, Object?> message, int? turnIndex) {
    if (_currentTurnIndex != turnIndex) {
      _resetInterim(turnIndex);
    }
    final String transcript = _transcript(message);
    if (transcript.isEmpty || _interimDiverged) {
      return;
    }
    if (_lastEmittedInterim.isEmpty) {
      _lastEmittedInterim = transcript;
      _events.add(SttTextDelta(transcript));
      return;
    }
    if (!transcript.startsWith(_lastEmittedInterim)) {
      // Flux interim text may revise earlier words. The domain delta contract
      // is append-only, so wait for the authoritative EndOfTurn instead of
      // fabricating a destructive delta.
      _interimDiverged = true;
      return;
    }
    final String suffix = transcript.substring(_lastEmittedInterim.length);
    _lastEmittedInterim = transcript;
    if (suffix.isNotEmpty) {
      _events.add(SttTextDelta(suffix));
    }
  }

  void _emitEndOfTurn(Map<String, Object?> message, int? turnIndex) {
    if (turnIndex != null && !_finalizedTurnIndexes.add(turnIndex)) {
      return;
    }
    final String transcript = _transcript(message);
    final ({double start, double end}) timing = _timing(message);
    if (transcript.isNotEmpty) {
      _finalTurns.add(transcript);
      _events.add(
        SttSegment(
          text: transcript,
          startSeconds: timing.start,
          endSeconds: timing.end,
          isTurnEnd: true,
          providerTurnId: _providerTurnId(turnIndex),
        ),
      );
    }
    _resetInterim(null);
  }

  static String? _providerTurnId(int? turnIndex) => turnIndex?.toString();

  ({double start, double end}) _timing(Map<String, Object?> message) {
    double? start;
    double? end;
    final Object? rawWords = message['words'];
    if (rawWords is List) {
      for (final Object? rawWord in rawWords) {
        if (rawWord is! Map) {
          continue;
        }
        final Map<String, Object?> word = Map<String, Object?>.from(rawWord);
        start ??= _number(word['start']);
        end = _number(word['end']) ?? end;
      }
    }
    start ??= _number(message['audio_window_start']) ?? 0;
    end ??= _number(message['audio_window_end']) ?? start;
    if (end < start) {
      end = start;
    }
    return (start: start, end: end);
  }

  void _sendFullAudioChunks() {
    while (_audioBuffer.length >= _audioChunkBytes) {
      final Uint8List chunk = Uint8List.fromList(
        _audioBuffer.sublist(0, _audioChunkBytes),
      );
      _audioBuffer.removeRange(0, _audioChunkBytes);
      _socket.add(chunk);
    }
  }

  void _flushAudioBuffer() {
    _sendFullAudioChunks();
    if (_audioBuffer.isEmpty) {
      return;
    }
    _socket.add(Uint8List.fromList(_audioBuffer));
    _audioBuffer.clear();
  }

  void _resetInterim(int? turnIndex) {
    _currentTurnIndex = turnIndex;
    _lastEmittedInterim = '';
    _interimDiverged = false;
  }

  Future<void> _finish({required bool requested}) async {
    if (_closed) {
      if (!_finished.isCompleted) {
        _finished.complete();
      }
      return;
    }
    _closed = true;
    if (!requested) {
      _emitFailure('Deepgram Flux closed the realtime stream unexpectedly.');
    } else if (!_events.isClosed) {
      _events.add(SttDone(_finalTurns.join(' ')));
    }
    if (!_events.isClosed) {
      await _events.close();
    }
    if (!_finished.isCompleted) {
      _finished.complete();
    }
  }

  void _emitFailure(String message) {
    if (_failureEmitted || _events.isClosed) {
      return;
    }
    _failureEmitted = true;
    _events.add(SttFailure(message));
  }

  static String _transcript(Map<String, Object?> message) {
    final Object? value = message['transcript'];
    return value is String ? value.trim() : '';
  }

  static int? _integer(Object? value) {
    return value is num && value.isFinite ? value.toInt() : null;
  }

  static double? _number(Object? value) {
    return value is num && value.isFinite ? value.toDouble() : null;
  }

  static String _providerError(Map<String, Object?> message) {
    final Object? description = message['description'] ?? message['message'];
    final String normalized = description is String
        ? description.replaceAll(RegExp(r'\s+'), ' ').trim()
        : 'realtime transcription error';
    final String bounded = normalized.length <= 300
        ? normalized
        : normalized.substring(0, 300);
    return 'Deepgram Flux error: $bounded';
  }
}
