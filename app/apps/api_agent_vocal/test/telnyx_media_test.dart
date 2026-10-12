import 'dart:convert';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/telnyx_media.dart';
import 'package:test/test.dart';

void main() {
  const TelnyxMediaFrameParser parser = TelnyxMediaFrameParser();

  test('parses official connected, start, media, and stop sequence', () {
    final TelnyxMediaFrame connected = parser.parse(
      jsonEncode(<String, Object?>{'event': 'connected', 'version': '1.0.0'}),
    );
    expect(connected, isA<TelnyxConnectedFrame>());
    expect((connected as TelnyxConnectedFrame).version, '1.0.0');

    final TelnyxMediaFrame start = parser.parse(
      jsonEncode(<String, Object?>{
        'event': 'start',
        'sequence_number': '1',
        'stream_id': 'stream-1',
        'start': <String, Object?>{
          'call_control_id': 'control-1',
          'call_session_id': 'call-session-1',
          'media_format': <String, Object?>{
            'encoding': 'PCMU',
            'sample_rate': 8000,
            'channels': 1,
          },
        },
      }),
    );
    expect(start, isA<TelnyxStartFrame>());
    expect((start as TelnyxStartFrame).sampleRate, 8000);

    final TelnyxMediaFrame media = parser.parse(
      jsonEncode(<String, Object?>{
        'event': 'media',
        'sequence_number': '2',
        'stream_id': 'stream-1',
        'media': <String, Object?>{
          'track': 'inbound',
          'chunk': '1',
          'timestamp': '20',
          'payload': base64Encode(<int>[0xff, 0x7f]),
        },
      }),
    );
    expect(media, isA<TelnyxAudioFrame>());
    expect((media as TelnyxAudioFrame).track, MediaTrack.inbound);

    final TelnyxMediaFrame stop = parser.parse(
      jsonEncode(<String, Object?>{
        'event': 'stop',
        'sequence_number': '3',
        'stream_id': 'stream-1',
        'stop': <String, Object?>{},
      }),
    );
    expect(stop, isA<TelnyxStopFrame>());
  });

  test('decodes PCMU to little-endian 16-bit PCM', () {
    const TelnyxPcmDecoder decoder = TelnyxPcmDecoder();
    final List<int> pcm = decoder.decode(<int>[0xff, 0x7f], encoding: 'PCMU');

    expect(pcm, hasLength(4));
    expect(pcm.take(2), <int>[0, 0]);
  });

  test('rejects an unsupported compressed codec', () {
    const TelnyxPcmDecoder decoder = TelnyxPcmDecoder();
    expect(
      () => decoder.outputFormat(
        encoding: 'OPUS',
        sampleRate: 16000,
        channels: 1,
      ),
      throwsUnsupportedError,
    );
  });
}
