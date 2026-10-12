import 'dart:convert';
import 'dart:typed_data';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';

/// Parsed Telnyx Media Streaming frame.
sealed class TelnyxMediaFrame {
  const TelnyxMediaFrame({
    required this.streamId,
    required this.sequenceNumber,
  });

  final String? streamId;
  final int? sequenceNumber;
}

/// Telnyx's WebSocket handshake event, emitted before the media `start` event.
final class TelnyxConnectedFrame extends TelnyxMediaFrame {
  const TelnyxConnectedFrame({required this.version})
    : super(streamId: null, sequenceNumber: null);

  final String? version;
}

/// First WebSocket event, including the actual call media format.
final class TelnyxStartFrame extends TelnyxMediaFrame {
  const TelnyxStartFrame({
    required super.streamId,
    required super.sequenceNumber,
    required this.callControlId,
    required this.callSessionId,
    required this.encoding,
    required this.sampleRate,
    required this.channels,
  });

  final String? callControlId;
  final String? callSessionId;
  final String encoding;
  final int sampleRate;
  final int channels;
}

/// Base64-encoded raw RTP payload without its RTP header.
final class TelnyxAudioFrame extends TelnyxMediaFrame {
  const TelnyxAudioFrame({
    required super.streamId,
    required super.sequenceNumber,
    required this.track,
    required this.chunk,
    required this.timestamp,
    required this.payload,
  });

  final MediaTrack track;
  final int? chunk;
  final int? timestamp;
  final String payload;
}

/// Media stream termination frame.
final class TelnyxStopFrame extends TelnyxMediaFrame {
  const TelnyxStopFrame({
    required super.streamId,
    required super.sequenceNumber,
  });
}

/// Provider error sent over the Telnyx WebSocket.
final class TelnyxErrorFrame extends TelnyxMediaFrame {
  const TelnyxErrorFrame({
    required super.streamId,
    required super.sequenceNumber,
    required this.code,
    required this.title,
    required this.detail,
  });

  final int? code;
  final String? title;
  final String? detail;
}

/// Strict parser for the official Telnyx media-streaming envelopes.
final class TelnyxMediaFrameParser {
  const TelnyxMediaFrameParser();

  TelnyxMediaFrame parse(Object? message) {
    if (message is! String) {
      throw const FormatException('Telnyx frame must be a JSON text frame.');
    }
    final Object? decoded = jsonDecode(message);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Telnyx frame must be a JSON object.');
    }
    final String event = _requiredString(decoded, 'event');
    final String? streamId = _string(decoded['stream_id']);
    final int? sequence = _integer(decoded['sequence_number']);
    return switch (event) {
      'connected' => TelnyxConnectedFrame(version: _string(decoded['version'])),
      'start' => _parseStart(decoded, streamId, sequence),
      'media' => _parseMedia(decoded, streamId, sequence),
      'stop' => TelnyxStopFrame(streamId: streamId, sequenceNumber: sequence),
      'error' => _parseError(decoded, streamId, sequence),
      _ => throw FormatException('Unsupported Telnyx event: $event'),
    };
  }

  TelnyxStartFrame _parseStart(
    Map<String, Object?> root,
    String? streamId,
    int? sequence,
  ) {
    final Map<String, Object?> start = _requiredMap(root, 'start');
    final Map<String, Object?> mediaFormat = _requiredMap(
      start,
      'media_format',
    );
    return TelnyxStartFrame(
      streamId: streamId,
      sequenceNumber: sequence,
      callControlId: _string(start['call_control_id']),
      callSessionId: _string(start['call_session_id']),
      encoding: _requiredString(mediaFormat, 'encoding'),
      sampleRate: _requiredInteger(mediaFormat, 'sample_rate'),
      channels: _requiredInteger(mediaFormat, 'channels'),
    );
  }

  TelnyxAudioFrame _parseMedia(
    Map<String, Object?> root,
    String? streamId,
    int? sequence,
  ) {
    final Map<String, Object?> media = _requiredMap(root, 'media');
    return TelnyxAudioFrame(
      streamId: streamId,
      sequenceNumber: sequence,
      track: MediaTrack.parse(_requiredString(media, 'track')),
      chunk: _integer(media['chunk']),
      timestamp: _integer(media['timestamp']),
      payload: _requiredString(media, 'payload'),
    );
  }

  TelnyxErrorFrame _parseError(
    Map<String, Object?> root,
    String? streamId,
    int? sequence,
  ) {
    final Map<String, Object?> payload = _requiredMap(root, 'payload');
    return TelnyxErrorFrame(
      streamId: streamId,
      sequenceNumber: sequence,
      code: _integer(payload['code']),
      title: _string(payload['title']),
      detail: _string(payload['detail']),
    );
  }

  static Map<String, Object?> _requiredMap(
    Map<String, Object?> source,
    String key,
  ) {
    final Object? value = source[key];
    if (value is Map<String, Object?>) {
      return value;
    }
    throw FormatException('Missing object field: $key');
  }

  static String _requiredString(Map<String, Object?> source, String key) {
    final String? value = _string(source[key]);
    if (value == null || value.isEmpty) {
      throw FormatException('Missing string field: $key');
    }
    return value;
  }

  static int _requiredInteger(Map<String, Object?> source, String key) {
    final int? value = _integer(source[key]);
    if (value == null) {
      throw FormatException('Missing integer field: $key');
    }
    return value;
  }

  static String? _string(Object? value) => value is String ? value : null;

  static int? _integer(Object? value) {
    return switch (value) {
      int number => number,
      num number => number.toInt(),
      String text => int.tryParse(text),
      _ => null,
    };
  }
}

/// Converts common Telnyx telephony codecs into provider-neutral PCM S16LE.
final class TelnyxPcmDecoder {
  const TelnyxPcmDecoder();

  SttAudioFormat outputFormat({
    required String encoding,
    required int sampleRate,
    required int channels,
  }) {
    if (channels != 1) {
      throw UnsupportedError(
        'Only mono Telnyx media is supported by this POC.',
      );
    }
    final String normalized = encoding.trim().toUpperCase();
    if (<String>{
      'PCMU',
      'MULAW',
      'PCMA',
      'ALAW',
      'L16',
      'PCM_S16LE',
    }.contains(normalized)) {
      return SttAudioFormat(encoding: 'pcm_s16le', sampleRate: sampleRate);
    }
    throw UnsupportedError(
      'Telnyx codec $encoding is not decoded. Configure PCMU/PCMA/L16.',
    );
  }

  Uint8List decodeBase64(String payload, {required String encoding}) {
    late final Uint8List bytes;
    try {
      bytes = base64Decode(payload);
    } on FormatException catch (error) {
      throw FormatException('Invalid Telnyx base64 media payload.', error);
    }
    return decode(bytes, encoding: encoding);
  }

  Uint8List decode(List<int> bytes, {required String encoding}) {
    return switch (encoding.trim().toUpperCase()) {
      'PCMU' || 'MULAW' => _decodeCompanded(bytes, _decodeMuLaw),
      'PCMA' || 'ALAW' => _decodeCompanded(bytes, _decodeALaw),
      'L16' => _swapBigEndian16(bytes),
      'PCM_S16LE' => Uint8List.fromList(bytes),
      _ => throw UnsupportedError('Unsupported Telnyx codec: $encoding'),
    };
  }

  Uint8List _decodeCompanded(
    List<int> input,
    int Function(int value) decodeSample,
  ) {
    final Uint8List output = Uint8List(input.length * 2);
    final ByteData view = ByteData.sublistView(output);
    for (int index = 0; index < input.length; index += 1) {
      view.setInt16(index * 2, decodeSample(input[index]), Endian.little);
    }
    return output;
  }

  Uint8List _swapBigEndian16(List<int> input) {
    if (input.length.isOdd) {
      throw const FormatException('L16 media must contain complete samples.');
    }
    final Uint8List output = Uint8List(input.length);
    for (int index = 0; index < input.length; index += 2) {
      output[index] = input[index + 1];
      output[index + 1] = input[index];
    }
    return output;
  }

  static int _decodeMuLaw(int value) {
    final int inverted = (~value) & 0xff;
    final int sign = inverted & 0x80;
    final int exponent = (inverted >> 4) & 0x07;
    final int mantissa = inverted & 0x0f;
    int sample = ((mantissa << 3) + 0x84) << exponent;
    sample -= 0x84;
    return sign == 0 ? sample : -sample;
  }

  static int _decodeALaw(int value) {
    final int toggled = value ^ 0x55;
    final int sign = toggled & 0x80;
    final int exponent = (toggled >> 4) & 0x07;
    final int mantissa = toggled & 0x0f;
    int sample = exponent == 0
        ? (mantissa << 4) + 8
        : ((mantissa << 4) + 0x108) << (exponent - 1);
    if (sign == 0) {
      sample = -sample;
    }
    return sample;
  }
}
