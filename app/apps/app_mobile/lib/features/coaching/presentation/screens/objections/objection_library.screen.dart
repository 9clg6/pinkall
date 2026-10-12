import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/features/coaching/presentation/screens/objections/objection_library.state.dart';
import 'package:pinkall/features/coaching/presentation/screens/objections/objection_library.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_error_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_loading_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';

const Map<String, String> _categoryLabels = <String, String>{
  'price': 'Prix',
  'timing': 'Timing',
  'need': 'Besoin',
  'authority': 'Décision',
  'trust': 'Confiance',
  'competition': 'Concurrence',
  'implementation': 'Mise en place',
  'security': 'Sécurité',
  'compliance': 'Conformité',
  'other': 'Autre',
};

/// Reviewable objection library and custom answer editor.
@RoutePage()
final class ObjectionLibraryScreen extends ConsumerWidget {
  /// Creates the objection library screen.
  const ObjectionLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ObjectionLibraryState> state = ref.watch(
      objectionLibraryViewModelProvider,
    );
    return Scaffold(
      body: PinkallPageFrame(
        accessory: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton.icon(
              key: const Key('objection_library_back_button'),
              onPressed: () => context.router.maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Appeler'),
            ),
            const Gap(8),
            FilledButton.icon(
              key: const Key('add_custom_objection_button'),
              onPressed: state.value?.isSaving == true
                  ? null
                  : () => _openCreator(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        child: state.when(
          loading: () => const PinkallLoadingView(),
          error: (Object error, StackTrace stackTrace) => PinkallErrorView(
            onRetry: () => ref.invalidate(objectionLibraryViewModelProvider),
          ),
          data: (ObjectionLibraryState value) => _ObjectionLibraryContent(
            entries: value.entries,
            isSaving: value.isSaving,
            onAdd: () => _openCreator(context, ref),
          ),
        ),
      ),
    );
  }

  Future<void> _openCreator(BuildContext context, WidgetRef ref) async {
    final _CustomObjectionDraft? draft =
        await showDialog<_CustomObjectionDraft>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const _CustomObjectionDialog(),
        );
    if (draft == null || !context.mounted) {
      return;
    }
    final bool saved = await ref
        .read(objectionLibraryViewModelProvider.notifier)
        .addCustom(
          CreateCustomObjectionParam(
            category: draft.category,
            text: draft.text,
            responseContent: draft.responseContent,
            responseSourceType: draft.sourceName == null ? 'text' : 'file',
            responseSourceName: draft.sourceName,
          ),
        );
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'La réponse est prête pour les prochains appels.'
              : 'La réponse n’a pas pu être enregistrée.',
        ),
      ),
    );
  }
}

final class _ObjectionLibraryContent extends StatelessWidget {
  const _ObjectionLibraryContent({
    required this.entries,
    required this.isSaving,
    required this.onAdd,
  });

  final List<ObjectionKnowledgeEntryEntity> entries;
  final bool isSaving;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 760;
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                compact ? 20 : 44,
                compact ? 28 : 52,
                compact ? 20 : 44,
                20,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: _LibraryHeader(
                      entryCount: entries.length,
                      customCount: entries
                          .where(
                            (ObjectionKnowledgeEntryEntity entry) =>
                                entry.responseContent != null,
                          )
                          .length,
                    ),
                  ),
                ),
              ),
            ),
            if (entries.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyLibrary(onAdd: onAdd),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 20 : 44,
                  16,
                  compact ? 20 : 44,
                  48,
                ),
                sliver: SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                        final int columns = constraints.crossAxisExtent >= 920
                            ? 2
                            : 1;
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                mainAxisExtent: 242,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) =>
                                _ObjectionCard(entry: entries[index]),
                            childCount: entries.length,
                          ),
                        );
                      },
                ),
              ),
            if (isSaving)
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        );
      },
    );
  }
}

final class _LibraryHeader extends StatelessWidget {
  const _LibraryHeader({required this.entryCount, required this.customCount});

  final int entryCount;
  final int customCount;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Wrap(
      spacing: 24,
      runSpacing: 20,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 690),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'BIBLIOTHÈQUE DE RÉPONSES',
                style: textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: PinkallColors.pinkDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(12),
              Text(
                'Prépare Pinkall aux objections qui comptent.',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.1,
                ),
              ),
              const Gap(10),
              Text(
                'Retrouve les objections détectées pendant tes appels. '
                'Ajoute ta propre réponse ou un playbook : Pinkall pourra la '
                'proposer lorsqu’une objection similaire revient.',
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        _LibraryMetric(entryCount: entryCount, customCount: customCount),
      ],
    );
  }
}

final class _LibraryMetric extends StatelessWidget {
  const _LibraryMetric({required this.entryCount, required this.customCount});

  final int entryCount;
  final int customCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.78),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _MetricValue(value: '$entryCount', label: 'objections'),
            const SizedBox(height: 32, child: VerticalDivider(width: 28)),
            _MetricValue(value: '$customCount', label: 'réponses prêtes'),
          ],
        ),
      ),
    );
  }
}

final class _MetricValue extends StatelessWidget {
  const _MetricValue({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

final class _ObjectionCard extends StatelessWidget {
  const _ObjectionCard({required this.entry});

  final ObjectionKnowledgeEntryEntity entry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool ready = entry.responseContent != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.82),
        border: Border.all(
          color: ready
              ? PinkallColors.pink.withValues(alpha: 0.24)
              : colors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _Pill(label: _categoryLabels[entry.category] ?? 'Autre'),
                const Gap(8),
                _Pill(
                  label: ready ? 'Réponse prête' : 'À enrichir',
                  emphasized: ready,
                ),
                const Spacer(),
                if (entry.occurrenceCount > 0)
                  Text(
                    '${entry.occurrenceCount}× entendue',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const Gap(16),
            Text(
              entry.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const Gap(14),
            Divider(color: colors.outlineVariant),
            const Gap(10),
            Text(
              ready ? 'RÉPONSE À APPORTER' : 'AUCUNE RÉPONSE PERSONNALISÉE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                color: ready ? PinkallColors.pinkDark : colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(8),
            Expanded(
              child: Text(
                entry.responseContent ??
                    'Ajoute ton angle, ton script ou un document de référence.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
            if (entry.responseSourceName != null)
              Row(
                children: <Widget>[
                  const Icon(Icons.description_outlined, size: 15),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      entry.responseSourceName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

final class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.emphasized = false});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: emphasized
            ? PinkallColors.pinkWash
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: emphasized ? PinkallColors.pinkDark : null,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

final class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.forum_outlined, size: 36),
              const Gap(18),
              Text(
                'Ta bibliothèque commence ici.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(10),
              Text(
                'Ajoute une objection fréquente et la réponse que tu veux voir '
                'pendant tes appels.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(22),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Ajouter une objection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _CustomObjectionDialog extends StatefulWidget {
  const _CustomObjectionDialog();

  @override
  State<_CustomObjectionDialog> createState() => _CustomObjectionDialogState();
}

final class _CustomObjectionDialogState extends State<_CustomObjectionDialog> {
  static const int _maxResponseBytes = 32 * 1024;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _objectionController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  String _category = 'price';
  String? _sourceName;
  String? _fileError;

  @override
  void dispose() {
    _objectionController.dispose();
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Ajouter une réponse personnalisée',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  'Pinkall utilisera cette réponse uniquement lorsqu’une '
                  'objection similaire est réellement entendue.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(24),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                  items: _categoryLabels.entries
                      .map(
                        (MapEntry<String, String> item) =>
                            DropdownMenuItem<String>(
                              value: item.key,
                              child: Text(item.value),
                            ),
                      )
                      .toList(growable: false),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
                const Gap(16),
                TextFormField(
                  key: const Key('custom_objection_text_field'),
                  controller: _objectionController,
                  maxLength: 1000,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Objection',
                    hintText: 'Ex. Votre solution est trop chère.',
                    alignLabelWithHint: true,
                  ),
                  validator: (String? value) =>
                      value == null || value.trim().length < 3
                      ? 'Décris l’objection en quelques mots.'
                      : null,
                ),
                const Gap(8),
                TextFormField(
                  key: const Key('custom_objection_response_field'),
                  controller: _responseController,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Réponse à apporter',
                    hintText:
                        'Écris le conseil, la formulation ou le playbook que '
                        'Pinkall doit afficher.',
                    alignLabelWithHint: true,
                    suffixIcon: _sourceName == null
                        ? null
                        : IconButton(
                            tooltip: 'Retirer le fichier',
                            onPressed: () => setState(() {
                              _sourceName = null;
                              _responseController.clear();
                            }),
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ajoute une réponse ou importe un fichier.';
                    }
                    if (utf8.encode(value).length > _maxResponseBytes) {
                      return 'La réponse doit faire moins de 32 Ko.';
                    }
                    return null;
                  },
                ),
                const Gap(12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    OutlinedButton.icon(
                      key: const Key('custom_objection_import_button'),
                      onPressed: _pickResponseFile,
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text('Importer .md ou .txt'),
                    ),
                    if (_sourceName != null)
                      Text(
                        _sourceName!,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                  ],
                ),
                if (_fileError != null) ...<Widget>[
                  const Gap(8),
                  Text(
                    _fileError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const Gap(26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                    const Gap(8),
                    FilledButton(
                      key: const Key('custom_objection_save_button'),
                      onPressed: _submit,
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickResponseFile() async {
    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: const <XTypeGroup>[
          XTypeGroup(
            label: 'Documents texte',
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
      if (await file.length() > _maxResponseBytes) {
        setState(() => _fileError = 'Le fichier doit faire moins de 32 Ko.');
        return;
      }
      final String content = utf8.decode(
        await file.readAsBytes(),
        allowMalformed: false,
      );
      if (!mounted) {
        return;
      }
      _responseController.value = TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(offset: content.length),
      );
      setState(() {
        _sourceName = file.name;
        _fileError = null;
      });
    } on FormatException {
      if (mounted) {
        setState(() => _fileError = 'Le fichier doit être en UTF-8.');
      }
    } on Object {
      if (mounted) {
        setState(() => _fileError = 'Le fichier n’a pas pu être ouvert.');
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(
      _CustomObjectionDraft(
        category: _category,
        text: _objectionController.text.trim(),
        responseContent: _responseController.text.trim(),
        sourceName: _sourceName,
      ),
    );
  }
}

final class _CustomObjectionDraft {
  const _CustomObjectionDraft({
    required this.category,
    required this.text,
    required this.responseContent,
    required this.sourceName,
  });

  final String category;
  final String text;
  final String responseContent;
  final String? sourceName;
}
