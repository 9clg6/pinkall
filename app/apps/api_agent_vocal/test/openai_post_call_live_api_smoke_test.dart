import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_post_call_gateway.dart';
import 'package:test/test.dart';

void main() {
  final String? apiKey = Platform.environment['OPENAI_API_KEY'];

  test(
    'OpenAI live API accepts the grounded Pinkall post-call contract',
    () async {
      final OpenAiPostCallGateway gateway = OpenAiPostCallGateway(
        apiKey: apiKey!,
        baseUrl:
            Platform.environment['OPENAI_BASE_URL'] ??
            'https://api.openai.com/v1',
        model: Platform.environment['OPENAI_POST_CALL_MODEL'] ?? 'gpt-5.4-mini',
        reasoningEffort:
            Platform.environment['OPENAI_POST_CALL_REASONING_EFFORT'] ?? 'low',
      );
      final PostCallDebrief debrief = await gateway.generate(
        sessionId: 'external-post-call-contract-smoke',
        transcript: <TranscriptSegment>[
          TranscriptSegment(
            id: 'segment-seller-1',
            track: MediaTrack.outbound,
            speaker: SpeakerRole.seller,
            text: 'Je vous envoie une synthèse et je vous rappelle mardi.',
            startSeconds: 0,
            endSeconds: 3,
            isFinal: true,
            provider: 'contract-smoke',
            createdAt: DateTime.utc(2026, 7, 13),
          ),
          TranscriptSegment(
            id: 'segment-prospect-1',
            track: MediaTrack.inbound,
            speaker: SpeakerRole.prospect,
            text: 'D’accord, mardi après-midi me convient.',
            startSeconds: 3,
            endSeconds: 6,
            isFinal: true,
            provider: 'contract-smoke',
            createdAt: DateTime.utc(2026, 7, 13),
          ),
        ],
        improvementCandidates: const <CoachRecommendation>[],
      );

      expect(debrief.summary.evidenceSegmentIds, isNotEmpty);
      expect(debrief.followUp.evidenceSegmentIds, isNotEmpty);
      expect(debrief.model, isNotEmpty);
    },
    skip: apiKey == null || apiKey.isEmpty
        ? 'Set OPENAI_API_KEY to run the external post-call smoke.'
        : false,
    timeout: const Timeout(Duration(seconds: 55)),
  );
}
