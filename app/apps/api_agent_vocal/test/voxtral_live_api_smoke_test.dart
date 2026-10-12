import 'dart:io';

import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/voxtral_stt_provider.dart';
import 'package:test/test.dart';

void main() {
  final String? apiKey = Platform.environment['MISTRAL_API_KEY'];

  test(
    'Mistral live API accepts the Pinkall batch WAV contract',
    () async {
      final VoxtralSttProvider provider = VoxtralSttProvider(
        apiKey: apiKey!,
        realtimeBaseUrl:
            Platform.environment['MISTRAL_REALTIME_BASE_URL'] ??
            'wss://api.mistral.ai',
        realtimeModel:
            Platform.environment['MISTRAL_REALTIME_MODEL'] ??
            'voxtral-mini-transcribe-realtime-2602',
        batchBaseUrl:
            Platform.environment['MISTRAL_BATCH_BASE_URL'] ??
            'https://api.mistral.ai',
        batchModel:
            Platform.environment['MISTRAL_BATCH_MODEL'] ?? 'voxtral-mini-2602',
        targetDelayMs: 480,
      );
      const SttAudioFormat format = SttAudioFormat(
        encoding: 'pcm_s16le',
        sampleRate: 8000,
      );

      final BatchTranscript transcript = await provider.transcribeFinal(
        pcmBytes: List<int>.filled(16000, 0, growable: false),
        audioFormat: format,
        fileName: 'pinkall_external_contract_smoke.wav',
      );

      expect(transcript.provider, contains('voxtral-mini-2602'));
    },
    skip: apiKey == null || apiKey.isEmpty
        ? 'Set MISTRAL_API_KEY to run the external contract smoke.'
        : false,
    timeout: const Timeout(Duration(seconds: 45)),
  );
}
