import 'dart:typed_data';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/briefing_dictation.providers.dart';
import 'package:pinkall/features/shared/presentation/widgets/voice_briefing_dictation.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets(
    'appends an editable transcript without replacing existing text',
    (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController(
        text: '# Contexte existant',
      );
      addTearDown(controller.dispose);
      final _Recorder recorder = _Recorder();

      await _pumpControl(
        tester,
        controller: controller,
        recorder: recorder,
        repository: const _TranscriptionRepository(),
      );

      await tester.tap(find.byKey(const Key('voice_dictation_control')));
      for (int frame = 0; frame < 6; frame += 1) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(recorder.started, isTrue);
      expect(find.byKey(const Key('voice_dictation_elapsed')), findsOneWidget);

      await tester.tap(find.byKey(const Key('voice_dictation_control')));
      await tester.pumpAndSettle();

      expect(recorder.stopped, isTrue);
      expect(
        controller.text,
        '# Contexte existant\n\nNotre objectif est de qualifier le besoin.',
      );
      expect(find.byKey(const Key('voice_dictation_success')), findsOneWidget);
      expect(tester.takeException(), isNull);

      controller.text = 'Texte conservé';
      recorder.permissionDenied = true;
      await tester.tap(find.byKey(const Key('voice_dictation_control')));
      for (int frame = 0; frame < 4; frame += 1) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(controller.text, 'Texte conservé');
      expect(find.byKey(const Key('voice_dictation_error')), findsOneWidget);
      expect(find.textContaining('Autorise le microphone'), findsOneWidget);
    },
  );
}

Future<void> _pumpControl(
  WidgetTester tester, {
  required TextEditingController controller,
  required VoiceDictationRecorderClient recorder,
  required BriefingTranscriptionRepository repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        voiceDictationRecorderClientProvider.overrideWithValue(recorder),
        briefingTranscriptionRepositoryProvider.overrideWithValue(repository),
      ],
      child: EasyLocalization(
        supportedLocales: const <Locale>[Locale('fr'), Locale('en')],
        fallbackLocale: const Locale('fr'),
        startLocale: const Locale('fr'),
        saveLocale: false,
        path: 'assets/translations',
        child: Builder(
          builder: (BuildContext context) => MaterialApp(
            theme: PinkallTheme.light,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 520,
                  child: VoiceBriefingDictation(
                    controller: controller,
                    idleTitle: 'Présente ton projet à Pinkall',
                    idleDescription: 'Parle naturellement de ton produit.',
                    maxTextBytes: 16 * 1024,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  for (
    int attempt = 0;
    attempt < 20 &&
        find.byKey(const Key('voice_dictation_control')).evaluate().isEmpty;
    attempt += 1
  ) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

final class _Recorder implements VoiceDictationRecorderClient {
  bool permissionDenied = false;
  bool started = false;
  bool stopped = false;

  @override
  Future<void> start() async {
    if (permissionDenied) {
      throw const VoiceDictationRecordingException(
        VoiceDictationRecordingFailure.permissionDenied,
        'Denied in test.',
      );
    }
    started = true;
  }

  @override
  Future<VoiceDictationRecording> stop() async {
    stopped = true;
    return VoiceDictationRecording(
      pcmBytes: Uint8List.fromList(List<int>.filled(3200, 1)),
      sampleRate: 16000,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Future<void> cancel() async {}

  @override
  Future<void> dispose() async {}
}

final class _TranscriptionRepository
    implements BriefingTranscriptionRepository {
  const _TranscriptionRepository();

  @override
  Future<BriefingTranscriptionEntity> transcribe(
    TranscribeBriefingAudioParam params,
  ) async => const BriefingTranscriptionEntity(
    text: 'Notre objectif est de qualifier le besoin.',
    provider: 'test',
    languageCode: 'fr',
  );
}
