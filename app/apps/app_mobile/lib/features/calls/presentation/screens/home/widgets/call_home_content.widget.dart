import 'dart:convert';

import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.state.dart';
import 'package:pinkall/features/calls/presentation/screens/home/dialer_phone_number.dart';
import 'package:pinkall/features/shared/presentation/widgets/voice_briefing_dictation.widget.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Responsive Telnyx setup and dialer content.
final class CallHomeContent extends StatefulWidget {
  /// Creates the real-calling home content.
  const CallHomeContent({
    required this.state,
    required this.onConnect,
    required this.onConnectAutomatically,
    required this.onDisconnect,
    required this.onDial,
    required this.onAnswer,
    required this.onDecline,
    required this.onRefreshIncomingCallCapability,
    this.onDialContact,
    this.initialPhoneNumber,
    this.deepLinkRequestId,
    this.selectedContact,
    this.onOpenContacts,
    super.key,
  });

  /// Current home state.
  final CallHomeState state;

  /// Registers the Telnyx client with runtime-only configuration.
  final Future<void> Function(TelnyxConfigurationEntity configuration)
  onConnect;

  /// Retries server-issued ephemeral Telnyx authentication.
  final Future<void> Function() onConnectAutomatically;

  /// Disconnects the Telnyx client.
  final Future<void> Function() onDisconnect;

  /// Places a real outbound call.
  final Future<void> Function(String destination, String? preparationMarkdown)
  onDial;

  /// Places a call while preserving the selected backend contact context.
  ///
  /// This is optional so the standalone dialer remains reusable in tests and
  /// setup surfaces that only know about a raw destination.
  final Future<void> Function(
    String destination,
    ContactEntity? selectedContact,
    String? preparationMarkdown,
  )?
  onDialContact;

  /// Destination supplied by an application link when the composer opens.
  final String? initialPhoneNumber;

  /// Changes for every received link, including repeated identical links.
  final int? deepLinkRequestId;

  /// Real CRM contact currently selected in the unified workspace.
  final ContactEntity? selectedContact;

  /// Opens the compact contacts sheet on narrow screens.
  final VoidCallback? onOpenContacts;

  /// Accepts a real incoming call.
  final Future<void> Function(CallStateEntity call) onAnswer;

  /// Rejects a real incoming call.
  final Future<void> Function(String callId) onDecline;

  /// Refreshes the native background incoming-call readiness snapshot.
  final Future<void> Function() onRefreshIncomingCallCapability;

  @override
  State<CallHomeContent> createState() => _CallHomeContentState();
}

final class _CallHomeContentState extends State<CallHomeContent> {
  final GlobalKey<FormState> _connectionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dialerFormKey = GlobalKey<FormState>();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _sipUserController = TextEditingController();
  final TextEditingController _sipPasswordController = TextEditingController();
  final TextEditingController _callerNameController = TextEditingController();
  final TextEditingController _callerNumberController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  _AuthenticationMode _authenticationMode = _AuthenticationMode.token;
  String? _preparationMarkdown;
  String? _preparationFileName;

  @override
  void initState() {
    super.initState();
    _applySelectedContact(widget.selectedContact);
    _applyInitialPhoneNumber(widget.initialPhoneNumber);
  }

  @override
  void didUpdateWidget(CallHomeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.deepLinkRequestId != oldWidget.deepLinkRequestId ||
        widget.initialPhoneNumber != oldWidget.initialPhoneNumber) {
      _applyInitialPhoneNumber(widget.initialPhoneNumber);
    } else if (widget.selectedContact?.id != oldWidget.selectedContact?.id) {
      _applySelectedContact(widget.selectedContact);
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _sipUserController.dispose();
    _sipPasswordController.dispose();
    _callerNameController.dispose();
    _callerNumberController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    final bool isReady =
        widget.state.connection.status == TelnyxConnectionStatus.ready;
    final bool isConnecting = <TelnyxConnectionStatus>{
      TelnyxConnectionStatus.connecting,
      TelnyxConnectionStatus.connected,
      TelnyxConnectionStatus.reconnecting,
    }.contains(widget.state.connection.status);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _HomeWindowClass windowClass = switch (constraints.maxWidth) {
          < 720 => _HomeWindowClass.mobile,
          < 1100 => _HomeWindowClass.medium,
          _ => _HomeWindowClass.wide,
        };
        final bool mobile = windowClass == _HomeWindowClass.mobile;
        final bool compactShortWindow =
            !mobile &&
            constraints.maxHeight.isFinite &&
            constraints.maxHeight < 700;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: switch (windowClass) {
              _HomeWindowClass.mobile => 16,
              _HomeWindowClass.medium => 32,
              _HomeWindowClass.wide => 32,
            },
            vertical: compactShortWindow ? 16 : (mobile ? 16 : 24),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: _StatusPill(
                            connection: widget.state.connection,
                          ),
                        ),
                        const Spacer(),
                        if (mobile &&
                            widget.onOpenContacts != null) ...<Widget>[
                          IconButton(
                            key: const Key('open_contacts_button'),
                            tooltip: 'Contacts',
                            onPressed: widget.onOpenContacts,
                            style: IconButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              minimumSize: const Size.square(40),
                              maximumSize: const Size.square(40),
                            ),
                            icon: const Icon(
                              Icons.person_search_outlined,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (isReady)
                          IconButton(
                            tooltip: LocaleKeys.telnyx_disconnect.tr(),
                            onPressed: widget.state.isOperating
                                ? null
                                : _disconnect,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(36),
                              maximumSize: const Size.square(36),
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            icon: const Icon(
                              Icons.power_settings_new_rounded,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.state.operationFailure != null) ...<Widget>[
                    Gap(tokens.spaceMedium),
                    _ErrorPanel(message: widget.state.operationFailure!),
                  ],
                  if (widget.state.incomingCallCapability.status !=
                          IncomingCallCapabilityStatus.disabled &&
                      widget.state.incomingCallCapability.status !=
                          IncomingCallCapabilityStatus.unsupported) ...<Widget>[
                    Gap(tokens.spaceMedium),
                    _IncomingCallCapabilityPanel(
                      capability: widget.state.incomingCallCapability,
                      refreshing: widget.state.isCheckingIncomingCallCapability,
                      onRefresh: widget.onRefreshIncomingCallCapability,
                    ),
                  ],
                  Gap(compactShortWindow || mobile ? 16 : 24),
                  if (widget.state.incomingCall
                      case final CallStateEntity call) ...<Widget>[
                    _IncomingCallPanel(
                      call: call,
                      disabled: widget.state.isOperating,
                      onAnswer: () => widget.onAnswer(call),
                      onDecline: () => widget.onDecline(call.callId),
                    ),
                    Gap(tokens.spaceLarge),
                  ],
                  if (isReady)
                    _DialerWorkspace(
                      formKey: _dialerFormKey,
                      destinationController: _destinationController,
                      selectedContact: widget.selectedContact,
                      preparationMarkdown: _preparationMarkdown,
                      preparationFileName: _preparationFileName,
                      disabled: widget.state.isOperating,
                      onDial: _dial,
                      onEditPreparation: _editPreparation,
                      compact: compactShortWindow,
                    )
                  else if (isConnecting)
                    const _ConnectingPanel()
                  else if (widget.state.manualTelnyxAuthEnabled)
                    _ManualConnectionPanel(
                      formKey: _connectionFormKey,
                      authenticationMode: _authenticationMode,
                      tokenController: _tokenController,
                      sipUserController: _sipUserController,
                      sipPasswordController: _sipPasswordController,
                      callerNameController: _callerNameController,
                      callerNumberController: _callerNumberController,
                      disabled: widget.state.isOperating,
                      onAuthenticationModeChanged: (_AuthenticationMode mode) =>
                          setState(() => _authenticationMode = mode),
                      onConnect: _connect,
                    )
                  else
                    _AutomaticConnectionPanel(
                      disabled: widget.state.isOperating,
                      onRetry: widget.onConnectAutomatically,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _connect() async {
    if (_connectionFormKey.currentState?.validate() != true) {
      return;
    }
    final TelnyxAuthenticationEntity authentication =
        _authenticationMode == _AuthenticationMode.token
        ? TelnyxAuthenticationEntity.token(
            sipToken: _tokenController.text.trim(),
          )
        : TelnyxAuthenticationEntity.credentials(
            sipUser: _sipUserController.text.trim(),
            sipPassword: _sipPasswordController.text,
          );
    try {
      await widget.onConnect(
        TelnyxConfigurationEntity(
          authentication: authentication,
          callerName: _callerNameController.text.trim(),
          callerNumber: normalizeDialerPhoneNumber(
            _callerNumberController.text,
          ),
        ),
      );
    } finally {
      _tokenController.clear();
      _sipPasswordController.clear();
    }
  }

  Future<void> _disconnect() async {
    try {
      await widget.onDisconnect();
    } finally {
      _clearSessionFields();
    }
  }

  void _clearSessionFields() {
    _tokenController.clear();
    _sipUserController.clear();
    _sipPasswordController.clear();
    _callerNameController.clear();
    _callerNumberController.clear();
    _destinationController.clear();
    _preparationMarkdown = null;
    _preparationFileName = null;
    if (mounted && _authenticationMode != _AuthenticationMode.token) {
      setState(() => _authenticationMode = _AuthenticationMode.token);
    }
  }

  Future<void> _dial() async {
    if (_dialerFormKey.currentState?.validate() != true) {
      return;
    }
    final String destination = normalizeDialerPhoneNumber(
      _destinationController.text,
    );
    final ContactEntity? contact = _contactMatching(destination);
    final Future<void> Function(String, ContactEntity?, String?)?
    preparedDialContact = widget.onDialContact;
    if (preparedDialContact != null) {
      await preparedDialContact(destination, contact, _preparationMarkdown);
      return;
    }
    await widget.onDial(destination, _preparationMarkdown);
  }

  Future<void> _editPreparation() async {
    final _PreparationResult? result =
        await showModalBottomSheet<_PreparationResult>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          barrierColor: Theme.of(
            context,
          ).colorScheme.scrim.withValues(alpha: 0.32),
          constraints: const BoxConstraints(maxWidth: 720),
          builder: (BuildContext sheetContext) => _CallPreparationSheet(
            initialMarkdown: _preparationMarkdown,
            initialFileName: _preparationFileName,
          ),
        );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _preparationMarkdown = result.markdown;
      _preparationFileName = result.fileName;
    });
  }

  void _applySelectedContact(ContactEntity? contact) {
    if (contact == null) {
      return;
    }
    _destinationController.value = TextEditingValue(
      text: contact.phoneNumber,
      selection: TextSelection.collapsed(offset: contact.phoneNumber.length),
    );
  }

  void _applyInitialPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || !isValidDialerPhoneNumber(phoneNumber)) {
      return;
    }

    final String normalizedPhoneNumber = normalizeDialerPhoneNumber(
      phoneNumber,
    );
    _destinationController.value = TextEditingValue(
      text: normalizedPhoneNumber,
      selection: TextSelection.collapsed(offset: normalizedPhoneNumber.length),
    );
  }

  ContactEntity? _contactMatching(String destination) {
    final ContactEntity? contact = widget.selectedContact;
    if (contact == null ||
        normalizeDialerPhoneNumber(contact.phoneNumber) != destination) {
      return null;
    }
    return contact;
  }
}

enum _AuthenticationMode { token, credentials }

enum _HomeWindowClass { mobile, medium, wide }

final class _IncomingCallCapabilityPanel extends StatelessWidget {
  const _IncomingCallCapabilityPanel({
    required this.capability,
    required this.refreshing,
    required this.onRefresh,
  });

  final IncomingCallCapabilityEntity capability;
  final bool refreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool ready = capability.isReady;
    final Color accent = ready ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      key: const Key('incoming_call_capability_panel'),
      liveRegion: true,
      label: _incomingCallCapabilityTitle(capability.status).tr(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              ready
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              size: 18,
              color: accent,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _incomingCallCapabilityTitle(capability.status).tr(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Gap(2),
                  Text(
                    _incomingCallCapabilityBody(capability).tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              key: const Key('refresh_incoming_call_capability_button'),
              tooltip: LocaleKeys.incoming_calls_refresh.tr(),
              onPressed: refreshing ? null : () => onRefresh(),
              icon: refreshing
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

String _incomingCallCapabilityTitle(
  IncomingCallCapabilityStatus status,
) => switch (status) {
  IncomingCallCapabilityStatus.ready => LocaleKeys.incoming_calls_status_ready,
  IncomingCallCapabilityStatus.registering =>
    LocaleKeys.incoming_calls_status_registering,
  IncomingCallCapabilityStatus.configurationRequired =>
    LocaleKeys.incoming_calls_status_configuration_required,
  IncomingCallCapabilityStatus.disabled =>
    LocaleKeys.incoming_calls_status_disabled,
  IncomingCallCapabilityStatus.unsupported =>
    LocaleKeys.incoming_calls_status_unsupported,
  IncomingCallCapabilityStatus.error => LocaleKeys.incoming_calls_status_error,
};

String _incomingCallCapabilityBody(IncomingCallCapabilityEntity capability) {
  if (capability.isReady) return LocaleKeys.incoming_calls_body_ready;
  if (capability.platform == IncomingCallPlatform.android &&
      capability.backgroundDeliveryReady &&
      !capability.nativeCallUiReady) {
    return LocaleKeys.incoming_calls_body_android_ui_pending;
  }
  return switch (capability.status) {
    IncomingCallCapabilityStatus.registering =>
      LocaleKeys.incoming_calls_body_registering,
    IncomingCallCapabilityStatus.configurationRequired =>
      LocaleKeys.incoming_calls_body_configuration_required,
    IncomingCallCapabilityStatus.disabled =>
      LocaleKeys.incoming_calls_body_disabled,
    IncomingCallCapabilityStatus.unsupported =>
      LocaleKeys.incoming_calls_body_unsupported,
    IncomingCallCapabilityStatus.error => LocaleKeys.incoming_calls_body_error,
    IncomingCallCapabilityStatus.ready => LocaleKeys.incoming_calls_body_ready,
  };
}

final class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.connection});

  final TelnyxConnectionStateEntity connection;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool positive = connection.status == TelnyxConnectionStatus.ready;
    final bool failure = connection.status == TelnyxConnectionStatus.failure;
    final Color foreground = failure
        ? colorScheme.error
        : positive
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      liveRegion: true,
      label: _connectionLabel(connection.status).tr(),
      child: AnimatedSwitcher(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 140),
        child: Row(
          key: ValueKey<TelnyxConnectionStatus>(connection.status),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(7),
            Flexible(
              child: Text(
                _connectionLabel(connection.status).tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ManualConnectionPanel extends StatelessWidget {
  const _ManualConnectionPanel({
    required this.formKey,
    required this.authenticationMode,
    required this.tokenController,
    required this.sipUserController,
    required this.sipPasswordController,
    required this.callerNameController,
    required this.callerNumberController,
    required this.disabled,
    required this.onAuthenticationModeChanged,
    required this.onConnect,
  });

  final GlobalKey<FormState> formKey;
  final _AuthenticationMode authenticationMode;
  final TextEditingController tokenController;
  final TextEditingController sipUserController;
  final TextEditingController sipPasswordController;
  final TextEditingController callerNameController;
  final TextEditingController callerNumberController;
  final bool disabled;
  final ValueChanged<_AuthenticationMode> onAuthenticationModeChanged;
  final Future<void> Function() onConnect;

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                LocaleKeys.telnyx_config_title.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Gap(tokens.spaceSmall),
              Text(LocaleKeys.telnyx_config_body.tr()),
              Gap(tokens.spaceLarge),
              Text(
                LocaleKeys.telnyx_auth_mode.tr(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Gap(tokens.spaceSmall),
              SegmentedButton<_AuthenticationMode>(
                segments: <ButtonSegment<_AuthenticationMode>>[
                  ButtonSegment<_AuthenticationMode>(
                    value: _AuthenticationMode.token,
                    label: Text(LocaleKeys.telnyx_auth_token.tr()),
                  ),
                  ButtonSegment<_AuthenticationMode>(
                    value: _AuthenticationMode.credentials,
                    label: Text(LocaleKeys.telnyx_auth_credentials.tr()),
                  ),
                ],
                selected: <_AuthenticationMode>{authenticationMode},
                onSelectionChanged: disabled
                    ? null
                    : (Set<_AuthenticationMode> selected) =>
                          onAuthenticationModeChanged(selected.first),
              ),
              Gap(tokens.spaceLarge),
              if (authenticationMode == _AuthenticationMode.token)
                TextFormField(
                  controller: tokenController,
                  enabled: !disabled,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.telnyx_token.tr(),
                  ),
                  validator: _requiredValidator,
                )
              else ...<Widget>[
                TextFormField(
                  controller: sipUserController,
                  enabled: !disabled,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.telnyx_sip_user.tr(),
                  ),
                  validator: _requiredValidator,
                ),
                Gap(tokens.spaceMedium),
                TextFormField(
                  controller: sipPasswordController,
                  enabled: !disabled,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.telnyx_sip_password.tr(),
                  ),
                  validator: _requiredValidator,
                ),
              ],
              Gap(tokens.spaceMedium),
              TextFormField(
                controller: callerNameController,
                enabled: !disabled,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: LocaleKeys.telnyx_caller_name.tr(),
                ),
                validator: _requiredValidator,
              ),
              Gap(tokens.spaceMedium),
              TextFormField(
                controller: callerNumberController,
                enabled: !disabled,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: LocaleKeys.telnyx_caller_number.tr(),
                ),
                validator: _phoneValidator,
              ),
              Gap(tokens.spaceLarge),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.shield_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  Gap(tokens.spaceSmall),
                  Expanded(
                    child: Text(
                      LocaleKeys.telnyx_security_note.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              Gap(tokens.spaceLarge),
              FilledButton.icon(
                onPressed: disabled ? null : onConnect,
                icon: disabled
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.link_rounded),
                label: Text(
                  disabled
                      ? LocaleKeys.telnyx_connecting.tr()
                      : LocaleKeys.telnyx_connect.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ConnectingPanel extends StatelessWidget {
  const _ConnectingPanel();

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    final String label = _localizedCopy(
      context,
      french: 'Préparation de ton téléphone…',
      english: 'Preparing your phone…',
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            Gap(tokens.spaceLarge),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AutomaticConnectionPanel extends StatelessWidget {
  const _AutomaticConnectionPanel({
    required this.disabled,
    required this.onRetry,
  });

  final bool disabled;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    final String title = _localizedCopy(
      context,
      french: 'Le téléphone est hors ligne',
      english: 'Your phone is offline',
    );
    final String body = _localizedCopy(
      context,
      french: 'Vérifie ta connexion internet, puis réessaie.',
      english: 'Check your internet connection, then try again.',
    );
    final String pendingLabel = _localizedCopy(
      context,
      french: 'Connexion…',
      english: 'Connecting…',
    );
    final String retryLabel = _localizedCopy(
      context,
      french: 'Réessayer',
      english: 'Try again',
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.lock_person_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Gap(tokens.spaceSmall),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            Gap(tokens.spaceSmall),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Gap(tokens.spaceLarge),
            FilledButton.icon(
              onPressed: disabled ? null : onRetry,
              icon: disabled
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_outlined),
              label: Text(disabled ? pendingLabel : retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

final class _DialerWorkspace extends StatelessWidget {
  const _DialerWorkspace({
    required this.formKey,
    required this.destinationController,
    required this.selectedContact,
    required this.preparationMarkdown,
    required this.preparationFileName,
    required this.disabled,
    required this.onDial,
    required this.onEditPreparation,
    required this.compact,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController destinationController;
  final ContactEntity? selectedContact;
  final String? preparationMarkdown;
  final String? preparationFileName;
  final bool disabled;
  final Future<void> Function() onDial;
  final Future<void> Function() onEditPreparation;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool mobile = MediaQuery.sizeOf(context).width < 720;
    final Widget destinationField = TextFormField(
      key: const Key('dialer_destination_field'),
      controller: destinationController,
      enabled: !disabled,
      autofocus: !mobile,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: mobile ? 30 : 36,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.45,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
      onFieldSubmitted: disabled ? null : (_) => onDial(),
      decoration: InputDecoration(
        hintText: LocaleKeys.dialer_hint.tr(),
        hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontSize: mobile ? 30 : 36,
          color: colors.onSurface.withValues(alpha: 0.32),
          fontWeight: FontWeight.w400,
          letterSpacing: -0.45,
        ),
        suffixIcon: IconButton(
          tooltip: 'Effacer un chiffre',
          onPressed: disabled ? null : _backspace,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(36),
            maximumSize: const Size.square(36),
            foregroundColor: colors.onSurfaceVariant,
          ),
          icon: const Icon(Icons.backspace_outlined, size: 18),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      validator: _phoneValidator,
    );
    final Widget dialPad = _DialPad(
      disabled: disabled,
      compact: compact,
      onKeyPressed: _insert,
      onPlusPressed: () => _insert('+'),
    );
    final Widget callAction = SizedBox(
      width: 192,
      height: 48,
      child: FilledButton.icon(
        key: const Key('dialer_call_button'),
        onPressed: disabled ? null : onDial,
        style: FilledButton.styleFrom(
          backgroundColor: colors.onSurface,
          foregroundColor: colors.surface,
          disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.32),
          disabledForegroundColor: colors.surface.withValues(alpha: 0.72),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        icon: disabled
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.phone_outlined, size: 19),
        label: Text(
          disabled
              ? LocaleKeys.dialer_calling.tr()
              : LocaleKeys.dialer_call.tr(),
        ),
      ),
    );
    final Widget numberEntry = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          LocaleKeys.dialer_destination.tr().toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            letterSpacing: 0.75,
          ),
        ),
        const SizedBox(height: 4),
        FocusTraversalOrder(
          order: const NumericFocusOrder(1),
          child: destinationField,
        ),
        Divider(height: 1, color: colors.onSurface.withValues(alpha: 0.12)),
        if (selectedContact case final ContactEntity contact)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: destinationController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
                  if (normalizeDialerPhoneNumber(value.text) !=
                      normalizeDialerPhoneNumber(contact.phoneNumber)) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _SelectedContactContext(contact: contact),
                  );
                },
          ),
        const SizedBox(height: 14),
        _PreparationControl(
          markdown: preparationMarkdown,
          fileName: preparationFileName,
          disabled: disabled,
          onPressed: onEditPreparation,
        ),
        if (!mobile) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            _localizedCopy(
              context,
              french: 'Saisis le numéro au clavier ou utilise le pavé.',
              english: 'Type the number or use the keypad.',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            numberEntry,
            SizedBox(height: mobile ? 24 : 32),
            FocusTraversalOrder(
              order: const NumericFocusOrder(2),
              child: dialPad,
            ),
            SizedBox(height: compact ? 16 : 24),
            FocusTraversalOrder(
              order: const NumericFocusOrder(3),
              child: callAction,
            ),
          ],
        ),
      ),
    );
  }

  void _insert(String value) {
    final TextEditingValue current = destinationController.value;
    final TextSelection selection = current.selection;
    final int start = selection.isValid ? selection.start : current.text.length;
    final int end = selection.isValid ? selection.end : current.text.length;
    final String next = current.text.replaceRange(start, end, value);
    destinationController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + value.length),
    );
  }

  void _backspace() {
    final TextEditingValue current = destinationController.value;
    if (current.text.isEmpty) {
      return;
    }
    final TextSelection selection = current.selection;
    final int start = selection.isValid ? selection.start : current.text.length;
    final int end = selection.isValid ? selection.end : current.text.length;
    if (start != end) {
      destinationController.value = TextEditingValue(
        text: current.text.replaceRange(start, end, ''),
        selection: TextSelection.collapsed(offset: start),
      );
      return;
    }
    if (start <= 0) {
      return;
    }
    destinationController.value = TextEditingValue(
      text: current.text.replaceRange(start - 1, start, ''),
      selection: TextSelection.collapsed(offset: start - 1),
    );
  }
}

const int _maxPreparationBytes = 32 * 1024;

final class _PreparationControl extends StatelessWidget {
  const _PreparationControl({
    required this.markdown,
    required this.fileName,
    required this.disabled,
    required this.onPressed,
  });

  final String? markdown;
  final String? fileName;
  final bool disabled;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final String content = markdown?.trim() ?? '';
    final bool hasPreparation = content.isNotEmpty;
    final String? summary = hasPreparation
        ? _preparationSummary(content)
        : null;
    final Color background = hasPreparation
        ? colors.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('dialer_preparation_button'),
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: <Widget>[
              Icon(
                hasPreparation
                    ? Icons.auto_awesome_rounded
                    : Icons.description_outlined,
                size: 18,
                color: hasPreparation
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      hasPreparation
                          ? LocaleKeys.dialer_preparation_ready.tr()
                          : LocaleKeys.dialer_preparation_add.tr(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasPreparation && summary != null) ...<Widget>[
                      const Gap(4),
                      Text(
                        fileName?.trim().isNotEmpty == true
                            ? fileName!.trim()
                            : summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(8),
              Icon(
                hasPreparation
                    ? Icons.edit_outlined
                    : Icons.chevron_right_rounded,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PreparationResult {
  const _PreparationResult({required this.markdown, required this.fileName});

  final String? markdown;
  final String? fileName;
}

final class _CallPreparationSheet extends StatefulWidget {
  const _CallPreparationSheet({
    required this.initialMarkdown,
    required this.initialFileName,
  });

  final String? initialMarkdown;
  final String? initialFileName;

  @override
  State<_CallPreparationSheet> createState() => _CallPreparationSheetState();
}

final class _CallPreparationSheetState extends State<_CallPreparationSheet> {
  late final TextEditingController _controller;
  String? _fileName;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMarkdown ?? '');
    _fileName = widget.initialFileName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final int byteCount = utf8.encode(_controller.text).length;
    final bool hasContent = _controller.text.trim().isNotEmpty;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Material(
        key: const Key('call_preparation_sheet'),
        color: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 16, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            LocaleKeys.preparation_title.tr(),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.45,
                                ),
                          ),
                          const Gap(7),
                          Text(
                            LocaleKeys.preparation_body.tr(),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  height: 1.45,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),
                    IconButton(
                      tooltip: LocaleKeys.common_close.tr(),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      VoiceBriefingDictation(
                        controller: _controller,
                        idleTitle: LocaleKeys.voice_dictation_call_title.tr(),
                        idleDescription: LocaleKeys.voice_dictation_call_hint
                            .tr(),
                        maxTextBytes: _maxPreparationBytes,
                        maxDuration: const Duration(minutes: 3),
                        onTranscriptApplied: _onTextChanged,
                      ),
                      const Gap(12),
                      OutlinedButton.icon(
                        key: const Key('preparation_import_button'),
                        onPressed: _pickMarkdownFile,
                        icon: const Icon(Icons.file_open_outlined, size: 18),
                        label: Text(LocaleKeys.preparation_import.tr()),
                      ),
                      if (_fileName?.trim().isNotEmpty == true) ...<Widget>[
                        const Gap(8),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.description_outlined,
                              size: 15,
                              color: colors.primary,
                            ),
                            const Gap(7),
                            Expanded(
                              child: Text(
                                _fileName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: colors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Gap(14),
                      TextField(
                        key: const Key('preparation_markdown_field'),
                        controller: _controller,
                        minLines: 9,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) => _onTextChanged(),
                        decoration: InputDecoration(
                          hintText: LocaleKeys.preparation_placeholder.tr(),
                          errorText: _error,
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: colors.surfaceContainerHighest.withValues(
                            alpha: 0.36,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: colors.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: colors.outlineVariant.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              LocaleKeys.preparation_data_notice.tr(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                            ),
                          ),
                          const Gap(16),
                          Text(
                            LocaleKeys.preparation_size.tr(
                              args: <String>[
                                (byteCount / 1024).toStringAsFixed(1),
                              ],
                            ),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: byteCount > _maxPreparationBytes
                                      ? colors.error
                                      : colors.onSurfaceVariant,
                                  fontFeatures: const <FontFeature>[
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: 0.55),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final Widget removeAction = TextButton.icon(
                            key: const Key('preparation_remove_button'),
                            onPressed: _remove,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text(LocaleKeys.preparation_remove.tr()),
                          );
                          final Widget cancelAction = TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(LocaleKeys.common_cancel.tr()),
                          );
                          final Widget saveAction = FilledButton(
                            key: const Key('preparation_save_button'),
                            onPressed: _save,
                            child: Text(LocaleKeys.preparation_save.tr()),
                          );
                          if (constraints.maxWidth < 520) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (hasContent) ...<Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: removeAction,
                                  ),
                                  const Gap(8),
                                ],
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    cancelAction,
                                    const Gap(8),
                                    Flexible(child: saveAction),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Row(
                            children: <Widget>[
                              if (hasContent) removeAction,
                              const Spacer(),
                              cancelAction,
                              const Gap(8),
                              saveAction,
                            ],
                          );
                        },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    final String? validationError = _validationError(_controller.text);
    setState(() {
      _fileName = null;
      _error = validationError;
    });
  }

  Future<void> _pickMarkdownFile() async {
    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: const <XTypeGroup>[
          XTypeGroup(
            label: 'Markdown',
            extensions: <String>['md', 'markdown', 'txt'],
            mimeTypes: <String>['text/markdown', 'text/plain'],
            uniformTypeIdentifiers: <String>[
              'net.daringfireball.markdown',
              'public.plain-text',
            ],
          ),
        ],
      );
      if (file == null || !mounted) {
        return;
      }
      if (await file.length() > _maxPreparationBytes) {
        setState(() => _error = LocaleKeys.preparation_too_large.tr());
        return;
      }
      final String markdown = utf8.decode(
        await file.readAsBytes(),
        allowMalformed: false,
      );
      final String? validationError = _validationError(markdown);
      if (!mounted) {
        return;
      }
      if (validationError != null) {
        setState(() => _error = validationError);
        return;
      }
      _controller.value = TextEditingValue(
        text: markdown,
        selection: TextSelection.collapsed(offset: markdown.length),
      );
      setState(() {
        _fileName = file.name;
        _error = null;
      });
    } on FormatException {
      if (mounted) {
        setState(() => _error = LocaleKeys.preparation_invalid_file.tr());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = LocaleKeys.preparation_file_error.tr());
      }
    }
  }

  void _save() {
    final String markdown = _controller.text.trim();
    final String? validationError = _validationError(markdown);
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    Navigator.of(context).pop(
      _PreparationResult(
        markdown: markdown.isEmpty ? null : markdown,
        fileName: markdown.isEmpty ? null : _fileName,
      ),
    );
  }

  void _remove() {
    Navigator.of(
      context,
    ).pop(const _PreparationResult(markdown: null, fileName: null));
  }

  String? _validationError(String markdown) {
    if (utf8.encode(markdown).length > _maxPreparationBytes) {
      return LocaleKeys.preparation_too_large.tr();
    }
    final bool containsUnsupportedControl = markdown.runes.any(
      (int rune) => rune < 32 && rune != 9 && rune != 10 && rune != 13,
    );
    if (containsUnsupportedControl) {
      return LocaleKeys.preparation_invalid_file.tr();
    }
    return null;
  }
}

String _preparationSummary(String markdown) {
  for (final String rawLine in const LineSplitter().convert(markdown)) {
    final String line = rawLine
        .trim()
        .replaceFirst(RegExp(r'^#{1,6}\s*'), '')
        .replaceFirst(RegExp(r'^[-*+]\s+'), '');
    if (line.isNotEmpty) {
      return line;
    }
  }
  return LocaleKeys.dialer_preparation_edit.tr();
}

final class _SelectedContactContext extends StatelessWidget {
  const _SelectedContactContext({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final String name = <String>[
      if (contact.firstName?.trim().isNotEmpty == true)
        contact.firstName!.trim(),
      if (contact.lastName?.trim().isNotEmpty == true) contact.lastName!.trim(),
    ].join(' ');
    final String company = contact.company?.trim() ?? '';
    final String label = <String>[
      if (name.isNotEmpty) name,
      if (company.isNotEmpty) company,
    ].join(' · ');
    if (label.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: <Widget>[
        Icon(
          Icons.person_outline_rounded,
          size: 15,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

final class _DialPad extends StatelessWidget {
  const _DialPad({
    required this.disabled,
    required this.compact,
    required this.onKeyPressed,
    required this.onPlusPressed,
  });

  final bool disabled;
  final bool compact;
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onPlusPressed;

  static const List<_DialKey> _keys = <_DialKey>[
    _DialKey(value: '1'),
    _DialKey(value: '2', letters: 'ABC'),
    _DialKey(value: '3', letters: 'DEF'),
    _DialKey(value: '4', letters: 'GHI'),
    _DialKey(value: '5', letters: 'JKL'),
    _DialKey(value: '6', letters: 'MNO'),
    _DialKey(value: '7', letters: 'PQRS'),
    _DialKey(value: '8', letters: 'TUV'),
    _DialKey(value: '9', letters: 'WXYZ'),
    _DialKey(value: '*'),
    _DialKey(value: '0', letters: '+'),
    _DialKey(value: '#'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.sizeOf(context).width < 720;
    final double idealKeySize = compact ? 44 : (mobile ? 52 : 48);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double spacing = 8;
        final double idealWidth = idealKeySize * 3 + spacing * 2;
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : idealWidth;
        final double keySize = ((availableWidth - spacing * 2) / 3)
            .clamp(44.0, idealKeySize)
            .toDouble();
        return SizedBox(
          key: const Key('dialer_keypad'),
          width: keySize * 3 + spacing * 2,
          child: Wrap(
            spacing: spacing,
            runSpacing: 8,
            children: _keys
                .map<Widget>(
                  (_DialKey key) => _DialKeyButton(
                    entry: key,
                    size: keySize,
                    disabled: disabled,
                    onPressed: () => onKeyPressed(key.value),
                    onLongPress: key.value == '0' ? onPlusPressed : null,
                  ),
                )
                .toList(growable: false),
          ),
        );
      },
    );
  }
}

final class _DialKeyButton extends StatelessWidget {
  const _DialKeyButton({
    required this.entry,
    required this.size,
    required this.disabled,
    required this.onPressed,
    required this.onLongPress,
  });

  final _DialKey entry;
  final double size;
  final bool disabled;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: entry.value,
      hint: entry.value == '0' ? 'Maintenir pour le signe plus' : null,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkResponse(
          mouseCursor: disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onTap: disabled ? null : onPressed,
          onLongPress: disabled ? null : onLongPress,
          containedInkWell: true,
          highlightShape: BoxShape.circle,
          radius: size / 2,
          hoverColor: colors.onSurface.withValues(alpha: 0.045),
          focusColor: colors.primary.withValues(alpha: 0.09),
          child: SizedBox(
            width: size,
            height: size,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  entry.value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                ),
                if (entry.letters.isNotEmpty)
                  Text(
                    entry.letters,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: 9,
                      letterSpacing: 0.7,
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

final class _DialKey {
  const _DialKey({required this.value, this.letters = ''});

  final String value;
  final String letters;
}

final class _IncomingCallPanel extends StatelessWidget {
  const _IncomingCallPanel({
    required this.call,
    required this.disabled,
    required this.onAnswer,
    required this.onDecline,
  });

  final CallStateEntity call;
  final bool disabled;
  final Future<void> Function() onAnswer;
  final Future<void> Function() onDecline;

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    final String caller = call.remoteName?.trim().isNotEmpty == true
        ? call.remoteName!
        : call.remoteNumber?.trim().isNotEmpty == true
        ? call.remoteNumber!
        : LocaleKeys.incoming_unknown.tr();
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(tokens.panelRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLarge),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: tokens.spaceLarge,
            runSpacing: tokens.spaceMedium,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.incoming_title.tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Gap(tokens.spaceSmall),
                  Text(
                    caller,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: disabled ? null : onDecline,
                    icon: const Icon(Icons.call_end_outlined),
                    label: Text(LocaleKeys.incoming_decline.tr()),
                  ),
                  Gap(tokens.spaceSmall),
                  FilledButton.icon(
                    onPressed: disabled ? null : onAnswer,
                    icon: const Icon(Icons.phone_outlined),
                    label: Text(LocaleKeys.incoming_answer.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final PinkallThemeTokens tokens =
        Theme.of(context).extension<PinkallThemeTokens>() ??
        PinkallThemeTokens.light;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(tokens.controlRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            Gap(tokens.spaceSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.error_title.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Gap(tokens.spaceExtraSmall),
                  Text(_presentableFailureMessage(context, message)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return LocaleKeys.validation_required.tr();
  }
  return null;
}

String? _phoneValidator(String? value) {
  final String? requiredError = _requiredValidator(value);
  if (requiredError != null) {
    return requiredError;
  }
  if (!isValidDialerPhoneNumber(value!)) {
    return LocaleKeys.validation_phone.tr();
  }
  return null;
}

String _connectionLabel(TelnyxConnectionStatus status) {
  return switch (status) {
    TelnyxConnectionStatus.disconnected =>
      LocaleKeys.telnyx_status_disconnected,
    TelnyxConnectionStatus.connecting => LocaleKeys.telnyx_status_connecting,
    TelnyxConnectionStatus.connected => LocaleKeys.telnyx_status_connecting,
    TelnyxConnectionStatus.reconnecting =>
      LocaleKeys.telnyx_status_reconnecting,
    TelnyxConnectionStatus.ready => LocaleKeys.telnyx_status_ready,
    TelnyxConnectionStatus.failure => LocaleKeys.telnyx_status_failure,
  };
}

String _localizedCopy(
  BuildContext context, {
  required String french,
  required String english,
}) => Localizations.localeOf(context).languageCode == 'fr' ? french : english;

String _presentableFailureMessage(BuildContext context, String message) {
  final String normalized = message.toLowerCase();
  const List<String> infrastructureTerms = <String>[
    'api',
    'backend',
    'credential',
    'http',
    'jwt',
    'sip',
    'socket',
    'telnyx',
    'token',
    'webrtc',
    'websocket',
  ];
  if (!infrastructureTerms.any(normalized.contains)) {
    return message;
  }
  return _localizedCopy(
    context,
    french: "L'action n'a pas pu aboutir. Vérifie ta connexion, puis réessaie.",
    english:
        'The action could not be completed. Check your connection and '
        'try again.',
  );
}
