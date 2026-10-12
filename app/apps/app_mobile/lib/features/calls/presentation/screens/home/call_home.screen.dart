import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.state.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.view_model.dart';
import 'package:pinkall/features/calls/presentation/screens/home/widgets/call_home_content.widget.dart';
import 'package:pinkall/features/crm/presentation/crm.screen.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_error_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_loading_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Entry screen for configuring Telnyx and placing real calls.
@RoutePage()
final class CallHomeScreen extends ConsumerStatefulWidget {
  /// Creates the Telnyx phone home screen.
  const CallHomeScreen({
    @QueryParam('number') this.initialPhoneNumber,
    this.deepLinkRequestId,
    super.key,
  });

  /// Normalized destination supplied by a Pinkall deep link.
  final String? initialPhoneNumber;

  /// Monotonic identifier used to replay an identical deep-link value.
  final int? deepLinkRequestId;

  @override
  ConsumerState<CallHomeScreen> createState() => _CallHomeScreenState();
}

final class _CallHomeScreenState extends ConsumerState<CallHomeScreen>
    with WidgetsBindingObserver {
  bool _isForeground = true;
  bool _checkingRecordingImport = false;
  bool _recordingImportRouteOpen = false;
  CallHomeViewModel? _viewModel;
  ContactEntity? _selectedContact;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(_consumeRecordingImportAction()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel?.stopActiveSessionsPolling();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    final CallHomeViewModel notifier;
    if (_viewModel case final CallHomeViewModel existing) {
      notifier = existing;
    } else {
      notifier = ref.read(callHomeViewModelProvider.notifier);
      _viewModel = notifier;
    }
    if (_isForeground) {
      notifier.startActiveSessionsPolling();
      unawaited(_consumeRecordingImportAction());
    } else {
      notifier.stopActiveSessionsPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    _viewModel ??= ref.read(callHomeViewModelProvider.notifier);
    ref.listen<AsyncValue<CallHomeState>>(callHomeViewModelProvider, (
      AsyncValue<CallHomeState>? previous,
      AsyncValue<CallHomeState> next,
    ) {
      if (_isForeground && next.hasValue) {
        _viewModel?.startActiveSessionsPolling();
      }
    });
    final AsyncValue<CallHomeState> asyncState = ref.watch(
      callHomeViewModelProvider,
    );
    final CallHomeState? currentState = asyncState.value;
    return Scaffold(
      body: PinkallPageFrame(
        desktopLeadingWidth: 304,
        accessory: _HomeAccessory(
          state: currentState,
          onOpenWorkspaceContext: () =>
              context.router.push(WorkspaceSalesContextRoute(editing: true)),
          onOpenHistory: () => context.router.push(const CallHistoryRoute()),
          onOpenProgress: () => context.router.push(const CallProgressRoute()),
          onOpenObjections: () =>
              context.router.push(const ObjectionLibraryRoute()),
          onOpenInstantHelp: () =>
              context.router.push(const InstantHelpRoute()),
          onOpenRecordingImport: () =>
              context.router.push(RecordingImportRoute(openPicker: true)),
          onRefreshSessions: () => ref
              .read(callHomeViewModelProvider.notifier)
              .refreshActiveSessions(),
          onOpenCompanion: (ConversationSessionEntity session) =>
              context.router.push(
                ActiveCallRoute(
                  callId: session.callId,
                  sessionId: session.id,
                  remoteNumber: session.destinationNumber,
                  companion: true,
                ),
              ),
        ),
        child: asyncState.when(
          loading: () => const PinkallLoadingView(),
          error: (Object error, StackTrace stackTrace) => PinkallErrorView(
            onRetry: () => ref.invalidate(callHomeViewModelProvider),
          ),
          data: (CallHomeState state) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool desktop = constraints.maxWidth >= 1044;
              final Widget dialer = _buildDialer(
                context,
                state,
                compact: !desktop,
              );
              if (!desktop) {
                return dialer;
              }
              return Row(
                key: const Key('unified_call_contacts_workspace'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 304,
                    child: CrmContactDirectoryPane(
                      onContactSelected: _selectContact,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  Expanded(child: dialer),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDialer(
    BuildContext context,
    CallHomeState state, {
    required bool compact,
  }) {
    return CallHomeContent(
      state: state,
      initialPhoneNumber: widget.initialPhoneNumber,
      deepLinkRequestId: widget.deepLinkRequestId,
      selectedContact: _selectedContact,
      onOpenContacts: compact ? () => _openContactsSheet(context) : null,
      onConnectAutomatically: () =>
          ref.read(callHomeViewModelProvider.notifier).connectAutomatically(),
      onConnect: (TelnyxConfigurationEntity configuration) =>
          ref.read(callHomeViewModelProvider.notifier).connect(configuration),
      onDisconnect: () =>
          ref.read(callHomeViewModelProvider.notifier).disconnect(),
      onDial: (String destination, String? preparationMarkdown) =>
          _dial(context, destination, null, preparationMarkdown),
      onDialContact:
          (
            String destination,
            ContactEntity? contact,
            String? preparationMarkdown,
          ) => _dial(context, destination, contact, preparationMarkdown),
      onAnswer: (CallStateEntity call) async {
        final ConversationSessionEntity? backendSession = await ref
            .read(callHomeViewModelProvider.notifier)
            .acceptIncoming(call);
        if (backendSession != null && context.mounted) {
          await context.router.push(
            ActiveCallRoute(
              callId: call.callId,
              sessionId: backendSession.id,
              remoteNumber: call.remoteNumber,
              incoming: true,
            ),
          );
        }
      },
      onDecline: (String callId) =>
          ref.read(callHomeViewModelProvider.notifier).rejectIncoming(callId),
      onRefreshIncomingCallCapability: () => ref
          .read(callHomeViewModelProvider.notifier)
          .refreshIncomingCallCapability(),
    );
  }

  Future<void> _dial(
    BuildContext context,
    String destination,
    ContactEntity? contact,
    String? preparationMarkdown,
  ) async {
    final EvaluateCallEligibilityParam? facts = await _showEligibilityGate(
      context,
      destination,
      contact: contact,
    );
    if (facts == null || !context.mounted) {
      return;
    }
    final CallLaunchResult? launch = await ref
        .read(callHomeViewModelProvider.notifier)
        .dial(facts, preparationMarkdown: preparationMarkdown);
    if (launch != null && context.mounted) {
      await context.router.push(
        ActiveCallRoute(
          callId: launch.callId,
          sessionId: launch.backendSession.id,
          remoteNumber: destination,
          incoming: false,
        ),
      );
    }
  }

  void _selectContact(ContactEntity contact) {
    setState(() => _selectedContact = contact);
  }

  Future<void> _openContactsSheet(BuildContext context) async {
    final ContactEntity? contact = await showModalBottomSheet<ContactEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: const BoxConstraints(maxWidth: 680),
      builder: (BuildContext sheetContext) => FractionallySizedBox(
        heightFactor: 0.88,
        child: CrmContactDirectoryPane(
          compact: true,
          onContactSelected: (ContactEntity value) =>
              Navigator.of(sheetContext).pop(value),
        ),
      ),
    );
    if (contact != null && mounted) {
      _selectContact(contact);
    }
  }

  Future<void> _consumeRecordingImportAction() async {
    if (!mounted ||
        _checkingRecordingImport ||
        _recordingImportRouteOpen ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return;
    }
    _checkingRecordingImport = true;
    try {
      final RecordingImportAction? action = await ref
          .read(recordingImportClientProvider)
          .consumePendingAction();
      if (!mounted || action == null) return;
      _recordingImportRouteOpen = true;
      switch (action) {
        case RecordingImportPickerRequested():
          await context.router.push(RecordingImportRoute(openPicker: true));
          break;
        case RecordingAudioImport():
          await context.router.push(
            RecordingImportRoute(initialImport: action),
          );
          break;
      }
    } on RecordingImportException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      _checkingRecordingImport = false;
      _recordingImportRouteOpen = false;
    }
  }
}

final class _HomeAccessory extends StatelessWidget {
  const _HomeAccessory({
    required this.state,
    required this.onOpenWorkspaceContext,
    required this.onOpenHistory,
    required this.onOpenProgress,
    required this.onOpenObjections,
    required this.onOpenInstantHelp,
    required this.onOpenRecordingImport,
    required this.onRefreshSessions,
    required this.onOpenCompanion,
  });

  final CallHomeState? state;
  final VoidCallback onOpenWorkspaceContext;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenProgress;
  final VoidCallback onOpenObjections;
  final VoidCallback onOpenInstantHelp;
  final VoidCallback onOpenRecordingImport;
  final Future<void> Function() onRefreshSessions;
  final Future<void> Function(ConversationSessionEntity session)
  onOpenCompanion;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isMacOS =
            !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
        final bool isMobile =
            !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android);
        final bool compact = constraints.maxWidth < 560;
        final ButtonStyle? compactIconStyle = compact
            ? IconButton.styleFrom(
                minimumSize: const Size.square(44),
                maximumSize: const Size.square(44),
                padding: const EdgeInsets.all(10),
              ).copyWith(tapTargetSize: MaterialTapTargetSize.shrinkWrap)
            : null;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (compact)
              SizedBox.square(
                dimension: 44,
                child: PopupMenuButton<VoidCallback>(
                  key: const Key('home_compact_more_button'),
                  tooltip: 'Plus d’actions',
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz_rounded, size: 20),
                  onSelected: (VoidCallback action) => action(),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<VoidCallback>>[
                        if (isMacOS)
                          PopupMenuItem<VoidCallback>(
                            value: onOpenInstantHelp,
                            child: const _CompactMenuLabel(
                              icon: Icons.auto_awesome_rounded,
                              label: 'Instant Help',
                            ),
                          ),
                        if (isMobile)
                          PopupMenuItem<VoidCallback>(
                            value: onOpenRecordingImport,
                            child: const _CompactMenuLabel(
                              icon: Icons.upload_file_rounded,
                              label: 'Importer un appel',
                            ),
                          ),
                        PopupMenuItem<VoidCallback>(
                          value: onOpenWorkspaceContext,
                          child: const _CompactMenuLabel(
                            icon: Icons.auto_awesome_outlined,
                            label: 'Contexte entreprise',
                          ),
                        ),
                        PopupMenuItem<VoidCallback>(
                          value: onOpenObjections,
                          child: const _CompactMenuLabel(
                            icon: Icons.forum_outlined,
                            label: 'Objections',
                          ),
                        ),
                      ],
                ),
              )
            else if (isMacOS) ...<Widget>[
              _HomeNavigationBar(
                onOpenWorkspaceContext: onOpenWorkspaceContext,
                onOpenHistory: onOpenHistory,
                onOpenProgress: onOpenProgress,
                onOpenObjections: onOpenObjections,
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                key: const Key('open_instant_help_button'),
                onPressed: onOpenInstantHelp,
                style: FilledButton.styleFrom(
                  backgroundColor: PinkallColors.pinkWash,
                  foregroundColor: PinkallColors.pinkDark,
                  minimumSize: const Size(0, 36),
                  maximumSize: const Size(double.infinity, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome_rounded, size: 17),
                label: const Text('Instant Help'),
              ),
            ],
            if (isMobile && !compact)
              IconButton(
                key: const Key('open_recording_import_button'),
                tooltip: 'Importer un appel',
                onPressed: onOpenRecordingImport,
                icon: const Icon(Icons.upload_file_rounded, size: 20),
              ),
            if (!compact && !isMacOS)
              IconButton(
                key: const Key('open_workspace_context_button'),
                tooltip: 'Contexte entreprise',
                onPressed: onOpenWorkspaceContext,
                icon: const Icon(Icons.auto_awesome_outlined, size: 20),
              ),
            if (!isMacOS || compact) ...<Widget>[
              IconButton(
                key: const Key('open_call_history_button'),
                tooltip: 'Historique des appels',
                onPressed: onOpenHistory,
                visualDensity: compact ? VisualDensity.compact : null,
                style: compactIconStyle,
                icon: const Icon(Icons.history_rounded, size: 20),
              ),
              IconButton(
                key: const Key('open_call_progress_button'),
                tooltip: LocaleKeys.progress_tooltip.tr(),
                onPressed: onOpenProgress,
                visualDensity: compact ? VisualDensity.compact : null,
                style: compactIconStyle,
                icon: const Icon(Icons.radar_rounded, size: 20),
              ),
              if (!compact)
                IconButton(
                  key: const Key('open_objection_library_button'),
                  tooltip: 'Bibliothèque d’objections',
                  onPressed: onOpenObjections,
                  icon: const Icon(Icons.forum_outlined, size: 20),
                ),
            ],
            if (state case final CallHomeState value
                when value.activeBackendSessions.isNotEmpty) ...<Widget>[
              const Gap(8),
              _ActiveSessionsAccessory(
                state: value,
                onRefreshSessions: onRefreshSessions,
                onOpenCompanion: onOpenCompanion,
              ),
            ],
          ],
        );
      },
    );
  }
}

final class _HomeNavigationBar extends StatelessWidget {
  const _HomeNavigationBar({
    required this.onOpenWorkspaceContext,
    required this.onOpenHistory,
    required this.onOpenProgress,
    required this.onOpenObjections,
  });

  final VoidCallback onOpenWorkspaceContext;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenProgress;
  final VoidCallback onOpenObjections;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _HomeNavigationItem(
              label: 'Appeler',
              tooltip: 'Appeler',
              selected: true,
            ),
            _HomeNavigationItem(
              key: const Key('open_call_history_button'),
              label: 'Historique',
              tooltip: 'Historique des appels',
              onPressed: onOpenHistory,
            ),
            _HomeNavigationItem(
              key: const Key('open_call_progress_button'),
              label: 'Objectifs',
              tooltip: LocaleKeys.progress_tooltip.tr(),
              onPressed: onOpenProgress,
            ),
            _HomeNavigationItem(
              key: const Key('open_objection_library_button'),
              label: 'Objections',
              tooltip: 'Bibliothèque d’objections',
              onPressed: onOpenObjections,
            ),
            _HomeNavigationItem(
              key: const Key('open_workspace_context_button'),
              label: 'Contexte',
              tooltip: 'Contexte entreprise',
              onPressed: onOpenWorkspaceContext,
            ),
          ],
        ),
      ),
    );
  }
}

final class _HomeNavigationItem extends StatelessWidget {
  const _HomeNavigationItem({
    required this.label,
    required this.tooltip,
    this.selected = false,
    this.onPressed,
    super.key,
  });

  final String label;
  final String tooltip;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: selected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          child: InkWell(
            onTap: selected ? null : onPressed,
            borderRadius: BorderRadius.circular(9),
            child: SizedBox(
              height: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _CompactMenuLabel extends StatelessWidget {
  const _CompactMenuLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[Icon(icon, size: 19), const Gap(12), Text(label)],
    );
  }
}

Future<EvaluateCallEligibilityParam?> _showEligibilityGate(
  BuildContext context,
  String phoneNumber, {
  ContactEntity? contact,
}) {
  return showDialog<EvaluateCallEligibilityParam>(
    context: context,
    builder: (BuildContext context) =>
        _EligibilityDialog(phoneNumber: phoneNumber, contact: contact),
  );
}

final class _ActiveSessionsAccessory extends StatelessWidget {
  const _ActiveSessionsAccessory({
    required this.state,
    required this.onRefreshSessions,
    required this.onOpenCompanion,
  });

  final CallHomeState state;
  final Future<void> Function() onRefreshSessions;
  final Future<void> Function(ConversationSessionEntity session)
  onOpenCompanion;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool compact = MediaQuery.sizeOf(context).width < 720;
    final int activeCount = state.activeBackendSessions.length;
    final ButtonStyle compactIconStyle = IconButton.styleFrom(
      minimumSize: const Size.square(44),
      maximumSize: const Size.square(44),
      padding: const EdgeInsets.all(10),
    ).copyWith(tapTargetSize: MaterialTapTargetSize.shrinkWrap);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (compact)
          Badge(
            label: Text('$activeCount'),
            backgroundColor: colors.primary,
            textColor: colors.onPrimary,
            child: IconButton(
              tooltip:
                  '$activeCount ${activeCount > 1 ? 'appels actifs' : 'appel actif'} · observer',
              onPressed: () => _openSessionPicker(context),
              style: compactIconStyle.copyWith(
                foregroundColor: WidgetStatePropertyAll<Color>(
                  colors.onSurfaceVariant,
                ),
              ),
              icon: const Icon(Icons.devices_outlined, size: 17),
            ),
          )
        else
          TextButton.icon(
            onPressed: () => _openSessionPicker(context),
            style: TextButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              minimumSize: const Size(40, 36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            icon: const Icon(Icons.devices_outlined, size: 17),
            label: Text('$activeCount en cours'),
          ),
        IconButton(
          tooltip: 'Actualiser les sessions',
          onPressed: onRefreshSessions,
          style: compact ? compactIconStyle : null,
          icon: const Icon(Icons.refresh_outlined, size: 17),
        ),
      ],
    );
  }

  Future<void> _openSessionPicker(BuildContext context) async {
    final ConversationSessionEntity?
    session = await showDialog<ConversationSessionEntity>(
      context: context,
      builder: (BuildContext dialogContext) => SimpleDialog(
        title: const Text('Observer un appel actif'),
        children: state.activeBackendSessions
            .map<Widget>(
              (ConversationSessionEntity value) => SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(value),
                child: ListTile(
                  leading: const Icon(Icons.laptop_mac_rounded),
                  title: Text('Session ${value.id}'),
                  subtitle: const Text(
                    'Transcription et coach uniquement · audio sur l’appareil source',
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
    if (session != null) {
      await onOpenCompanion(session);
    }
  }
}

final class _EligibilityDialog extends StatefulWidget {
  const _EligibilityDialog({required this.phoneNumber, this.contact});

  final String phoneNumber;
  final ContactEntity? contact;

  @override
  State<_EligibilityDialog> createState() => _EligibilityDialogState();
}

final class _EligibilityDialogState extends State<_EligibilityDialog> {
  late ContactMarket _market;
  late bool _hasPriorConsent;
  late bool _hasOptedOut;
  late bool _professionalRelevanceConfirmed;

  @override
  void initState() {
    super.initState();
    final ContactEntity? contact = widget.contact;
    _market = contact?.market ?? ContactMarket.unknown;
    _hasPriorConsent = contact?.hasPriorConsent ?? false;
    _hasOptedOut = contact?.hasOptedOut ?? false;
    _professionalRelevanceConfirmed =
        contact?.professionalRelevanceConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bool marketKnown = _market != ContactMarket.unknown;
    return AlertDialog(
      title: const Text('Vérifier avant d’appeler'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.phoneNumber,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ContactMarket>(
              isExpanded: true,
              initialValue: _market,
              decoration: const InputDecoration(labelText: 'Type de contact'),
              items: const <DropdownMenuItem<ContactMarket>>[
                DropdownMenuItem<ContactMarket>(
                  value: ContactMarket.unknown,
                  child: Text('Je ne sais pas — appel bloqué'),
                ),
                DropdownMenuItem<ContactMarket>(
                  value: ContactMarket.b2b,
                  child: Text('B2B · contact professionnel'),
                ),
                DropdownMenuItem<ContactMarket>(
                  value: ContactMarket.b2c,
                  child: Text('B2C · particulier'),
                ),
              ],
              onChanged: (ContactMarket? value) {
                setState(() => _market = value ?? ContactMarket.unknown);
              },
            ),
            if (_market == ContactMarket.b2b)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _professionalRelevanceConfirmed,
                title: const Text(
                  'L’offre est pertinente pour son activité professionnelle',
                ),
                onChanged: (bool? value) => setState(
                  () => _professionalRelevanceConfirmed = value ?? false,
                ),
              ),
            if (_market == ContactMarket.b2c)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _hasPriorConsent,
                title: const Text(
                  'Accord préalable ou contrat autorisant cet appel',
                ),
                onChanged: (bool? value) =>
                    setState(() => _hasPriorConsent = value ?? false),
              ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _hasOptedOut,
              title: const Text('Le contact s’est opposé aux appels'),
              onChanged: (bool? value) =>
                  setState(() => _hasOptedOut = value ?? false),
            ),
            if (!marketKnown)
              Text(
                'Pinkall ne lance aucun appel tant que le marché est inconnu.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: !marketKnown
              ? null
              : () => Navigator.of(context).pop(
                  EvaluateCallEligibilityParam(
                    phoneNumber: widget.phoneNumber,
                    market: _market,
                    contactId: widget.contact?.id,
                    hasPriorConsent: _market == ContactMarket.b2c
                        ? _hasPriorConsent
                        : null,
                    hasOptedOut: _hasOptedOut,
                    professionalRelevanceConfirmed: _market == ContactMarket.b2b
                        ? _professionalRelevanceConfirmed
                        : null,
                    countryCode: 'FR',
                  ),
                ),
          child: const Text('Vérifier et appeler'),
        ),
      ],
    );
  }
}
