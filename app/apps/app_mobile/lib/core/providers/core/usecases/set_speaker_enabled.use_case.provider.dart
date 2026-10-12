import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_speaker_enabled.use_case.provider.g.dart';

/// Provides the Telnyx speaker-routing use case.
@riverpod
Future<SetSpeakerEnabledUseCase> setSpeakerEnabledUseCase(Ref ref) async {
  final CallRepository repository = await ref.watch(
    callRepositoryProvider.future,
  );
  return SetSpeakerEnabledUseCase(callRepository: repository);
}
