import 'dart:async';

import 'package:core_data/clients/macos_call_audio_capture.client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// ScreenCaptureKit client backed by Pinkall's macOS runner channels.
final class MethodChannelMacosCallAudioCaptureClientImpl
    implements MacosCallAudioCaptureClient {
  /// Creates the production client or injects channels for focused tests.
  MethodChannelMacosCallAudioCaptureClientImpl({
    MethodChannel methodChannel = const MethodChannel(_methodChannelName),
    EventChannel systemAudioChannel = const EventChannel(
      _systemAudioChannelName,
    ),
    EventChannel microphoneAudioChannel = const EventChannel(
      _microphoneAudioChannelName,
    ),
    bool Function()? isMacOS,
  }) : _methodChannel = methodChannel,
       _systemAudioChannel = systemAudioChannel,
       _microphoneAudioChannel = microphoneAudioChannel,
       _isMacOS = isMacOS ?? _defaultIsMacOS;

  static const String _methodChannelName =
      'com.pinkall.call_audio_capture/methods';
  static const String _systemAudioChannelName =
      'com.pinkall.call_audio_capture/system_audio';
  static const String _microphoneAudioChannelName =
      'com.pinkall.call_audio_capture/microphone_audio';
  static const Set<int> _supportedSampleRates = <int>{
    8000,
    16000,
    24000,
    32000,
    44100,
    48000,
  };

  final MethodChannel _methodChannel;
  final EventChannel _systemAudioChannel;
  final EventChannel _microphoneAudioChannel;
  final bool Function() _isMacOS;

  late final Stream<Uint8List> _systemAudio = _decodedAudio(
    _systemAudioChannel,
  );
  late final Stream<Uint8List> _microphoneAudio = _decodedAudio(
    _microphoneAudioChannel,
  );
  bool _starting = false;
  bool _running = false;
  bool _disposed = false;

  @override
  Stream<Uint8List> get systemAudio => _systemAudio;

  @override
  Stream<Uint8List> get microphoneAudio => _microphoneAudio;

  @override
  Future<void> start({int sampleRate = 16000}) async {
    _ensureAvailable();
    if (!_supportedSampleRates.contains(sampleRate)) {
      throw MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.channelFailure,
        message: 'Unsupported PCM sample rate: $sampleRate Hz.',
      );
    }
    if (_running || _starting) {
      throw const MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.alreadyRunning,
        message: 'A macOS call-audio capture session is already running.',
      );
    }
    _starting = true;
    try {
      await _methodChannel.invokeMethod<void>('start', <String, Object?>{
        'sampleRate': sampleRate,
      });
      if (_disposed) {
        throw const MacosCallAudioCaptureException(
          failure: MacosCallAudioCaptureFailure.disposed,
          message: 'The macOS call-audio capture client was disposed.',
        );
      }
      _running = true;
    } on MacosCallAudioCaptureException {
      rethrow;
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    } on MissingPluginException catch (error) {
      throw MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.unsupportedPlatform,
        message: 'The macOS call-audio capture bridge is unavailable.',
        details: error.message,
      );
    } finally {
      _starting = false;
    }
  }

  @override
  Future<void> stop() async {
    _ensureAvailable();
    if (!_running) {
      throw const MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.notRunning,
        message: 'No macOS call-audio capture session is running.',
      );
    }
    try {
      await _methodChannel.invokeMethod<void>('stop');
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    } finally {
      // Native stop tears down the session even when ScreenCaptureKit reports
      // a flush error, so the local state must not advertise a live capture.
      _running = false;
    }
  }

  @override
  Future<void> cancel() async {
    _ensureAvailable();
    try {
      await _methodChannel.invokeMethod<void>('cancel');
      _running = false;
    } on PlatformException catch (error) {
      throw _platformFailure(error);
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    try {
      if ((_running || _starting) && _isMacOS()) {
        await _methodChannel.invokeMethod<void>('cancel');
      }
    } on Object {
      // Disposal is best-effort; explicit stop/cancel calls surface failures.
    } finally {
      _starting = false;
      _running = false;
    }
  }

  void _ensureAvailable() {
    if (_disposed) {
      throw const MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.disposed,
        message: 'The macOS call-audio capture client is disposed.',
      );
    }
    if (!_isMacOS()) {
      throw const MacosCallAudioCaptureException(
        failure: MacosCallAudioCaptureFailure.unsupportedPlatform,
        message: 'System call-audio capture is available only on macOS.',
      );
    }
  }

  static bool _defaultIsMacOS() =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  static Stream<Uint8List> _decodedAudio(EventChannel channel) {
    return channel.receiveBroadcastStream().transform<Uint8List>(
      StreamTransformer<Object?, Uint8List>.fromHandlers(
        handleData: (Object? value, EventSink<Uint8List> sink) {
          if (value is Uint8List) {
            sink.add(value);
            return;
          }
          if (value is ByteData) {
            sink.add(
              value.buffer.asUint8List(
                value.offsetInBytes,
                value.lengthInBytes,
              ),
            );
            return;
          }
          if (value is List<int>) {
            sink.add(Uint8List.fromList(value));
            return;
          }
          sink.addError(
            MacosCallAudioCaptureException(
              failure: MacosCallAudioCaptureFailure.channelFailure,
              message: 'Native audio event was not a PCM byte buffer.',
              details: value.runtimeType.toString(),
            ),
          );
        },
        handleError:
            (Object error, StackTrace stackTrace, EventSink<Uint8List> sink) {
              sink.addError(
                error is PlatformException
                    ? _platformFailure(error)
                    : MacosCallAudioCaptureException(
                        failure: MacosCallAudioCaptureFailure.captureFailure,
                        message:
                            'The native audio stream stopped unexpectedly.',
                        details: error.toString(),
                      ),
                stackTrace,
              );
            },
      ),
    );
  }

  static MacosCallAudioCaptureException _platformFailure(
    PlatformException error,
  ) {
    final MacosCallAudioCaptureFailure failure = switch (error.code) {
      'unsupported_os' =>
        MacosCallAudioCaptureFailure.unsupportedOperatingSystem,
      'screen_capture_permission_denied' =>
        MacosCallAudioCaptureFailure.screenCapturePermissionDenied,
      'microphone_permission_denied' =>
        MacosCallAudioCaptureFailure.microphonePermissionDenied,
      'capture_already_running' => MacosCallAudioCaptureFailure.alreadyRunning,
      'capture_not_running' => MacosCallAudioCaptureFailure.notRunning,
      'invalid_arguments' ||
      'invalid_audio_event' => MacosCallAudioCaptureFailure.channelFailure,
      _ => MacosCallAudioCaptureFailure.captureFailure,
    };
    return MacosCallAudioCaptureException(
      failure: failure,
      message: error.message ?? 'Native macOS call-audio capture failed.',
      details: error.details,
    );
  }
}
