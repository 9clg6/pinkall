import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/features/auth/domain/pinkall_auth.exception.dart';
import 'package:pinkall/features/auth/presentation/pinkall_auth.state.dart';
import 'package:pinkall/features/auth/presentation/pinkall_auth.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Invite-only authentication gate around the application router.
final class PinkallAuthGate extends ConsumerWidget {
  /// Creates the gate around the already-built router child.
  const PinkallAuthGate({required this.authenticatedChild, super.key});

  /// Router content shown only after a restored or newly created session.
  final Widget authenticatedChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PinkallAuthState state = ref.watch(pinkallAuthViewModelProvider);
    if (state.session == null) {
      return _AuthenticationSurface(state: state);
    }
    if (!state.canSignOut) {
      return authenticatedChild;
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        authenticatedChild,
        Positioned(
          right: 18,
          bottom: 18,
          child: SafeArea(
            minimum: const EdgeInsets.all(4),
            child: _AccountControl(state: state),
          ),
        ),
      ],
    );
  }
}

final class _AuthenticationSurface extends StatelessWidget {
  const _AuthenticationSurface({required this.state});

  final PinkallAuthState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('pinkall_auth_gate'),
      body: PinkallPageFrame(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: state.isAvailable
                  ? _SignInCard(state: state)
                  : const _UnavailableCard(),
            ),
          ),
        ),
      ),
    );
  }
}

final class _SignInCard extends ConsumerStatefulWidget {
  const _SignInCard({required this.state});

  final PinkallAuthState state;

  @override
  ConsumerState<_SignInCard> createState() => _SignInCardState();
}

final class _SignInCardState extends ConsumerState<_SignInCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      key: const Key('pinkall_sign_in_card'),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: PinkallColors.shadow.withValues(alpha: 0.08),
            blurRadius: 44,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: PinkallMark(size: 38),
              ),
              const SizedBox(height: 28),
              Text(
                LocaleKeys.auth_title.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.auth_body.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                key: const Key('pinkall_auth_email'),
                controller: _emailController,
                enabled: !widget.state.isSubmitting,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const <String>[
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: LocaleKeys.auth_email.tr(),
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('pinkall_auth_password'),
                controller: _passwordController,
                enabled: !widget.state.isSubmitting,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[AutofillHints.password],
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: LocaleKeys.auth_password.tr(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    key: const Key('pinkall_auth_password_visibility'),
                    tooltip: _obscurePassword
                        ? LocaleKeys.auth_password_show.tr()
                        : LocaleKeys.auth_password_hide.tr(),
                    onPressed: widget.state.isSubmitting
                        ? null
                        : () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (String? value) => value == null || value.isEmpty
                    ? LocaleKeys.validation_required.tr()
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (widget.state.failureCode != null) ...<Widget>[
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _failureMessage(widget.state.failureCode!).tr(),
                    key: const Key('pinkall_auth_error'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(
                key: const Key('pinkall_auth_submit'),
                onPressed: widget.state.isSubmitting ? null : _submit,
                child: widget.state.isSubmitting
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : Text(LocaleKeys.auth_submit.tr()),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.auth_invite_only.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? rawValue) {
    final String value = rawValue?.trim() ?? '';
    if (value.isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return LocaleKeys.auth_email_invalid.tr();
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final bool signedIn = await ref
        .read(pinkallAuthViewModelProvider.notifier)
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
    _passwordController.clear();
    if (signedIn && mounted) {
      TextInput.finishAutofillContext();
    }
  }
}

final class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      key: const Key('pinkall_auth_unavailable'),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const PinkallMark(size: 38),
          const SizedBox(height: 24),
          Text(
            LocaleKeys.auth_unavailable_title.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.auth_unavailable_body.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

final class _AccountControl extends ConsumerWidget {
  const _AccountControl({required this.state});

  final PinkallAuthState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface.withValues(alpha: 0.94),
      elevation: 4,
      shadowColor: PinkallColors.shadow.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.only(left: 14, right: 4, top: 4, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if ((state.session?.email ?? '').isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  state.session!.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            Semantics(
              button: true,
              label: LocaleKeys.auth_logout.tr(),
              child: IconButton(
                key: const Key('pinkall_auth_logout'),
                tooltip: LocaleKeys.auth_logout.tr(),
                onPressed: state.isSubmitting
                    ? null
                    : () => ref
                          .read(pinkallAuthViewModelProvider.notifier)
                          .signOut(),
                icon: const Icon(Icons.logout_rounded, size: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _failureMessage(PinkallAuthFailureCode code) => switch (code) {
  PinkallAuthFailureCode.invalidCredentials =>
    LocaleKeys.auth_error_invalid_credentials,
  PinkallAuthFailureCode.networkUnavailable => LocaleKeys.auth_error_network,
  PinkallAuthFailureCode.unavailable => LocaleKeys.auth_error_unavailable,
  PinkallAuthFailureCode.unknown => LocaleKeys.auth_error_unknown,
};
