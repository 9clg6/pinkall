import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.state.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';

/// Captures a macOS meeting and feeds Pinkall's existing live intelligence.
@RoutePage()
final class InstantHelpScreen extends ConsumerStatefulWidget {
  /// Creates the macOS Instant Help workspace.
  const InstantHelpScreen({super.key});

  @override
  ConsumerState<InstantHelpScreen> createState() => _InstantHelpScreenState();
}

final class _InstantHelpScreenState extends ConsumerState<InstantHelpScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _preparationController = TextEditingController();
  final ScrollController _transcriptController = ScrollController();
  bool _noticeConfirmed = false;
  String? _preparationFileName;

  @override
  void dispose() {
    _titleController.dispose();
    _preparationController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InstantHelpState state = ref.watch(instantHelpViewModelProvider);
    ref.listen<InstantHelpState>(instantHelpViewModelProvider, (
      InstantHelpState? previous,
      InstantHelpState next,
    ) {
      if ((previous?.transcript.length ?? 0) < next.transcript.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_transcriptController.hasClients) {
            unawaited(
              _transcriptController.animateTo(
                _transcriptController.position.maxScrollExtent,
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
              ),
            );
          }
        });
      }
    });
    final bool captureActive = <InstantHelpStage>{
      InstantHelpStage.starting,
      InstantHelpStage.live,
      InstantHelpStage.stopping,
    }.contains(state.stage);
    return PopScope(
      canPop: !captureActive,
      child: Scaffold(
        body: PinkallPageFrame(
          accessory: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (captureActive)
                _LiveToolbarStatus(state: state)
              else
                TextButton.icon(
                  onPressed: () => context.router.maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Téléphone'),
                ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 260),
            child: switch (state.stage) {
              InstantHelpStage.preparing ||
              InstantHelpStage.starting ||
              InstantHelpStage.failed when state.externalSession == null =>
                _buildPreparation(state),
              _ => _buildLiveWorkspace(state),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPreparation(InstantHelpState state) {
    final ThemeData theme = Theme.of(context);
    final PinkallThemeTokens tokens =
        theme.extension<PinkallThemeTokens>() ?? PinkallThemeTokens.light;
    final bool starting = state.stage == InstantHelpStage.starting;
    return SingleChildScrollView(
      key: const ValueKey<String>('instant_help_preparation'),
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PinkallColors.carbon,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: PinkallColors.shadowSoft,
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: PinkallColors.pinkHighlight,
                  size: 21,
                ),
              ),
              const Gap(22),
              Text(
                'Ton coach, dans n’importe quel call.',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.35,
                  height: 1.04,
                ),
              ),
              const Gap(14),
              Text(
                'Pinkall écoute le son de ton Mac et ton micro, distingue les '
                'intervenants, puis t’aide en direct — sur Meet, Zoom ou Teams.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
              Gap(tokens.spaceExtraLarge),
              _GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Préparer la conversation',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.35,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'Facultatif. Donne le contexte utile au coach sans '
                      'l’enfermer dans un script.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(20),
                    TextField(
                      controller: _titleController,
                      enabled: !starting,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nom du call',
                        hintText: 'Démo Acme, discovery Paul…',
                      ),
                    ),
                    const Gap(14),
                    TextField(
                      controller: _preparationController,
                      enabled: !starting,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Brief pour le coach',
                        hintText:
                            'Objectif, prospect, offre, points à valider…',
                        alignLabelWithHint: true,
                        suffixIcon: IconButton(
                          tooltip: 'Importer un fichier Markdown',
                          onPressed: starting ? null : _pickPreparation,
                          icon: const Icon(Icons.attach_file_rounded),
                        ),
                      ),
                    ),
                    if (_preparationFileName != null) ...<Widget>[
                      const Gap(10),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: PinkallColors.pink,
                          ),
                          const Gap(7),
                          Expanded(
                            child: Text(
                              _preparationFileName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(16),
              _ConsentPanel(
                confirmed: _noticeConfirmed,
                disabled: starting,
                onChanged: (bool value) =>
                    setState(() => _noticeConfirmed = value),
              ),
              const Gap(10),
              Text(
                'Utilise un casque pour éviter que la voix du prospect soit '
                'captée une seconde fois par ton micro.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              if (state.errorMessage != null) ...<Widget>[
                const Gap(14),
                _InlineError(message: state.errorMessage!),
              ],
              const Gap(20),
              FilledButton.icon(
                key: const Key('start_instant_help_button'),
                onPressed: !_noticeConfirmed || starting ? null : _start,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: PinkallColors.carbon,
                  foregroundColor: PinkallColors.onStrong,
                ),
                icon: starting
                    ? const SizedBox.square(
                        dimension: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: PinkallColors.onStrong,
                        ),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  starting
                      ? 'Connexion aux deux flux…'
                      : 'Démarrer Instant Help',
                ),
              ),
              const Gap(12),
              Center(
                child: Text(
                  'Audio traité en mémoire • aucun fichier brut conservé',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveWorkspace(InstantHelpState state) {
    return ColoredBox(
      key: const ValueKey<String>('instant_help_live'),
      color: PinkallColors.carbon,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 920;
          final Widget transcript = _TranscriptPane(
            state: state,
            scrollController: _transcriptController,
          );
          final Widget coach = _CoachPane(
            state: state,
            onCoachChanged: (bool enabled) => ref
                .read(instantHelpViewModelProvider.notifier)
                .setCoachEnabled(enabled: enabled),
            onStop: _stop,
          );
          return Padding(
            padding: EdgeInsets.all(compact ? 16 : 24),
            child: compact
                ? Column(
                    children: <Widget>[
                      Expanded(flex: 6, child: transcript),
                      const Gap(14),
                      Flexible(flex: 4, child: coach),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(flex: 7, child: transcript),
                      const Gap(18),
                      SizedBox(width: 360, child: coach),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<void> _pickPreparation() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: const <XTypeGroup>[
        XTypeGroup(label: 'Markdown', extensions: <String>['md', 'txt']),
      ],
    );
    if (file == null || !mounted) return;
    final String text = await file.readAsString();
    if (!mounted) return;
    setState(() {
      _preparationController.text = text;
      _preparationFileName = file.name;
    });
  }

  Future<void> _start() async {
    await ref
        .read(instantHelpViewModelProvider.notifier)
        .start(
          title: _titleController.text,
          preparationMarkdown: _preparationController.text,
        );
  }

  Future<void> _stop() async {
    final ConversationSessionEntity? session = await ref
        .read(instantHelpViewModelProvider.notifier)
        .stopAndFinalize();
    if (session == null || !mounted) return;
    await context.router.replace(
      ActiveCallRoute(
        callId: session.callId,
        sessionId: session.id,
        remoteNumber: _titleController.text.trim().isEmpty
            ? 'Instant Help'
            : _titleController.text.trim(),
        companion: true,
      ),
    );
  }
}

final class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(20),
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

final class _ConsentPanel extends StatelessWidget {
  const _ConsentPanel({
    required this.confirmed,
    required this.disabled,
    required this.onChanged,
  });

  final bool confirmed;
  final bool disabled;
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
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: disabled ? null : () => onChanged(!confirmed),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: confirmed,
              onChanged: disabled
                  ? null
                  : (bool? value) => onChanged(value ?? false),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Les participants sont informés',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    'Je les ai prévenus que Pinkall transcrit et analyse la '
                    'conversation, et ils ont accepté.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _LiveToolbarStatus extends StatelessWidget {
  const _LiveToolbarStatus({required this.state});

  final InstantHelpState state;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: 'Instant Help en direct',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _LiveDot(),
        const Gap(8),
        Text(
          state.stage == InstantHelpStage.stopping
              ? 'Finalisation…'
              : _formatDuration(state.elapsed),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    ),
  );
}

final class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: PinkallColors.callEnd,
      boxShadow: <BoxShadow>[
        BoxShadow(color: Color(0x66CF315C), blurRadius: 8),
      ],
    ),
  );
}

final class _TranscriptPane extends StatelessWidget {
  const _TranscriptPane({required this.state, required this.scrollController});

  final InstantHelpState state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => _DarkPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Conversation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: PinkallColors.onStrong,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _AudioSignal(label: 'Micro', detected: state.microphoneDetected),
            const Gap(8),
            _AudioSignal(label: 'Mac', detected: state.systemAudioDetected),
          ],
        ),
        const Gap(20),
        Expanded(
          child: state.transcript.isEmpty
              ? const _ListeningEmptyState()
              : ListView.separated(
                  controller: scrollController,
                  itemCount: state.transcript.length,
                  separatorBuilder: (_, _) => const Gap(14),
                  itemBuilder: (BuildContext context, int index) =>
                      _TranscriptTurn(segment: state.transcript[index]),
                ),
        ),
      ],
    ),
  );
}

final class _CoachPane extends StatelessWidget {
  const _CoachPane({
    required this.state,
    required this.onCoachChanged,
    required this.onStop,
  });

  final InstantHelpState state;
  final ValueChanged<bool> onCoachChanged;
  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    final bool stopping = state.stage == InstantHelpStage.stopping;
    final bool live = state.stage == InstantHelpStage.live;
    return _DarkPanel(
      emphasized: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: PinkallColors.pink.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: PinkallColors.pinkHighlight,
                  size: 18,
                ),
              ),
              const Gap(11),
              Text(
                'Coach IA',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PinkallColors.onStrong,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(22),
          Expanded(
            child: AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              child: !state.isCoachEnabled
                  ? _CoachOff(
                      onEnable: live ? () => onCoachChanged(true) : null,
                    )
                  : _CoachLive(state: state),
            ),
          ),
          if (state.errorMessage != null) ...<Widget>[
            const Gap(12),
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: PinkallColors.pinkHighlight,
              ),
            ),
          ],
          const Gap(16),
          if (state.isCoachEnabled)
            TextButton.icon(
              onPressed: live && !stopping ? () => onCoachChanged(false) : null,
              style: TextButton.styleFrom(
                foregroundColor: PinkallColors.onStrong.withValues(alpha: 0.72),
              ),
              icon: const Icon(Icons.pause_rounded, size: 17),
              label: const Text('Mettre le coach en pause'),
            ),
          const Gap(6),
          FilledButton.icon(
            key: const Key('stop_instant_help_button'),
            onPressed: live && !stopping ? onStop : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: PinkallColors.onStrong,
              foregroundColor: PinkallColors.carbon,
            ),
            icon: stopping
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: PinkallColors.carbon,
                    ),
                  )
                : const Icon(Icons.stop_rounded),
            label: Text(stopping ? 'Préparation du débrief…' : 'Terminer'),
          ),
        ],
      ),
    );
  }
}

final class _CoachOff extends StatelessWidget {
  const _CoachOff({required this.onEnable});

  final VoidCallback? onEnable;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('coach_off'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Tu gardes la main.',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: PinkallColors.onStrong,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.45,
        ),
      ),
      const Gap(9),
      Text(
        'Active le coach quand tu veux une suggestion. La transcription '
        'continue, mais rien n’est envoyé au moteur de conseil avant ça.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: PinkallColors.onStrong.withValues(alpha: 0.58),
          height: 1.45,
        ),
      ),
      const Gap(22),
      OutlinedButton.icon(
        onPressed: onEnable,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: PinkallColors.onStrong,
          side: BorderSide(
            color: PinkallColors.pinkHighlight.withValues(alpha: 0.48),
          ),
        ),
        icon: const Icon(Icons.auto_awesome_rounded, size: 18),
        label: const Text('Activer le coach'),
      ),
    ],
  );
}

final class _CoachLive extends StatelessWidget {
  const _CoachLive({required this.state});

  final InstantHelpState state;

  @override
  Widget build(BuildContext context) {
    final CoachingSuggestionEntity? suggestion = state.suggestion;
    if (suggestion == null) {
      return Column(
        key: const ValueKey<String>('coach_listening'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.coachAnalysisStatus == CoachAnalysisStatus.analyzing
                ? 'J’analyse ce moment…'
                : 'Je t’écoute.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: PinkallColors.onStrong,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
          ),
          const Gap(9),
          Text(
            'Une suggestion apparaît seulement lorsqu’elle peut vraiment '
            'changer la suite du call.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.58),
              height: 1.45,
            ),
          ),
        ],
      );
    }
    return SingleChildScrollView(
      key: ValueKey<String>(suggestion.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            suggestion.text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: PinkallColors.onStrong,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.35,
            ),
          ),
          const Gap(14),
          Text(
            suggestion.rationale,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.62),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

final class _DarkPanel extends StatelessWidget {
  const _DarkPanel({required this.child, this.emphasized = false});

  final Widget child;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: emphasized
          ? PinkallColors.carbonElevated.withValues(alpha: 0.74)
          : PinkallColors.carbonRaised,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: emphasized
            ? PinkallColors.pinkHighlight.withValues(alpha: 0.18)
            : PinkallColors.onStrong.withValues(alpha: 0.07),
      ),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x59000000),
          blurRadius: 34,
          offset: Offset(0, 18),
        ),
      ],
    ),
    child: child,
  );
}

final class _AudioSignal extends StatelessWidget {
  const _AudioSignal({required this.label, required this.detected});

  final String label;
  final bool detected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: PinkallColors.onStrong.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: detected ? PinkallColors.success : PinkallColors.muted,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.68),
          ),
        ),
      ],
    ),
  );
}

final class _ListeningEmptyState extends StatelessWidget {
  const _ListeningEmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.graphic_eq_rounded,
          color: PinkallColors.pinkHighlight,
          size: 28,
        ),
        const Gap(12),
        Text(
          'En écoute…',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: PinkallColors.onStrong),
        ),
        const Gap(6),
        Text(
          'La transcription apparaît après une prise de parole complète.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.48),
          ),
        ),
      ],
    ),
  );
}

final class _TranscriptTurn extends StatelessWidget {
  const _TranscriptTurn({required this.segment});

  final TranscriptSegmentEntity segment;

  @override
  Widget build(BuildContext context) {
    final bool seller = segment.speaker == TranscriptSpeaker.seller;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 76,
          child: Text(
            seller ? 'Vous' : 'Prospect',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: seller
                  ? PinkallColors.pinkHighlight
                  : PinkallColors.onStrong.withValues(alpha: 0.52),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            segment.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: PinkallColors.onStrong.withValues(
                alpha: segment.isFinal ? 0.92 : 0.56,
              ),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

final class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: PinkallColors.errorContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Icon(Icons.error_outline_rounded, size: 19),
        const Gap(10),
        Expanded(child: Text(message)),
      ],
    ),
  );
}

String _formatDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);
  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}
