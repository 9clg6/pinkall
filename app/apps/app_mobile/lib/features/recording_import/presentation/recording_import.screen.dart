import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.state.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/voice_briefing_dictation.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';

/// Imports an existing call recording and safely assigns diarized voices.
@RoutePage()
final class RecordingImportScreen extends ConsumerStatefulWidget {
  /// Creates an import workspace from an optional native open-in action.
  const RecordingImportScreen({
    this.initialImport,
    this.openPicker = false,
    super.key,
  });

  /// App-owned file prepared by iOS or Android, if any.
  final RecordingAudioImport? initialImport;

  /// Whether a launcher shortcut requested the document picker.
  final bool openPicker;

  @override
  ConsumerState<RecordingImportScreen> createState() =>
      _RecordingImportScreenState();
}

final class _RecordingImportScreenState
    extends ConsumerState<RecordingImportScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();
  bool _noticeConfirmed = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _briefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RecordingImportState state = ref.watch(
      recordingImportViewModelProvider,
    );
    return PopScope(
      canPop: !state.isBusy,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          unawaited(
            ref
                .read(recordingImportViewModelProvider.notifier)
                .discardSelection(),
          );
        }
      },
      child: Scaffold(
        body: PinkallPageFrame(
          accessory: TextButton.icon(
            onPressed: state.isBusy ? null : _close,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Téléphone'),
          ),
          child: AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 240),
            child: switch (state.stage) {
              RecordingImportStage.selecting => _SelectionWorkspace(
                state: state,
                titleController: _titleController,
                briefController: _briefController,
                noticeConfirmed: _noticeConfirmed,
                onNoticeChanged: (bool value) =>
                    setState(() => _noticeConfirmed = value),
                onPick: _pickFile,
                onStart: _start,
              ),
              RecordingImportStage.uploading ||
              RecordingImportStage.processing ||
              RecordingImportStage.finalizing => _ProcessingWorkspace(
                state: state,
              ),
              RecordingImportStage.assigningVoice => _VoiceAssignmentWorkspace(
                state: state,
                onSelect: (String voice) => ref
                    .read(recordingImportViewModelProvider.notifier)
                    .selectVoice(voice),
                onConfirm: _confirmVoice,
              ),
              RecordingImportStage.failed => _ImportFailureWorkspace(
                state: state,
                onRetry:
                    !state.hasFile ||
                        state.remoteImport?.failureRetryable == false
                    ? null
                    : state.remoteImport == null
                    ? _start
                    : _retry,
                onChooseAnother: _pickFile,
              ),
            },
          ),
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    if (_initialized || !mounted) return;
    _initialized = true;
    final RecordingAudioImport? initial = widget.initialImport;
    if (initial != null) {
      ref
          .read(recordingImportViewModelProvider.notifier)
          .selectNativeImport(initial);
    }
    if (widget.openPicker) await _pickFile();
  }

  Future<void> _pickFile() async {
    await ref.read(recordingImportViewModelProvider.notifier).pickRecording();
  }

  Future<void> _start() => ref
      .read(recordingImportViewModelProvider.notifier)
      .start(
        title: _titleController.text,
        preparationMarkdown: _briefController.text,
      );

  Future<void> _retry() =>
      ref.read(recordingImportViewModelProvider.notifier).retryUpload();

  Future<void> _confirmVoice() async {
    final ConversationSessionEntity? session = await ref
        .read(recordingImportViewModelProvider.notifier)
        .confirmUserVoice();
    if (session == null || !mounted) return;
    await context.router.replace(
      ActiveCallRoute(
        callId: session.callId,
        sessionId: session.id,
        remoteNumber: _titleController.text.trim().isEmpty
            ? 'Enregistrement importé'
            : _titleController.text.trim(),
        companion: true,
      ),
    );
  }

  Future<void> _close() async {
    await ref
        .read(recordingImportViewModelProvider.notifier)
        .discardSelection();
    if (mounted) await context.router.maybePop();
  }
}

final class _SelectionWorkspace extends StatelessWidget {
  const _SelectionWorkspace({
    required this.state,
    required this.titleController,
    required this.briefController,
    required this.noticeConfirmed,
    required this.onNoticeChanged,
    required this.onPick,
    required this.onStart,
  });

  final RecordingImportState state;
  final TextEditingController titleController;
  final TextEditingController briefController;
  final bool noticeConfirmed;
  final ValueChanged<bool> onNoticeChanged;
  final Future<void> Function() onPick;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey<String>('recording_import_selection'),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Eyebrow(icon: Icons.graphic_eq_rounded, label: 'APRÈS L’APPEL'),
              const Gap(18),
              Text(
                'Transforme un enregistrement en coaching.',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.25,
                  height: 1.05,
                ),
              ),
              const Gap(12),
              Text(
                'Pinkall retranscrit, sépare les voix, puis te demande laquelle '
                'est la tienne avant de construire le débrief.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
              const Gap(30),
              _ImportPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _AudioFileCard(state: state, onPick: onPick),
                    const Gap(22),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du call',
                        hintText: 'Discovery Acme, entretien Paul…',
                      ),
                    ),
                    const Gap(14),
                    TextField(
                      controller: briefController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Contexte pour le débrief',
                        hintText:
                            'Objectif, offre, prospect, points à analyser…',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const Gap(12),
                    VoiceBriefingDictation(
                      controller: briefController,
                      idleTitle: 'Dicter le contexte',
                      idleDescription:
                          'Parle librement, Pinkall l’ajoute au brief.',
                      maxTextBytes: 32 * 1024,
                    ),
                  ],
                ),
              ),
              const Gap(16),
              _RecordingConsentCard(
                confirmed: noticeConfirmed,
                onChanged: onNoticeChanged,
              ),
              const Gap(18),
              FilledButton.icon(
                key: const Key('start_recording_import_button'),
                onPressed: state.hasFile && noticeConfirmed ? onStart : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: PinkallColors.carbon,
                  foregroundColor: PinkallColors.onStrong,
                ),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Analyser cet appel'),
              ),
              const Gap(14),
              Text(
                'Pinkall ne peut pas enregistrer en secret un appel cellulaire '
                'sur ce téléphone. Importe uniquement un fichier obtenu avec '
                'l’accord des participants.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProcessingWorkspace extends StatelessWidget {
  const _ProcessingWorkspace({required this.state});

  final RecordingImportState state;

  @override
  Widget build(BuildContext context) {
    final bool uploading = state.stage == RecordingImportStage.uploading;
    final bool finalizing = state.stage == RecordingImportStage.finalizing;
    return Center(
      key: ValueKey<RecordingImportStage>(state.stage),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _ImportPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox.square(
                  dimension: 38,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: PinkallColors.pink,
                  ),
                ),
                const Gap(24),
                Text(
                  uploading
                      ? 'Envoi sécurisé de l’enregistrement…'
                      : finalizing
                      ? 'Construction de ton débrief…'
                      : 'Pinkall distingue les voix…',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(10),
                Text(
                  uploading
                      ? 'Le fichier est streamé et n’est jamais conservé dans la base.'
                      : finalizing
                      ? 'Tes phrases, le fond commercial et les axes de progression sont analysés.'
                      : 'Aucune voix n’est encore appelée « vous » ou « prospect ».',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                if (state.errorMessage != null) ...<Widget>[
                  const Gap(18),
                  Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: PinkallColors.warning,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _VoiceAssignmentWorkspace extends StatelessWidget {
  const _VoiceAssignmentWorkspace({
    required this.state,
    required this.onSelect,
    required this.onConfirm,
  });

  final RecordingImportState state;
  final ValueChanged<String> onSelect;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    final RecordingImportEntity remote = state.remoteImport!;
    return SingleChildScrollView(
      key: const ValueKey<String>('recording_voice_assignment'),
      padding: const EdgeInsets.fromLTRB(24, 46, 24, 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Eyebrow(
                icon: Icons.people_alt_outlined,
                label: 'VOIX DÉTECTÉES',
              ),
              const Gap(18),
              Text(
                'Laquelle est ta voix ?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.15,
                ),
              ),
              const Gap(10),
              Text(
                'Lis quelques extraits. Pinkall n’attribue les rôles qu’après '
                'ta confirmation.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(28),
              for (final String voice in remote.voices) ...<Widget>[
                _VoiceChoiceCard(
                  voice: voice,
                  selected: state.selectedVoice == voice,
                  samples: remote.provisionalSegments
                      .where(
                        (ProvisionalTranscriptSegmentEntity segment) =>
                            segment.voice == voice,
                      )
                      .take(3)
                      .map(
                        (ProvisionalTranscriptSegmentEntity segment) =>
                            segment.text,
                      )
                      .toList(growable: false),
                  onTap: () => onSelect(voice),
                ),
                const Gap(12),
              ],
              if (state.errorMessage != null) ...<Widget>[
                const Gap(8),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const Gap(18),
              FilledButton.icon(
                key: const Key('confirm_recording_voice_button'),
                onPressed: state.selectedVoice == null ? null : onConfirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: PinkallColors.carbon,
                  foregroundColor: PinkallColors.onStrong,
                ),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Oui, c’est ma voix'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ImportFailureWorkspace extends StatelessWidget {
  const _ImportFailureWorkspace({
    required this.state,
    required this.onRetry,
    required this.onChooseAnother,
  });

  final RecordingImportState state;
  final Future<void> Function()? onRetry;
  final Future<void> Function() onChooseAnother;

  @override
  Widget build(BuildContext context) => Center(
    key: const ValueKey<String>('recording_import_failed'),
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: _ImportPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.error_outline_rounded,
                color: PinkallColors.error,
                size: 34,
              ),
              const Gap(18),
              Text(
                'L’analyse s’est interrompue',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(9),
              Text(
                state.errorMessage ?? 'Réessaie dans un instant.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(22),
              if (onRetry != null) ...<Widget>[
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Réessayer'),
                ),
                const Gap(6),
              ],
              TextButton(
                onPressed: onChooseAnother,
                child: const Text('Choisir un autre fichier'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

final class _AudioFileCard extends StatelessWidget {
  const _AudioFileCard({required this.state, required this.onPick});

  final RecordingImportState state;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) => Material(
    color: state.hasFile ? PinkallColors.pinkWash : PinkallColors.surfaceLow,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPick,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: state.hasFile
                    ? PinkallColors.pinkContainer
                    : PinkallColors.surfaceHigh,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                state.hasFile
                    ? Icons.graphic_eq_rounded
                    : Icons.upload_file_rounded,
                color: state.hasFile
                    ? PinkallColors.pink
                    : PinkallColors.carbonSoft,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    state.fileName ?? 'Choisir un enregistrement',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    state.sizeBytes == null
                        ? 'M4A, MP3, WAV, AAC, FLAC, OGG ou WebM • 200 Mo max'
                        : _formatBytes(state.sizeBytes!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

final class _RecordingConsentCard extends StatelessWidget {
  const _RecordingConsentCard({
    required this.confirmed,
    required this.onChanged,
  });

  final bool confirmed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Material(
    color: confirmed ? PinkallColors.pinkWash : PinkallColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: confirmed
            ? PinkallColors.pink.withValues(alpha: 0.32)
            : PinkallColors.outline,
      ),
    ),
    child: CheckboxListTile(
      value: confirmed,
      onChanged: (bool? value) => onChanged(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Les participants ont été informés'),
      subtitle: const Text(
        'Ils savent que cet enregistrement sera transcrit et analysé.',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
  );
}

final class _VoiceChoiceCard extends StatelessWidget {
  const _VoiceChoiceCard({
    required this.voice,
    required this.selected,
    required this.samples,
    required this.onTap,
  });

  final String voice;
  final bool selected;
  final List<String> samples;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? PinkallColors.pinkWash : PinkallColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: selected
            ? PinkallColors.pink.withValues(alpha: 0.5)
            : PinkallColors.outline,
        width: selected ? 1.4 : 1,
      ),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? PinkallColors.pink
                    : PinkallColors.surfaceHigh,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  voice,
                  style: TextStyle(
                    color: selected
                        ? PinkallColors.onPink
                        : PinkallColors.carbon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Voix $voice',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  for (final String sample in samples)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        '« $sample »',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected
                  ? PinkallColors.pink
                  : Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    ),
  );
}

final class _ImportPanel extends StatelessWidget {
  const _ImportPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: PinkallColors.outline),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x10171519),
          blurRadius: 36,
          offset: Offset(0, 16),
        ),
      ],
    ),
    child: child,
  );
}

final class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(icon, size: 16, color: PinkallColors.pink),
      const Gap(7),
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: PinkallColors.pinkDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    ],
  );
}

String _formatBytes(int bytes) {
  final double megabytes = bytes / (1024 * 1024);
  return '${megabytes.toStringAsFixed(megabytes >= 10 ? 0 : 1)} Mo';
}
