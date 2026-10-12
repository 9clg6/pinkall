import 'dart:async';
import 'dart:typed_data';

import 'package:core_data/clients/voice_dictation_recorder.client.dart';
import 'package:record/record.dart';

/// `record` implementation that captures ephemeral mono PCM in memory.
final class RecordVoiceDictationRecorderClientImpl
    implements VoiceDictationRecorderClient {
  /// Creates a recorder capped to a safe short-form briefing payload.
  RecordVoiceDictationRecorderClientImpl({
    this.requestedSampleRate = 16000,
    this.maxAudioBytes = 10 * 1024 * 1024,
  });

  /// Preferred speech-recognition sample rate.
  final int requestedSampleRate;

  /// Maximum in-memory audio size accepted by the matching backend route.
  final int maxAudioBytes;

  final AudioRecorder _recorder = AudioRecorder();
  final Stopwatch _stopwatch = Stopwatch();
  BytesBuilder _bytes = BytesBuilder(copy: false);
  StreamSubscription<Uint8List>? _audioSubscription;
  Completer<void>? _streamDone;
  Object? _streamFailure;
  int _effectiveSampleRate = 16000;
  bool _recording = false;
  bool _disposed = false;

  @override
  Future<void> start() async {
    if (_disposed) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.invalidState,
        'The voice dictation recorder is disposed.',
      );
    }
    if (_recording) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.invalidState,
        'A voice dictation is already being recorded.',
      );
    }
    if (!await _recorder.hasPermission()) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.permissionDenied,
        'Microphone access was denied.',
      );
    }
    if (!await _recorder.isEncoderSupported(AudioEncoder.pcm16bits)) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.inputFailure,
        'PCM16 streaming is not supported on this device.',
      );
    }

    _bytes = BytesBuilder(copy: false);
    _streamFailure = null;
    _effectiveSampleRate = requestedSampleRate;
    _streamDone = Completer<void>();
    await _recorder.setOnConfigChanged((RecordConfig config) {
      _effectiveSampleRate = config.sampleRate;
    });

    try {
      final Stream<Uint8List> stream = await _recorder.startStream(
        RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: requestedSampleRate,
          numChannels: 1,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
          streamBufferSize: 3200,
        ),
      );
      _recording = true;
      _stopwatch
        ..reset()
        ..start();
      _audioSubscription = stream.listen(
        _capture,
        onError: (Object error, StackTrace stackTrace) {
          _streamFailure = error;
          _completeStream();
        },
        onDone: _completeStream,
        cancelOnError: false,
      );
    } on VoiceDictationRecordingException {
      rethrow;
    } on Object catch (error) {
      throw VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.inputFailure,
        'Could not start microphone capture: ${error.runtimeType}.',
      );
    }
  }

  @override
  Future<VoiceDictationRecording> stop() async {
    if (!_recording) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.invalidState,
        'No voice dictation is currently recording.',
      );
    }

    try {
      await _recorder.stop();
      await _awaitStreamCompletion();
    } on Object catch (error) {
      _streamFailure ??= error;
    } finally {
      _stopwatch.stop();
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      _recording = false;
    }

    final Object? streamFailure = _streamFailure;
    if (streamFailure != null) {
      _bytes = BytesBuilder(copy: false);
      if (streamFailure is VoiceDictationRecordingException) {
        throw streamFailure;
      }
      throw VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.inputFailure,
        'Microphone capture failed: ${streamFailure.runtimeType}.',
      );
    }

    final Uint8List bytes = _bytes.takeBytes();
    if (bytes.isEmpty) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.noAudio,
        'The microphone returned no audio.',
      );
    }
    return VoiceDictationRecording(
      pcmBytes: bytes,
      sampleRate: _effectiveSampleRate,
      duration: _stopwatch.elapsed,
    );
  }

  @override
  Future<void> cancel() async {
    if (_recording) {
      try {
        await _recorder.cancel();
      } on Object {
        // Cancellation is best-effort while the widget is leaving the tree.
      }
    }
    _stopwatch
      ..stop()
      ..reset();
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    _recording = false;
    _streamFailure = null;
    _bytes = BytesBuilder(copy: false);
    _completeStream();
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    await cancel();
    await _recorder.dispose();
    _disposed = true;
  }

  void _capture(Uint8List chunk) {
    if (_streamFailure != null || chunk.isEmpty) {
      return;
    }
    if (_bytes.length + chunk.length > maxAudioBytes) {
      _streamFailure = const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.tooLarge,
        'Voice dictation audio exceeds 10 MiB.',
      );
      return;
    }
    _bytes.add(chunk);
  }

  void _completeStream() {
    final Completer<void>? done = _streamDone;
    if (done != null && !done.isCompleted) {
      done.complete();
    }
  }

  Future<void> _awaitStreamCompletion() async {
    final Completer<void>? done = _streamDone;
    if (done == null || done.isCompleted) {
      return;
    }
    try {
      await done.future.timeout(const Duration(seconds: 1));
    } on TimeoutException {
      // `stop` already flushed native audio; do not block the UI indefinitely.
    }
  }
}
