import 'package:api_agent_vocal/src/application/backend.dart';
import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_coach_gateway.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_post_call_gateway.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/deepgram_flux_stt_provider.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/voxtral_stt_provider.dart';
import 'package:test/test.dart';

void main() {
  test('Mistral configures Voxtral STT but never coach or debrief', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'mistral-key',
      }),
    );
    addTearDown(backend.dispose);

    expect(backend.sttProvider, isA<VoxtralSttProvider>());
    expect(backend.sttProvider.providesSemanticTurnBoundaries, isFalse);
    expect(backend.coachGateway, isA<UnavailableCoachGateway>());
    expect(backend.postCallGateway, isA<UnavailablePostCallGateway>());
  });

  test('backend uses OpenAI exclusively for coach and debrief', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'mistral-key',
        'OPENAI_API_KEY': 'openai-key',
        'OPENAI_COACH_MODEL': 'gpt-test',
      }),
    );
    addTearDown(backend.dispose);

    expect(backend.coachGateway, isA<OpenAiCoachGateway>());
    expect(backend.postCallGateway, isA<OpenAiPostCallGateway>());
  });

  test('Deepgram Flux handles live STT while Voxtral remains batch', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'STT_PROVIDER': 'deepgram_flux',
        'DEEPGRAM_API_KEY': 'deepgram-key',
        'MISTRAL_API_KEY': 'mistral-key',
      }),
    );
    addTearDown(backend.dispose);

    expect(backend.sttProvider, isA<DeepgramFluxSttProvider>());
    final DeepgramFluxSttProvider provider =
        backend.sttProvider as DeepgramFluxSttProvider;
    expect(provider.batchProvider, isA<VoxtralSttProvider>());
    expect(provider.providesSemanticTurnBoundaries, isTrue);
    expect(provider.realtimeBaseUrl, 'wss://api.eu.deepgram.com');
    expect(provider.model, 'flux-general-multi');
    expect(provider.languageHint, 'fr');
  });
}
