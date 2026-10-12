import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/core/repositories/workspace_sales_context.repository.provider.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.state.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.view_model.dart';

void main() {
  test('loads and durably saves the first workspace sales context', () async {
    final _WorkspaceSalesContextRepository repository =
        _WorkspaceSalesContextRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        workspaceSalesContextRepositoryProvider.overrideWith(
          (Ref ref) async => repository,
        ),
      ],
    );
    addTearDown(container.dispose);

    final WorkspaceSalesContextState initial = await container.read(
      workspaceSalesContextViewModelProvider.future,
    );
    expect(initial.context, isNull);

    final bool saved = await container
        .read(workspaceSalesContextViewModelProvider.notifier)
        .save(
          companyName: 'Pinkall SAS',
          productName: 'Pinkall',
          pitchMarkdown: '# ICP\nFondateurs B2B',
        );

    expect(saved, isTrue);
    expect(repository.lastUpdate?.expectedRevision, isNull);
    expect(
      container
          .read(workspaceSalesContextViewModelProvider)
          .value
          ?.context
          ?.revision,
      1,
    );
  });
}

final class _WorkspaceSalesContextRepository
    implements WorkspaceSalesContextRepository {
  UpsertWorkspaceSalesContextParam? lastUpdate;

  @override
  Future<WorkspaceSalesContextEntity?> getContext() async => null;

  @override
  Future<WorkspaceSalesContextEntity> upsertContext(
    UpsertWorkspaceSalesContextParam params,
  ) async {
    lastUpdate = params;
    final DateTime now = DateTime.utc(2026, 7, 13);
    return WorkspaceSalesContextEntity(
      companyName: params.companyName,
      productName: params.productName,
      pitchMarkdown: params.pitchMarkdown,
      revision: 1,
      createdAt: now,
      updatedAt: now,
    );
  }
}
