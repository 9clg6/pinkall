import 'package:api_agent_vocal/src/domain/coaching_context.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:test/test.dart';

void main() {
  test('preserves legacy preparation when no workspace context exists', () {
    const String preparation = '# Objectif\nObtenir un rendez-vous.';

    expect(
      composeUntrustedCoachingContextMarkdown(
        workspaceSalesContext: null,
        callPreparationMarkdown: preparation,
      ),
      same(preparation),
    );
    expect(
      composeUntrustedCoachingContextMarkdown(
        workspaceSalesContext: null,
        callPreparationMarkdown: null,
      ),
      isNull,
    );
  });

  test('delimits workspace and optional call context as untrusted data', () {
    final WorkspaceSalesContext workspace = WorkspaceSalesContext.create(
      companyName: 'Pinkall',
      productName: 'Coach IA',
      pitchMarkdown: '# Pitch\nCoaching pendant et après les appels.',
      now: DateTime.utc(2026, 7, 13),
    );

    final String composed = composeUntrustedCoachingContextMarkdown(
      workspaceSalesContext: workspace,
      callPreparationMarkdown: '# Préparation\nComprendre le décideur.',
    )!;

    expect(composed, startsWith('[PINKALL_BEGIN_UNTRUSTED_USER_CONTEXT]'));
    expect(composed, contains('company_name: Pinkall'));
    expect(composed, contains('product_name: Coach IA'));
    expect(composed, contains('[PINKALL_BEGIN_UNTRUSTED_GLOBAL_PITCH]'));
    expect(composed, contains('# Pitch'));
    expect(composed, contains('[PINKALL_BEGIN_UNTRUSTED_CALL_PREPARATION]'));
    expect(composed, contains('# Préparation'));
    expect(composed, endsWith('[PINKALL_END_UNTRUSTED_USER_CONTEXT]'));

    final String workspaceOnly = composeUntrustedCoachingContextMarkdown(
      workspaceSalesContext: workspace,
      callPreparationMarkdown: null,
    )!;
    expect(workspaceOnly, contains('# Pitch'));
    expect(
      workspaceOnly,
      isNot(contains('[PINKALL_BEGIN_UNTRUSTED_CALL_PREPARATION]')),
    );
  });
}
