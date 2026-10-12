import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Render deployment contract', () {
    test('Blueprint is image-backed and contains no source build path', () {
      final String blueprint = _workspaceFile(
        'infra/render/poc.blueprint.template.yaml',
      ).readAsStringSync();

      expect(blueprint, contains('runtime: image'));
      expect(blueprint, isNot(contains('runtime: docker')));
      expect(blueprint, contains('@sha256:__IMAGE_DIGEST_64_HEX__'));
      expect(blueprint, isNot(contains('\n    repo:')));
      expect(blueprint, isNot(contains('\n    buildCommand:')));
      expect(blueprint, isNot(contains('\n    dockerfilePath:')));
      expect(blueprint, contains('healthCheckPath: /health'));
      expect(blueprint, contains('region: frankfurt'));
      expect(blueprint, contains('numInstances: 1'));
    });

    test('Blueprint prompts for every provider and storage secret', () {
      final String blueprint = _workspaceFile(
        'infra/render/poc.blueprint.template.yaml',
      ).readAsStringSync();

      for (final String key in <String>[
        'PINKALL_API_TOKEN',
        'DATABASE_URL',
        'TELNYX_API_KEY',
        'DEEPGRAM_API_KEY',
        'MISTRAL_API_KEY',
        'OPENAI_API_KEY',
      ]) {
        expect(
          blueprint,
          contains(RegExp('key: $key\\n\\s+sync: false')),
          reason: '$key must never be committed in the Blueprint.',
        );
      }
      expect(blueprint, contains('PINKALL_ALLOW_EPHEMERAL_STORE'));
      expect(blueprint, contains('value: "false"'));
      expect(blueprint, contains('STRICT_CONFIG'));
      expect(blueprint, contains('key: DATABASE_SSL_ROOT_CERT'));
      expect(blueprint, contains('value: /etc/secrets/supabase-ca.crt'));
      expect(blueprint, contains('healthCheckPath: /health'));
    });

    test('runtime user can read Render secret files without being root', () {
      final String dockerfile = _workspaceFile(
        'apps/api_agent_vocal/Dockerfile',
      ).readAsStringSync();

      expect(dockerfile, contains('USER 65532:1000'));
      expect(dockerfile, isNot(contains('USER 65532:65532')));
    });

    test('Render docs require verified TLS and the session pooler', () {
      final String readme = _workspaceFile(
        'infra/render/README.md',
      ).readAsStringSync();

      expect(readme, contains('Shared Session pooler'));
      expect(readme, contains('port `5432`'));
      expect(readme, contains('sslmode=verify-full'));
      expect(readme, contains('/etc/secrets/supabase-ca.crt'));
      expect(readme, isNot(contains('URI on port `6543`')));
    });

    test('deployment wrapper requires prebuilt digest semantics', () {
      final String wrapper = _workspaceFile(
        'tool/deploy_render.sh',
      ).readAsStringSync();

      expect(wrapper, contains('--prebuilt is mandatory'));
      expect(wrapper, contains('@sha256:'));
      expect(wrapper, isNot(contains('build_and_deploy')));
      expect(wrapper, isNot(contains('docker build')));
      expect(wrapper, contains('/deploys'));
      expect(wrapper, contains('"imageUrl"'));
      expect(wrapper, contains('--header @-'));
      expect(
        wrapper,
        isNot(contains('--header "Authorization: Bearer')),
        reason: 'The Render API key must not appear in curl process arguments.',
      );
    });
  });
}

File _workspaceFile(String relativePath) {
  final List<File> candidates = <File>[
    File(relativePath),
    File('../../$relativePath'),
  ];
  return candidates.firstWhere(
    (File file) => file.existsSync(),
    orElse: () => throw StateError(
      'Could not locate $relativePath from ${Directory.current.path}.',
    ),
  );
}
