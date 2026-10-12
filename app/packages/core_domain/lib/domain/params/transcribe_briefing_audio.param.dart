import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcribe_briefing_audio.param.freezed.dart';

/// Raw mono PCM captured while the user dictates a briefing.
@freezed
abstract class TranscribeBriefingAudioParam
    with _$TranscribeBriefingAudioParam {
  /// Creates captured audio parameters for provider-neutral transcription.
  const factory TranscribeBriefingAudioParam({
    /// Signed 16-bit little-endian mono PCM.
    required Uint8List pcmBytes,

    /// Effective recorder sample rate in Hertz.
    required int sampleRate,
  }) = _TranscribeBriefingAudioParam;
}
