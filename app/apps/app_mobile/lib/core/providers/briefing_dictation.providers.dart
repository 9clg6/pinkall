import 'dart:async';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';

/// Native microphone recorder used only while a briefing control is active.
final Provider<VoiceDictationRecorderClient>
voiceDictationRecorderClientProvider = Provider<VoiceDictationRecorderClient>((
  Ref ref,
) {
  final RecordVoiceDictationRecorderClientImpl client =
      RecordVoiceDictationRecorderClientImpl();
  ref.onDispose(() => unawaited(client.dispose()));
  return client;
});

/// Authenticated provider-neutral briefing transcription repository.
final Provider<BriefingTranscriptionRepository>
briefingTranscriptionRepositoryProvider =
    Provider<BriefingTranscriptionRepository>((Ref ref) {
      final PinkallHttpClient httpClient = ref.watch(pinkallHttpClientProvider);
      if (httpClient is! PinkallBinaryHttpClient) {
        throw StateError(
          'The configured Pinkall HTTP client cannot upload briefing audio.',
        );
      }
      return BriefingTranscriptionRepositoryImpl(
        remoteDataSource: BriefingTranscriptionRemoteDataSourceImpl(
          httpClient: httpClient as PinkallBinaryHttpClient,
        ),
      );
    });

/// One-shot use case consumed by both project and pre-call briefing fields.
final Provider<TranscribeBriefingAudioUseCase>
transcribeBriefingAudioUseCaseProvider =
    Provider<TranscribeBriefingAudioUseCase>(
      (Ref ref) => TranscribeBriefingAudioUseCase(
        repository: ref.watch(briefingTranscriptionRepositoryProvider),
      ),
    );
