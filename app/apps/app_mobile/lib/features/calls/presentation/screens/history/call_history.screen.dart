import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';

/// Durable call history backed by the Pinkall workspace API.
@RoutePage()
final class CallHistoryScreen extends ConsumerStatefulWidget {
  /// Creates the call-history screen.
  const CallHistoryScreen({super.key});

  @override
  ConsumerState<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

final class _CallHistoryScreenState extends ConsumerState<CallHistoryScreen> {
  late Future<List<ConversationSessionEntity>> _sessions;

  @override
  void initState() {
    super.initState();
    _sessions = _loadSessions();
  }

  Future<List<ConversationSessionEntity>> _loadSessions() async {
    final List<ConversationSessionEntity> sessions = await ref
        .read(conversationSessionRepositoryProvider)
        .listSessions();
    return sessions.toList(growable: false)..sort(
      (ConversationSessionEntity left, ConversationSessionEntity right) =>
          right.createdAt.compareTo(left.createdAt),
    );
  }

  Future<void> _refresh() async {
    final Future<List<ConversationSessionEntity>> next = _loadSessions();
    setState(() => _sessions = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PinkallPageFrame(
        accessory: IconButton(
          key: const Key('history_back_button'),
          tooltip: 'Retour au téléphone',
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.close_rounded, size: 20),
        ),
        child: FutureBuilder<List<ConversationSessionEntity>>(
          future: _sessions,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<ConversationSessionEntity>> snapshot,
              ) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _HistoryLoading();
                }
                if (snapshot.hasError) {
                  return _HistoryFailure(onRetry: _refresh);
                }
                final List<ConversationSessionEntity> sessions =
                    snapshot.data ?? const <ConversationSessionEntity>[];
                return _HistoryWorkspace(
                  sessions: sessions,
                  onRefresh: _refresh,
                  onOpen: _openSession,
                );
              },
        ),
      ),
    );
  }

  Future<void> _openSession(ConversationSessionEntity session) async {
    await context.router.push(
      ActiveCallRoute(
        callId: session.callId,
        sessionId: session.id,
        remoteNumber: session.destinationNumber,
        companion: true,
      ),
    );
    if (mounted) {
      await _refresh();
    }
  }
}

final class _HistoryWorkspace extends StatelessWidget {
  const _HistoryWorkspace({
    required this.sessions,
    required this.onRefresh,
    required this.onOpen,
  });

  final List<ConversationSessionEntity> sessions;
  final Future<void> Function() onRefresh;
  final ValueChanged<ConversationSessionEntity> onOpen;

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          color: PinkallColors.pink,
          child: CustomScrollView(
            key: const Key('call_history_list'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  tokens.spaceLarge,
                  tokens.space2ExtraLarge,
                  tokens.spaceLarge,
                  tokens.spaceLarge,
                ),
                sliver: SliverToBoxAdapter(
                  child: _HistoryHeader(sessionCount: sessions.length),
                ),
              ),
              if (sessions.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyHistory(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    tokens.spaceLarge,
                    0,
                    tokens.spaceLarge,
                    tokens.space3ExtraLarge,
                  ),
                  sliver: SliverList.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: tokens.spaceSmall),
                    itemBuilder: (BuildContext context, int index) {
                      final ConversationSessionEntity session = sessions[index];
                      final bool showDay =
                          index == 0 ||
                          !_sameLocalDay(
                            sessions[index - 1].createdAt,
                            session.createdAt,
                          );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (showDay) ...<Widget>[
                            if (index > 0) SizedBox(height: tokens.spaceMedium),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                              child: Text(
                                _dayLabel(session.createdAt),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: PinkallColors.carbonSoft,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                          _HistoryRow(
                            session: session,
                            onPressed: () => onOpen(session),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.sessionCount});

  final int sessionCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Historique',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: PinkallColors.carbon,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sessionCount == 0
              ? 'Tes appels, transcriptions et résumés apparaîtront ici.'
              : '$sessionCount ${sessionCount > 1 ? 'appels conservés' : 'appel conservé'} · ouvre un appel pour retrouver sa transcription et son résumé.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: PinkallColors.carbonSoft,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

final class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.session, required this.onPressed});

  final ConversationSessionEntity session;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool failed = session.status == ConversationSessionStatus.failed;
    final String destination =
        session.destinationNumber?.trim().isNotEmpty == true
        ? session.destinationNumber!.trim()
        : 'Numéro masqué';
    return Semantics(
      button: true,
      label: 'Ouvrir l’appel avec $destination',
      child: Material(
        color: colors.surface.withValues(alpha: 0.78),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('history_session_${session.id}'),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: failed
                        ? colors.errorContainer.withValues(alpha: 0.72)
                        : PinkallColors.pinkWash,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    failed ? Icons.call_missed_rounded : Icons.call_rounded,
                    size: 19,
                    color: failed ? colors.error : PinkallColors.pinkDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: PinkallColors.carbon,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_timeLabel(session.createdAt)} · ${_durationLabel(session)} · ${_statusLabel(session.status)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: failed
                              ? colors.error
                              : PinkallColors.carbonSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 19,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.62),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();

  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      liveRegion: true,
      label: 'Chargement de l’historique',
      child: const SizedBox.square(
        dimension: 22,
        child: CircularProgressIndicator(strokeWidth: 1.8),
      ),
    ),
  );
}

final class _HistoryFailure extends StatelessWidget {
  const _HistoryFailure({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.history_toggle_off_rounded, size: 30),
          const SizedBox(height: 14),
          const Text('L’historique est indisponible pour le moment.'),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    ),
  );
}

final class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.history_rounded,
            size: 36,
            color: PinkallColors.pink,
          ),
          const SizedBox(height: 14),
          Text(
            'Aucun appel pour l’instant',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Après ton premier appel, tu retrouveras ici la transcription complète et le résumé.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: PinkallColors.carbonSoft),
          ),
        ],
      ),
    ),
  );
}

bool _sameLocalDay(DateTime left, DateTime right) {
  final DateTime a = left.toLocal();
  final DateTime b = right.toLocal();
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _dayLabel(DateTime value) {
  final DateTime local = value.toLocal();
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime day = DateTime(local.year, local.month, local.day);
  final int delta = today.difference(day).inDays;
  if (delta == 0) return 'Aujourd’hui';
  if (delta == 1) return 'Hier';
  const List<String> months = <String>[
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];
  return '${local.day} ${months[local.month - 1]} ${local.year}';
}

String _timeLabel(DateTime value) {
  final DateTime local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String _durationLabel(ConversationSessionEntity session) {
  final DateTime? start = session.startedAt;
  final DateTime? end = session.endedAt;
  if (start == null || end == null || end.isBefore(start)) return '—';
  final Duration duration = end.difference(start);
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);
  return minutes > 0 ? '${minutes} min ${seconds}s' : '${seconds}s';
}

String _statusLabel(ConversationSessionStatus status) => switch (status) {
  ConversationSessionStatus.created => 'À démarrer',
  ConversationSessionStatus.active => 'En cours',
  ConversationSessionStatus.finalizing => 'Analyse en cours',
  ConversationSessionStatus.completed => 'Résumé disponible',
  ConversationSessionStatus.failed => 'Appel interrompu',
};
