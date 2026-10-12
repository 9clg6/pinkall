import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:test/test.dart';

void main() {
  test('normalizes, versions, and round-trips a workspace sales context', () {
    final DateTime createdAt = DateTime.utc(2026, 7, 13, 10);
    final WorkspaceSalesContext created = WorkspaceSalesContext.create(
      companyName: '  Pinkall  ',
      productName: '  Coach IA  ',
      pitchMarkdown: '  # Promesse\r\nConvertir davantage.  ',
      now: createdAt,
    );

    expect(created.companyName, 'Pinkall');
    expect(created.productName, 'Coach IA');
    expect(created.pitchMarkdown, '# Promesse\nConvertir davantage.');
    expect(created.revision, 1);

    final WorkspaceSalesContext updated = created.update(
      companyName: 'Pinkall',
      productName: 'Coach IA temps réel',
      pitchMarkdown: '# Promesse\nLe bon conseil au bon moment.',
      now: createdAt.add(const Duration(minutes: 1)),
    );
    final WorkspaceSalesContext restored = WorkspaceSalesContext.fromJson(
      updated.toJson(),
    );

    expect(restored.revision, 2);
    expect(restored.createdAt, createdAt);
    expect(restored.updatedAt, createdAt.add(const Duration(minutes: 1)));
    expect(restored.toJson(), updated.toJson());
  });

  test('enforces the pitch limit in UTF-8 bytes', () {
    expect(
      WorkspaceSalesContext.create(
        companyName: 'Pinkall',
        productName: 'Coach IA',
        pitchMarkdown: List<String>.filled(4096, '🙂').join(),
        now: DateTime.utc(2026, 7, 13),
      ).pitchMarkdown,
      hasLength(8192),
    );

    expect(
      () => WorkspaceSalesContext.create(
        companyName: 'Pinkall',
        productName: 'Coach IA',
        pitchMarkdown: '${List<String>.filled(4096, '🙂').join()}a',
        now: DateTime.utc(2026, 7, 13),
      ),
      throwsFormatException,
    );
  });
}
