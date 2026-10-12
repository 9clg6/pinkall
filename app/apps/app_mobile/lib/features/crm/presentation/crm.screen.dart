import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/features/crm/presentation/crm.state.dart';
import 'package:pinkall/features/crm/presentation/crm.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';

/// Backend-backed contact directory that can be embedded beside the dialer.
///
/// The pane deliberately reuses the CRM provider and its real create/import
/// mutations. It never invents contacts when the backend is empty.
final class CrmContactDirectoryPane extends ConsumerStatefulWidget {
  /// Creates an embeddable contacts directory.
  const CrmContactDirectoryPane({
    required this.onContactSelected,
    this.compact = false,
    super.key,
  });

  /// Selects a backend contact, for example to fill the unified dialer.
  final ValueChanged<ContactEntity> onContactSelected;

  /// Uses the denser mobile header and row affordances.
  final bool compact;

  @override
  ConsumerState<CrmContactDirectoryPane> createState() =>
      _CrmContactDirectoryPaneState();
}

final class _CrmContactDirectoryPaneState
    extends ConsumerState<CrmContactDirectoryPane> {
  String? _selectedContactId;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CrmState> asyncState = ref.watch(crmViewModelProvider);
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: asyncState.when(
        loading: () => const _CrmLoading(),
        error: (Object error, StackTrace stackTrace) => _CrmInitialError(
          onRetry: () => ref.invalidate(crmViewModelProvider),
        ),
        data: (CrmState state) {
          final List<ContactEntity> contacts = _filterContacts(
            state.contacts,
            _query,
          );
          return _ContactDirectory(
            state: state,
            contacts: contacts,
            totalCount: state.contacts.length,
            query: _query,
            desktop: !widget.compact,
            selectedContactId: _selectedContactId,
            onQueryChanged: (String value) => setState(() => _query = value),
            onSelected: (ContactEntity contact) {
              setState(() => _selectedContactId = contact.id);
              widget.onContactSelected(contact);
            },
            onRefresh: () => ref.read(crmViewModelProvider.notifier).refresh(),
            onCreate: () => _showCreateDialog(context, ref),
            onImport: () => _showImportDialog(context, ref),
          );
        },
      ),
    );
  }
}

/// Pinkall contacts and prospect context workspace.
@RoutePage()
final class CrmScreen extends ConsumerStatefulWidget {
  /// Creates the CRM screen.
  const CrmScreen({super.key});

  @override
  ConsumerState<CrmScreen> createState() => _CrmScreenState();
}

enum _CrmMenuAction { refresh, import }

final class _CrmScreenState extends ConsumerState<CrmScreen> {
  String? _selectedContactId;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CrmState> asyncState = ref.watch(crmViewModelProvider);
    final VoidCallback createContact = () => _showCreateDialog(context, ref);
    final VoidCallback importContacts = () => _showImportDialog(context, ref);
    final Future<void> Function() refresh = () =>
        ref.read(crmViewModelProvider.notifier).refresh();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PinkallPageFrame(
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: asyncState.when(
            loading: () => const _CrmLoading(),
            error: (Object error, StackTrace stackTrace) => _CrmInitialError(
              onRetry: () => ref.invalidate(crmViewModelProvider),
            ),
            data: (CrmState state) => _CrmWorkspace(
              state: state,
              query: _query,
              selectedContactId: _selectedContactId,
              onQueryChanged: (String value) => setState(() => _query = value),
              onSelected: (ContactEntity contact) =>
                  setState(() => _selectedContactId = contact.id),
              onRefresh: refresh,
              onCreate: createContact,
              onImport: importContacts,
            ),
          ),
        ),
      ),
    );
  }
}

final class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 19),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

final class _DirectoryStatus extends StatelessWidget {
  const _DirectoryStatus({required this.state});

  final CrmState state;

  @override
  Widget build(BuildContext context) {
    final String? message = state.failure ?? state.feedback;
    final bool failure = state.failure != null;
    final Duration duration = _reduceMotion(context)
        ? Duration.zero
        : _tokens(context).durationFast;
    return AnimatedSize(
      duration: duration,
      alignment: Alignment.topLeft,
      child: message == null && !state.isOperating
          ? const SizedBox.shrink(key: ValueKey<String>('crm-idle'))
          : Semantics(
              key: ValueKey<String>(message ?? 'crm-progress'),
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: <Widget>[
                    if (state.isOperating)
                      const SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      )
                    else
                      Icon(
                        failure
                            ? Icons.error_outline_rounded
                            : Icons.check_rounded,
                        size: 15,
                        color: failure
                            ? PinkallColors.error
                            : PinkallColors.success,
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message ?? 'Mise à jour des contacts…',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: failure
                              ? PinkallColors.error
                              : PinkallColors.carbonSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

final class _CrmWorkspace extends StatelessWidget {
  const _CrmWorkspace({
    required this.state,
    required this.query,
    required this.selectedContactId,
    required this.onQueryChanged,
    required this.onSelected,
    required this.onRefresh,
    required this.onCreate,
    required this.onImport,
  });

  final CrmState state;
  final String query;
  final String? selectedContactId;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ContactEntity> onSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onCreate;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool desktop = constraints.maxWidth >= 920;
        final List<ContactEntity> contacts = _filterContacts(
          state.contacts,
          query,
        );
        final ContactEntity? selected = _selectedContact(
          contacts,
          selectedContactId,
        );
        final Widget directory = _ContactDirectory(
          state: state,
          contacts: contacts,
          totalCount: state.contacts.length,
          query: query,
          desktop: desktop,
          selectedContactId: desktop ? selected?.id : null,
          onQueryChanged: onQueryChanged,
          onSelected: desktop
              ? onSelected
              : (ContactEntity contact) =>
                    _showContactDetailSheet(context, contact),
          onRefresh: onRefresh,
          onCreate: onCreate,
          onImport: onImport,
        );

        if (!desktop) {
          return directory;
        }

        final double directoryWidth = constraints.maxWidth >= 1320 ? 340 : 312;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(width: directoryWidth, child: directory),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: _ProspectDetail(contact: selected)),
          ],
        );
      },
    );
  }
}

final class _ContactDirectory extends StatefulWidget {
  const _ContactDirectory({
    required this.state,
    required this.contacts,
    required this.totalCount,
    required this.query,
    required this.desktop,
    required this.selectedContactId,
    required this.onQueryChanged,
    required this.onSelected,
    required this.onRefresh,
    required this.onCreate,
    required this.onImport,
  });

  final CrmState state;
  final List<ContactEntity> contacts;
  final int totalCount;
  final String query;
  final bool desktop;
  final String? selectedContactId;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ContactEntity> onSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onCreate;
  final VoidCallback onImport;

  @override
  State<_ContactDirectory> createState() => _ContactDirectoryState();
}

final class _ContactDirectoryState extends State<_ContactDirectory> {
  final FocusNode _listFocusNode = FocusNode(debugLabel: 'crm-contact-list');

  @override
  void dispose() {
    _listFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PinkallColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _DirectoryHeader(
            state: widget.state,
            query: widget.query,
            visibleCount: widget.contacts.length,
            totalCount: widget.totalCount,
            compact: !widget.desktop,
            onChanged: widget.onQueryChanged,
            onCreate: widget.onCreate,
            onMenuAction: (_CrmMenuAction action) {
              switch (action) {
                case _CrmMenuAction.refresh:
                  widget.onRefresh();
                case _CrmMenuAction.import:
                  widget.onImport();
              }
            },
          ),
          Expanded(child: _buildDirectoryBody(context)),
        ],
      ),
    );
  }

  Widget _buildDirectoryBody(BuildContext context) {
    if (widget.totalCount == 0) {
      return _EmptyCrm(onCreate: widget.onCreate, onImport: widget.onImport);
    }
    if (widget.contacts.isEmpty) {
      return _NoSearchResults(query: widget.query);
    }

    return Focus(
      focusNode: _listFocusNode,
      onKeyEvent: _onKeyEvent,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.separated(
          key: PageStorageKey<String>(
            widget.desktop ? 'crm-desktop-directory' : 'crm-mobile-directory',
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 28),
          itemCount: widget.contacts.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 1, indent: 24, endIndent: 24),
          itemBuilder: (BuildContext context, int index) {
            final ContactEntity contact = widget.contacts[index];
            return _ContactRow(
              contact: contact,
              selected: contact.id == widget.selectedContactId,
              showChevron: !widget.desktop,
              onTap: () => widget.onSelected(contact),
            );
          },
        ),
      ),
    );
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || widget.contacts.isEmpty) {
      return KeyEventResult.ignored;
    }
    final int currentIndex = widget.contacts.indexWhere(
      (ContactEntity contact) => contact.id == widget.selectedContactId,
    );
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final int next = currentIndex < 0
          ? 0
          : (currentIndex + 1).clamp(0, widget.contacts.length - 1);
      widget.onSelected(widget.contacts[next]);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final int next = currentIndex < 0
          ? 0
          : (currentIndex - 1).clamp(0, widget.contacts.length - 1);
      widget.onSelected(widget.contacts[next]);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter && currentIndex >= 0) {
      widget.onSelected(widget.contacts[currentIndex]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

final class _DirectoryHeader extends StatelessWidget {
  const _DirectoryHeader({
    required this.state,
    required this.query,
    required this.visibleCount,
    required this.totalCount,
    required this.compact,
    required this.onChanged,
    required this.onCreate,
    required this.onMenuAction,
  });

  final CrmState state;
  final String query;
  final int visibleCount;
  final int totalCount;
  final bool compact;
  final ValueChanged<String> onChanged;
  final VoidCallback onCreate;
  final ValueChanged<_CrmMenuAction> onMenuAction;

  @override
  Widget build(BuildContext context) {
    final String count = query.trim().isEmpty
        ? totalCount == 1
              ? '1 prospect'
              : '$totalCount prospects'
        : '$visibleCount sur $totalCount';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 24,
        compact ? 16 : 24,
        compact ? 16 : 24,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Prospects',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.45,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      count,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PinkallColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (totalCount > 0) ...<Widget>[
                if (compact)
                  Tooltip(
                    message: 'Ajouter un contact',
                    child: IconButton.filled(
                      onPressed: state.isOperating ? null : onCreate,
                      style: IconButton.styleFrom(
                        backgroundColor: PinkallColors.carbon,
                        foregroundColor: PinkallColors.onStrong,
                        disabledBackgroundColor: PinkallColors.surfaceHigh,
                        minimumSize: const Size.square(44),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 19),
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: state.isOperating ? null : onCreate,
                    style: FilledButton.styleFrom(
                      backgroundColor: PinkallColors.carbon,
                      foregroundColor: PinkallColors.onStrong,
                      minimumSize: const Size(0, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 17),
                    label: const Text('Nouveau'),
                  ),
                const SizedBox(width: 4),
                PopupMenuButton<_CrmMenuAction>(
                  tooltip: 'Plus d’actions',
                  enabled: !state.isOperating,
                  icon: const Icon(Icons.more_horiz_rounded, size: 21),
                  onSelected: onMenuAction,
                  itemBuilder: (BuildContext context) =>
                      const <PopupMenuEntry<_CrmMenuAction>>[
                        PopupMenuItem<_CrmMenuAction>(
                          value: _CrmMenuAction.refresh,
                          child: _MenuItem(
                            icon: Icons.refresh_rounded,
                            label: 'Actualiser les contacts',
                          ),
                        ),
                        PopupMenuItem<_CrmMenuAction>(
                          value: _CrmMenuAction.import,
                          child: _MenuItem(
                            icon: Icons.file_upload_outlined,
                            label: 'Importer CSV ou JSON',
                          ),
                        ),
                      ],
                ),
              ],
            ],
          ),
          if (totalCount > 0) ...<Widget>[
            const SizedBox(height: 16),
            FocusTraversalOrder(
              order: const NumericFocusOrder(1),
              child: TextField(
                key: const Key('crm_search_field'),
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un nom, une entreprise ou un numéro',
                  hintMaxLines: 1,
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 32,
                    minHeight: 40,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: PinkallColors.outline),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PinkallColors.outline),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: PinkallColors.carbon,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
          _DirectoryStatus(state: state),
        ],
      ),
    );
  }
}

final class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.contact,
    required this.selected,
    required this.showChevron,
    required this.onTap,
  });

  final ContactEntity contact;
  final bool selected;
  final bool showChevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String name = _contactName(contact);
    final String title = name.isEmpty ? contact.phoneNumber : name;
    final List<String> contextLine = <String>[
      if (contact.company?.trim().isNotEmpty == true) contact.company!.trim(),
      if (contact.jobTitle?.trim().isNotEmpty == true) contact.jobTitle!.trim(),
    ];
    final bool showSecondaryLine = name.isNotEmpty || contextLine.isNotEmpty;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Ouvrir la fiche de $title',
      child: AnimatedContainer(
        duration: _reduceMotion(context)
            ? Duration.zero
            : _tokens(context).durationFast,
        color: selected
            ? PinkallColors.surface.withValues(alpha: 0.78)
            : Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            hoverColor: PinkallColors.surfaceLow,
            focusColor: PinkallColors.pinkWash,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 15, 14, 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 31,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _initials(contact),
                        style: textTheme.labelMedium?.copyWith(
                          color: selected
                              ? PinkallColors.pinkDark
                              : PinkallColors.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (showSecondaryLine) ...<Widget>[
                          const SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              if (contextLine.isNotEmpty) ...<Widget>[
                                Flexible(
                                  child: Text(
                                    contextLine.join(' · '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: PinkallColors.carbonSoft,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 9),
                              ],
                              _MarketSignal(market: contact.market),
                            ],
                          ),
                        ],
                        if (name.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            contact.phoneNumber,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelSmall?.copyWith(
                              color: PinkallColors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showChevron) ...<Widget>[
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 13),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: PinkallColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _MarketSignal extends StatelessWidget {
  const _MarketSignal({required this.market});

  final ContactMarket market;

  @override
  Widget build(BuildContext context) {
    final bool qualified = market != ContactMarket.unknown;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: qualified ? PinkallColors.pink : PinkallColors.muted,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          _marketLabel(market),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: PinkallColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

final class _ProspectDetail extends StatelessWidget {
  const _ProspectDetail({required this.contact});

  final ContactEntity? contact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PinkallColors.background,
      child: AnimatedSwitcher(
        duration: _reduceMotion(context)
            ? Duration.zero
            : _tokens(context).durationStandard,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: contact == null
            ? const _NoProspectSelected(key: ValueKey<String>('empty-detail'))
            : _ProspectDetailContent(
                key: ValueKey<String>(contact!.id),
                contact: contact!,
              ),
      ),
    );
  }
}

final class _NoProspectSelected extends StatelessWidget {
  const _NoProspectSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(-0.55, -0.25),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: 28, height: 2, color: PinkallColors.pink),
              const SizedBox(height: 20),
              Text(
                'Choisis un prospect',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Son identité, son contexte et le cadre de prospection '
                'apparaîtront ici.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProspectDetailContent extends StatelessWidget {
  const _ProspectDetailContent({
    required this.contact,
    this.onClose,
    super.key,
  });

  final ContactEntity contact;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String name = _contactName(contact);
    final String title = name.isEmpty ? contact.phoneNumber : name;
    final String professionalLine = <String>[
      if (contact.jobTitle?.trim().isNotEmpty == true) contact.jobTitle!.trim(),
      if (contact.company?.trim().isNotEmpty == true) contact.company!.trim(),
    ].join(' · ');
    final bool compact = MediaQuery.sizeOf(context).width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        compact ? 22 : 52,
        compact ? 12 : 46,
        compact ? 22 : 52,
        54,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'PROSPECT',
                      style: textTheme.labelSmall?.copyWith(
                        color: PinkallColors.pinkDark,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.15,
                      ),
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      tooltip: 'Fermer la fiche',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                ],
              ),
              SizedBox(height: compact ? 14 : 22),
              SelectableText(
                title,
                style:
                    (compact
                            ? textTheme.headlineMedium
                            : textTheme.displaySmall)
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: compact ? -0.7 : -1.05,
                          height: 1.04,
                        ),
              ),
              if (professionalLine.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  professionalLine,
                  style: textTheme.bodyLarge?.copyWith(
                    color: PinkallColors.carbonSoft,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              _MarketSignal(market: contact.market),
              SizedBox(height: compact ? 30 : 48),
              _ProspectReadingGrid(contact: contact),
              Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Text(
                  'Ajouté le ' +
                      _formatDate(contact.createdAt) +
                      ' · Mis à jour le ' +
                      _formatDate(contact.updatedAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: PinkallColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProspectReadingGrid extends StatelessWidget {
  const _ProspectReadingGrid({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final Widget identityColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _ReadingSection(
          title: 'Coordonnées',
          child: Column(
            children: <Widget>[
              _ContactLine(
                icon: Icons.phone_outlined,
                value: contact.phoneNumber,
                copyTooltip: 'Copier le numéro',
              ),
              if (contact.email?.trim().isNotEmpty == true)
                _ContactLine(
                  icon: Icons.mail_outline_rounded,
                  value: contact.email!.trim(),
                  copyTooltip: 'Copier l’email',
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        _ReadingSection(
          title: 'Cadre de prospection',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _complianceStatements(contact)
                .map(
                  (_ComplianceText statement) =>
                      _ComplianceStatement(statement: statement),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
    final Widget contextColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _ReadingSection(
          title: 'Contexte',
          child: contact.customFields.isEmpty
              ? const _QuietEmptyState(
                  title: 'Aucune note',
                  body: 'Le contexte ajouté au prospect apparaîtra ici.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contact.customFields.entries
                      .map(
                        (MapEntry<String, String> entry) =>
                            _ContextNote(label: entry.key, value: entry.value),
                      )
                      .toList(growable: false),
                ),
        ),
        const Divider(height: 1),
        const _ReadingSection(
          title: 'Suivi',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _QuietEmptyState(
                title: 'Prochaine action',
                body: 'Aucune prochaine action enregistrée.',
              ),
              SizedBox(height: 24),
              _QuietEmptyState(
                title: 'Activité',
                body: 'Aucune activité enregistrée pour ce prospect.',
              ),
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 680) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Divider(height: 1),
              identityColumn,
              const Divider(height: 1),
              contextColumn,
              const Divider(height: 1),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 11, child: identityColumn),
            const SizedBox(width: 62),
            Expanded(flex: 9, child: contextColumn),
          ],
        );
      },
    );
  }
}

final class _QuietEmptyState extends StatelessWidget {
  const _QuietEmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: PinkallColors.carbonSoft),
        ),
        const SizedBox(height: 5),
        Text(
          body,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: PinkallColors.muted,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

final class _ReadingSection extends StatelessWidget {
  const _ReadingSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 17),
          child,
        ],
      ),
    );
  }
}

final class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.value,
    required this.copyTooltip,
  });

  final IconData icon;
  final String value;
  final String copyTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: PinkallColors.muted),
          const SizedBox(width: 13),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: copyTooltip,
            child: IconButton(
              onPressed: () => _copyContactValue(
                context,
                value: value,
                confirmation: copyTooltip == 'Copier le numéro'
                    ? 'Numéro copié.'
                    : 'Email copié.',
              ),
              style: IconButton.styleFrom(
                minimumSize: const Size.square(40),
                padding: const EdgeInsets.all(9),
              ),
              icon: const Icon(Icons.content_copy_rounded, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ComplianceText {
  const _ComplianceText(this.text, {this.warning = false});

  final String text;
  final bool warning;
}

final class _ComplianceStatement extends StatelessWidget {
  const _ComplianceStatement({required this.statement});

  final _ComplianceText statement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: statement.warning
                    ? PinkallColors.error
                    : PinkallColors.carbonSoft,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statement.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: statement.warning
                    ? PinkallColors.error
                    : PinkallColors.carbonSoft,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ContextNote extends StatelessWidget {
  const _ContextNote({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: PinkallColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          SelectableText(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

final class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Aucun résultat',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 7),
              Text(
                'Aucun prospect ne correspond à « $query ».',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: PinkallColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _EmptyCrm extends StatelessWidget {
  const _EmptyCrm({required this.onCreate, required this.onImport});

  final VoidCallback onCreate;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).width < 720;
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 16 : 24,
          24,
          compact ? 16 : 24,
          24,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: PinkallColors.pinkWash,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 18,
                  color: PinkallColors.pinkDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ta liste d’appels est vide',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ajoute un prospect pour retrouver ici son numéro, '
                'tes notes et son briefing IA.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PinkallColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onCreate,
                  style: FilledButton.styleFrom(
                    backgroundColor: PinkallColors.carbon,
                    foregroundColor: PinkallColors.onStrong,
                    minimumSize: Size(0, compact ? 48 : 44),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Ajouter un prospect'),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.file_upload_outlined, size: 17),
                  label: const Text('Importer une liste'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _CrmLoading extends StatelessWidget {
  const _CrmLoading();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chargement des contacts',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Chargement des contacts…',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: PinkallColors.muted),
            ),
            const SizedBox(height: 24),
            for (int index = 0; index < 5; index++) ...<Widget>[
              _LoadingLine(widthFactor: index.isEven ? 0.42 : 0.34),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

final class _LoadingLine extends StatelessWidget {
  const _LoadingLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 11,
            decoration: BoxDecoration(
              color: PinkallColors.surfaceHigh,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.68,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: PinkallColors.surfaceLow,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _CrmInitialError extends StatelessWidget {
  const _CrmInitialError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(-0.35, -0.2),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: 28, height: 2, color: PinkallColors.error),
              const SizedBox(height: 20),
              Text(
                'Impossible de charger les contacts',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Vérifie ta connexion, puis réessaie dans un instant.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _copyContactValue(
  BuildContext context, {
  required String value,
  required String confirmation,
}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(confirmation),
        duration: const Duration(seconds: 2),
      ),
    );
}

Future<void> _showContactDetailSheet(
  BuildContext context,
  ContactEntity contact,
) async {
  final String name = _contactName(contact);
  final String title = name.isEmpty ? contact.phoneNumber : name;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: PinkallColors.surface,
    sheetAnimationStyle: _reduceMotion(context)
        ? AnimationStyle.noAnimation
        : const AnimationStyle(
            duration: Duration(milliseconds: 280),
            reverseDuration: Duration(milliseconds: 210),
          ),
    builder: (BuildContext sheetContext) => Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: 'Dossier prospect de $title',
      explicitChildNodes: true,
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: _ProspectDetailContent(
          contact: contact,
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    ),
  );
}

Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
  final CreateContactParam? params = await showDialog<CreateContactParam>(
    context: context,
    builder: (BuildContext context) => const _CreateContactDialog(),
  );
  if (params != null) {
    await ref.read(crmViewModelProvider.notifier).createContact(params);
  }
}

Future<void> _showImportDialog(BuildContext context, WidgetRef ref) async {
  final String? input = await showDialog<String>(
    context: context,
    builder: (BuildContext context) => const _ImportContactsDialog(),
  );
  if (input != null) {
    await ref.read(crmViewModelProvider.notifier).importContacts(input);
  }
}

final class _CreateContactDialog extends StatefulWidget {
  const _CreateContactDialog();

  @override
  State<_CreateContactDialog> createState() => _CreateContactDialogState();
}

final class _CreateContactDialogState extends State<_CreateContactDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _company = TextEditingController();
  ContactMarket _market = ContactMarket.unknown;
  bool _priorConsent = false;
  bool _optedOut = false;
  bool _professionalRelevance = false;

  @override
  void dispose() {
    _phone.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _company.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      title: const Text('Nouveau contact'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Ajoute uniquement les informations dont tu disposes.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _phone,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Téléphone *'),
                  validator: (String? value) =>
                      (value ?? '').trim().isEmpty ? 'Numéro requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _company,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Entreprise'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ContactMarket>(
                  isExpanded: true,
                  initialValue: _market,
                  decoration: const InputDecoration(labelText: 'Marché'),
                  items: const <DropdownMenuItem<ContactMarket>>[
                    DropdownMenuItem<ContactMarket>(
                      value: ContactMarket.unknown,
                      child: Text('À qualifier'),
                    ),
                    DropdownMenuItem<ContactMarket>(
                      value: ContactMarket.b2b,
                      child: Text('B2B'),
                    ),
                    DropdownMenuItem<ContactMarket>(
                      value: ContactMarket.b2c,
                      child: Text('B2C'),
                    ),
                  ],
                  onChanged: (ContactMarket? value) =>
                      setState(() => _market = value ?? ContactMarket.unknown),
                ),
                if (_market == ContactMarket.b2b)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _professionalRelevance,
                    title: const Text('Pertinence professionnelle confirmée'),
                    onChanged: (bool? value) =>
                        setState(() => _professionalRelevance = value ?? false),
                  ),
                if (_market == ContactMarket.b2c)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _priorConsent,
                    title: const Text('Accord préalable / contrat'),
                    onChanged: (bool? value) =>
                        setState(() => _priorConsent = value ?? false),
                  ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _optedOut,
                  title: const Text('Opposition aux appels'),
                  onChanged: (bool? value) =>
                      setState(() => _optedOut = value ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Ajouter'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    Navigator.of(context).pop(
      CreateContactParam(
        phoneNumber: _phone.text.trim(),
        market: _market,
        firstName: _nullable(_firstName.text),
        lastName: _nullable(_lastName.text),
        company: _nullable(_company.text),
        hasPriorConsent: _market == ContactMarket.b2c ? _priorConsent : null,
        hasOptedOut: _optedOut,
        professionalRelevanceConfirmed: _market == ContactMarket.b2b
            ? _professionalRelevance
            : null,
      ),
    );
  }
}

final class _ImportContactsDialog extends StatefulWidget {
  const _ImportContactsDialog();

  @override
  State<_ImportContactsDialog> createState() => _ImportContactsDialogState();
}

final class _ImportContactsDialogState extends State<_ImportContactsDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      title: const Text('Importer CSV ou JSON'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Les contacts valides seront envoyés à ton espace Pinkall.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
              ),
              const SizedBox(height: 8),
              const Text(
                'CSV : phone_number,first_name,last_name,company,market\n'
                'JSON : objet ou liste avec les mêmes clés.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                minLines: 8,
                maxLines: 12,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'Colle ici les données à importer…',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton.icon(
          onPressed: () {
            final String value = _controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.of(context).pop(value);
            }
          },
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Importer'),
        ),
      ],
    );
  }
}

List<_ComplianceText> _complianceStatements(ContactEntity contact) {
  final List<_ComplianceText> statements = <_ComplianceText>[];
  switch (contact.market) {
    case ContactMarket.b2b:
      statements.add(
        _ComplianceText(
          contact.professionalRelevanceConfirmed == true
              ? 'La pertinence professionnelle de la sollicitation est '
                    'confirmée.'
              : 'La pertinence professionnelle reste à confirmer avant '
                    'l’appel.',
          warning: contact.professionalRelevanceConfirmed != true,
        ),
      );
    case ContactMarket.b2c:
      statements.add(
        _ComplianceText(
          contact.hasPriorConsent == true
              ? 'Un accord préalable ou une relation contractuelle est '
                    'enregistré.'
              : 'Aucun accord préalable n’est enregistré pour ce contact.',
          warning: contact.hasPriorConsent != true,
        ),
      );
    case ContactMarket.unknown:
      statements.add(
        const _ComplianceText(
          'Le segment doit être qualifié avant toute prospection.',
          warning: true,
        ),
      );
  }
  statements.add(
    _ComplianceText(switch (contact.hasOptedOut) {
      true => 'Ce contact s’est opposé aux appels commerciaux.',
      false => 'Aucune opposition aux appels n’est enregistrée.',
      null => 'Le statut d’opposition n’est pas renseigné.',
    }, warning: contact.hasOptedOut != false),
  );
  return statements;
}

List<ContactEntity> _filterContacts(
  List<ContactEntity> contacts,
  String query,
) {
  final String normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return contacts;
  }
  return contacts
      .where((ContactEntity contact) {
        final String haystack = <String>[
          contact.phoneNumber,
          contact.firstName ?? '',
          contact.lastName ?? '',
          contact.company ?? '',
          contact.jobTitle ?? '',
          contact.email ?? '',
          ...contact.customFields.keys,
          ...contact.customFields.values,
        ].join(' ').toLowerCase();
        return haystack.contains(normalized);
      })
      .toList(growable: false);
}

ContactEntity? _selectedContact(
  List<ContactEntity> contacts,
  String? selectedContactId,
) {
  if (contacts.isEmpty) {
    return null;
  }
  for (final ContactEntity contact in contacts) {
    if (contact.id == selectedContactId) {
      return contact;
    }
  }
  return contacts.first;
}

String _contactName(ContactEntity contact) {
  return <String?>[contact.firstName, contact.lastName]
      .whereType<String>()
      .map((String value) => value.trim())
      .where((String value) => value.isNotEmpty)
      .join(' ');
}

String _initials(ContactEntity contact) {
  final List<String> parts = <String?>[contact.firstName, contact.lastName]
      .whereType<String>()
      .map((String value) => value.trim())
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return '#';
  }
  return parts.take(2).map((String value) => value[0].toUpperCase()).join();
}

String _marketLabel(ContactMarket market) {
  return switch (market) {
    ContactMarket.b2b => 'B2B',
    ContactMarket.b2c => 'B2C',
    ContactMarket.unknown => 'À qualifier',
  };
}

String _formatDate(DateTime date) {
  final DateTime local = date.toLocal();
  final String day = local.day.toString().padLeft(2, '0');
  final String month = local.month.toString().padLeft(2, '0');
  return day + '/' + month + '/' + local.year.toString();
}

PinkallThemeTokens _tokens(BuildContext context) {
  return Theme.of(context).extension<PinkallThemeTokens>() ??
      PinkallThemeTokens.light;
}

bool _reduceMotion(BuildContext context) {
  return MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);
}

String? _nullable(String value) {
  final String text = value.trim();
  return text.isEmpty ? null : text;
}
