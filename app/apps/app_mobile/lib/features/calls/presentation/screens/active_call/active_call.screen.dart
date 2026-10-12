import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.state.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.view_model.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/widgets/active_call_content.widget.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Full-screen interface for one real Telnyx WebRTC call.
@RoutePage()
final class ActiveCallScreen extends ConsumerStatefulWidget {
  /// Creates the real call screen for [callId].
  const ActiveCallScreen({
    @PathParam('callId') required this.callId,
    @PathParam('sessionId') required this.sessionId,
    this.remoteNumber,
    this.incoming = false,
    this.companion = false,
    super.key,
  });

  /// Telnyx call identifier.
  final String callId;

  /// Pinkall backend conversation-session identifier.
  final String sessionId;

  /// Number shown before the first SDK state event arrives.
  final String? remoteNumber;

  /// Whether the route represents an incoming call.
  final bool incoming;

  /// Whether this route observes a call whose audio lives on another device.
  final bool companion;

  @override
  ConsumerState<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

final class _ActiveCallScreenState extends ConsumerState<ActiveCallScreen> {
  bool _allowPop = false;

  @override
  Widget build(BuildContext context) {
    final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
      widget.callId,
      widget.sessionId,
      widget.remoteNumber,
      widget.incoming,
      widget.companion,
    );
    final AsyncValue<ActiveCallState> asyncState = ref.watch(provider);
    final ActiveCallState? currentState = asyncState.value;
    final bool canLeave =
        _allowPop ||
        widget.companion ||
        (currentState != null && _isTerminal(currentState.session.status));

    return PopScope<Object?>(
      canPop: canLeave,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_confirmEndCall(context, provider));
        }
      },
      child: Scaffold(
        backgroundColor: PinkallColors.carbon,
        body: asyncState.when(
          loading: () => const _ActiveCallLoading(),
          error: (Object error, StackTrace stackTrace) =>
              _ActiveCallError(onRetry: () => ref.invalidate(provider)),
          data: (ActiveCallState state) => ActiveCallContent(
            state: state,
            onToggleMute: () => ref.read(provider.notifier).toggleMute(),
            onToggleSpeaker: () => ref.read(provider.notifier).toggleSpeaker(),
            onSelectAudioDevice: (AudioDeviceKind kind, String deviceId) =>
                ref.read(provider.notifier).selectAudioDevice(kind, deviceId),
            onRefreshAudioDevices: () =>
                ref.read(provider.notifier).refreshAudioDevices(),
            onCoachChanged: (bool enabled) =>
                ref.read(provider.notifier).setCoachEnabled(enabled: enabled),
            onAcknowledgeTranscription: (TranscriptionConsentMethod method) =>
                ref.read(provider.notifier).acknowledgeTranscription(method),
            onEndCall: () => ref.read(provider.notifier).hangUp(),
            onRetryDebrief: () => ref.read(provider.notifier).finalizeDebrief(),
            onReturn: () async {
              await context.router.maybePop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmEndCall(
    BuildContext context,
    ActiveCallViewModelProvider provider,
  ) async {
    final bool shouldEnd =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text(LocaleKeys.call_leave_title.tr()),
            content: Text(LocaleKeys.call_leave_body.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(LocaleKeys.common_cancel.tr()),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(LocaleKeys.call_leave_confirm.tr()),
              ),
            ],
          ),
        ) ??
        false;
    if (!shouldEnd || !context.mounted) {
      return;
    }
    final bool ended = await ref.read(provider.notifier).hangUp();
    if (ended && context.mounted) {
      await _popAfterHangUp(context);
    } else if (context.mounted) {
      await _confirmDisconnectAndLeave(context, provider);
    }
  }

  Future<void> _confirmDisconnectAndLeave(
    BuildContext context,
    ActiveCallViewModelProvider provider,
  ) async {
    final bool shouldDisconnect =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text(LocaleKeys.call_leave_failed_title.tr()),
            content: Text(LocaleKeys.call_leave_failed_body.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(LocaleKeys.common_cancel.tr()),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(LocaleKeys.call_leave_anyway.tr()),
              ),
            ],
          ),
        ) ??
        false;
    if (!shouldDisconnect || !context.mounted) {
      return;
    }
    try {
      await ref.read(provider.notifier).disconnectSession();
    } catch (_) {
      // The escape hatch stays available if provider setup itself failed.
    }
    if (context.mounted) {
      await _popAfterHangUp(context);
    }
  }

  Future<void> _popAfterHangUp(BuildContext context) async {
    if (!_allowPop) {
      setState(() => _allowPop = true);
      await WidgetsBinding.instance.endOfFrame;
    }
    if (!mounted || !context.mounted) {
      return;
    }
    await context.router.maybePop();
  }
}

bool _isTerminal(CallLifecycleStatus status) => <CallLifecycleStatus>{
  CallLifecycleStatus.ended,
  CallLifecycleStatus.error,
}.contains(status);

final class _ActiveCallLoading extends StatelessWidget {
  const _ActiveCallLoading();

  @override
  Widget build(BuildContext context) {
    final bool reducedMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return ColoredBox(
      color: PinkallColors.carbon,
      child: Center(
        child: Semantics(
          liveRegion: true,
          label: 'Connexion à l’appel',
          child: ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (reducedMotion)
                  const Icon(
                    Icons.more_horiz,
                    color: PinkallColors.pinkContainer,
                    size: 24,
                  )
                else
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      color: PinkallColors.pink,
                      strokeWidth: 1.6,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  'Connexion à l’appel…',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.56),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _ActiveCallError extends StatelessWidget {
  const _ActiveCallError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: PinkallColors.carbon,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Color(0xFFF199B6),
                size: 24,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.error_title.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: PinkallColors.onStrong,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.error_body.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PinkallColors.onStrong.withValues(alpha: 0.52),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onRetry,
                child: Text(LocaleKeys.common_retry.tr()),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
