import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.state.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_error_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_loading_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/voice_briefing_dictation.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

const int _maxWorkspacePitchBytes = 16 * 1024;

/// First-run and editing screen for Pinkall's permanent product context.
@RoutePage()
final class WorkspaceSalesContextScreen extends ConsumerStatefulWidget {
  /// Creates the workspace context screen.
  const WorkspaceSalesContextScreen({
    this.editing = false,
    @QueryParam('number') this.initialPhoneNumber,
    this.deepLinkRequestId,
    super.key,
  });

  /// Whether the screen was opened from the phone as an editor.
  final bool editing;

  /// Number to prefill after the mandatory first-run context is complete.
  final String? initialPhoneNumber;

  /// Deep-link event identifier forwarded after onboarding completes.
  final int? deepLinkRequestId;

  @override
  ConsumerState<WorkspaceSalesContextScreen> createState() =>
      _WorkspaceSalesContextScreenState();
}

final class _WorkspaceSalesContextScreenState
    extends ConsumerState<WorkspaceSalesContextScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _pitchController = TextEditingController();
  bool _didHydrate = false;
  bool _redirectScheduled = false;
  String? _fileFailure;

  @override
  void dispose() {
    _companyController.dispose();
    _productController.dispose();
    _pitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<WorkspaceSalesContextState> asyncState = ref.watch(
      workspaceSalesContextViewModelProvider,
    );
    return Scaffold(
      body: PinkallPageFrame(
        child: asyncState.when(
          loading: () => const PinkallLoadingView(),
          error: (Object error, StackTrace stackTrace) => PinkallErrorView(
            onRetry: () =>
                ref.invalidate(workspaceSalesContextViewModelProvider),
          ),
          data: (WorkspaceSalesContextState state) {
            _hydrate(state.context);
            if (!widget.editing && state.context != null) {
              _scheduleHomeRedirect();
              return const PinkallLoadingView();
            }
            return _buildForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, WorkspaceSalesContextState state) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final int pitchBytes = utf8.encode(_pitchController.text).length;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LocaleKeys.workspace_context_eyebrow.tr(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  LocaleKeys.workspace_context_title.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  LocaleKeys.workspace_context_body.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    children: <Widget>[
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              final Widget companyField = TextFormField(
                                key: const Key('workspace_company_field'),
                                controller: _companyController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys
                                      .workspace_context_company
                                      .tr(),
                                ),
                                validator: _requiredValidator,
                              );
                              final Widget productField = TextFormField(
                                key: const Key('workspace_product_field'),
                                controller: _productController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: LocaleKeys
                                      .workspace_context_product
                                      .tr(),
                                ),
                                validator: _requiredValidator,
                              );
                              if (constraints.maxWidth < 560) {
                                return Column(
                                  children: <Widget>[
                                    companyField,
                                    const SizedBox(height: 14),
                                    productField,
                                  ],
                                );
                              }
                              return Row(
                                children: <Widget>[
                                  Expanded(child: companyField),
                                  const SizedBox(width: 14),
                                  Expanded(child: productField),
                                ],
                              );
                            },
                      ),
                      const SizedBox(height: 18),
                      VoiceBriefingDictation(
                        controller: _pitchController,
                        idleTitle: LocaleKeys.voice_dictation_project_title
                            .tr(),
                        idleDescription: LocaleKeys.voice_dictation_project_hint
                            .tr(),
                        maxTextBytes: _maxWorkspacePitchBytes,
                        enabled: !state.isSaving,
                        onTranscriptApplied: () =>
                            setState(() => _fileFailure = null),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('workspace_pitch_field'),
                        controller: _pitchController,
                        minLines: 10,
                        maxLines: 18,
                        onChanged: (_) => setState(() => _fileFailure = null),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: LocaleKeys.workspace_context_pitch.tr(),
                          hintText: LocaleKeys.workspace_context_pitch_hint
                              .tr(),
                        ),
                        validator: (String? value) {
                          final String? requiredFailure = _requiredValidator(
                            value,
                          );
                          if (requiredFailure != null) {
                            return requiredFailure;
                          }
                          return utf8.encode(value!.trim()).length >
                                  _maxWorkspacePitchBytes
                              ? LocaleKeys.workspace_context_too_large.tr()
                              : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              final Widget importAction = TextButton.icon(
                                key: const Key('workspace_pitch_import_button'),
                                onPressed: state.isSaving
                                    ? null
                                    : _importMarkdown,
                                icon: const Icon(Icons.upload_file_outlined),
                                label: Text(
                                  LocaleKeys.workspace_context_import.tr(),
                                ),
                              );
                              final Widget sizeLabel = Text(
                                LocaleKeys.workspace_context_size.tr(
                                  args: <String>[pitchBytes.toString()],
                                ),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color:
                                          pitchBytes > _maxWorkspacePitchBytes
                                          ? colors.error
                                          : colors.onSurfaceVariant,
                                    ),
                              );
                              if (constraints.maxWidth < 520) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: importAction,
                                    ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: sizeLabel,
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: <Widget>[
                                  importAction,
                                  const Spacer(),
                                  sizeLabel,
                                ],
                              );
                            },
                      ),
                      if (_fileFailure != null ||
                          state.operationFailure != null) ...<Widget>[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _fileFailure ??
                                LocaleKeys.workspace_context_save_error.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.error),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    key: const Key('workspace_context_save_button'),
                    onPressed: state.isSaving ? null : () => _save(state),
                    icon: state.isSaving
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      widget.editing
                          ? LocaleKeys.workspace_context_update.tr()
                          : LocaleKeys.workspace_context_save.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hydrate(WorkspaceSalesContextEntity? context) {
    if (_didHydrate) {
      return;
    }
    _didHydrate = true;
    _companyController.text = context?.companyName ?? '';
    _productController.text = context?.productName ?? '';
    _pitchController.text = context?.pitchMarkdown ?? '';
  }

  void _scheduleHomeRedirect() {
    if (_redirectScheduled) {
      return;
    }
    _redirectScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.router.replace(
          CallHomeRoute(
            initialPhoneNumber: widget.initialPhoneNumber,
            deepLinkRequestId: widget.deepLinkRequestId,
          ),
        );
      }
    });
  }

  Future<void> _importMarkdown() async {
    try {
      const XTypeGroup markdown = XTypeGroup(
        label: 'Markdown',
        extensions: <String>['md', 'markdown', 'txt'],
      );
      final XFile? file = await openFile(
        acceptedTypeGroups: const <XTypeGroup>[markdown],
      );
      if (file == null) {
        return;
      }
      final String content = utf8.decode(await file.readAsBytes()).trim();
      if (utf8.encode(content).length > _maxWorkspacePitchBytes) {
        setState(
          () => _fileFailure = LocaleKeys.workspace_context_too_large.tr(),
        );
        return;
      }
      setState(() {
        _pitchController.text = content;
        _fileFailure = null;
      });
    } on Object {
      setState(
        () => _fileFailure = LocaleKeys.workspace_context_file_error.tr(),
      );
    }
  }

  Future<void> _save(WorkspaceSalesContextState state) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final bool saved = await ref
        .read(workspaceSalesContextViewModelProvider.notifier)
        .save(
          companyName: _companyController.text,
          productName: _productController.text,
          pitchMarkdown: _pitchController.text,
        );
    if (!saved || !mounted) {
      return;
    }
    if (widget.editing && context.router.canPop()) {
      await context.router.maybePop();
    } else {
      await context.router.replace(
        CallHomeRoute(
          initialPhoneNumber: widget.initialPhoneNumber,
          deepLinkRequestId: widget.deepLinkRequestId,
        ),
      );
    }
  }

  String? _requiredValidator(String? value) {
    return value?.trim().isNotEmpty == true
        ? null
        : LocaleKeys.validation_required.tr();
  }
}
