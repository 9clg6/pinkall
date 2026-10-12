import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/config/pinkall_backend_configuration.dart';

void main() {
  test('reads the API credential from the runtime environment', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{
            'PINKALL_API_TOKEN': ' runtime-token ',
          },
          useLocalPocEndpoints: false,
        );

    expect(configuration.apiToken, 'runtime-token');
  });

  test('uses loopback endpoints by default for the macOS POC', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{
            'PINKALL_API_TOKEN': 'runtime-token',
          },
          useLocalPocEndpoints: true,
        );

    expect(configuration.apiBaseUri, Uri.parse('http://127.0.0.1:8080'));
    expect(configuration.webSocketBaseUri, Uri.parse('ws://127.0.0.1:8080'));
    expect(configuration.isConfigured, isTrue);
  });

  test('does not use macOS POC endpoints on mobile platforms', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{
            'PINKALL_API_TOKEN': 'runtime-token',
          },
          useLocalPocEndpoints: false,
        );

    expect(configuration.apiBaseUri, isNull);
    expect(configuration.webSocketBaseUri, isNull);
    expect(configuration.isConfigured, isFalse);
  });

  test('keeps explicit endpoint overrides ahead of macOS defaults', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{
            'PINKALL_API_TOKEN': 'runtime-token',
          },
          apiBaseUrlOverride: 'https://api.pinkall.test',
          webSocketBaseUrlOverride: 'wss://api.pinkall.test',
          useLocalPocEndpoints: true,
        );

    expect(configuration.apiBaseUri, Uri.parse('https://api.pinkall.test'));
    expect(configuration.webSocketBaseUri, Uri.parse('wss://api.pinkall.test'));
  });

  test('accepts insecure backend endpoints only on loopback hosts', () {
    final PinkallBackendConfiguration localhost =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{},
          apiBaseUrlOverride: 'http://localhost:8080',
          webSocketBaseUrlOverride: 'ws://localhost:8080',
          useLocalPocEndpoints: false,
        );
    final PinkallBackendConfiguration ipv6 =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{},
          apiBaseUrlOverride: 'http://[::1]:8080',
          webSocketBaseUrlOverride: 'ws://[::1]:8080',
          useLocalPocEndpoints: false,
        );

    expect(localhost.isConfigured, isTrue);
    expect(ipv6.isConfigured, isTrue);
  });

  test('rejects HTTP and WS backend endpoints outside loopback', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{},
          apiBaseUrlOverride: 'http://api.pinkall.test',
          webSocketBaseUrlOverride: 'ws://api.pinkall.test',
          useLocalPocEndpoints: false,
        );

    expect(configuration.apiBaseUri, isNull);
    expect(configuration.webSocketBaseUri, isNull);
    expect(configuration.configurationError, contains('PINKALL_API_BASE_URL'));
    expect(configuration.configurationError, contains('PINKALL_WS_BASE_URL'));
  });

  test('does not hide invalid explicit endpoints behind local defaults', () {
    final PinkallBackendConfiguration configuration =
        PinkallBackendConfiguration.fromEnvironment(
          runtimeEnvironment: const <String, String>{
            'PINKALL_API_TOKEN': 'runtime-token',
          },
          apiBaseUrlOverride: 'ftp://api.pinkall.test',
          webSocketBaseUrlOverride: 'https://api.pinkall.test',
          useLocalPocEndpoints: true,
        );

    expect(configuration.apiBaseUri, isNull);
    expect(configuration.webSocketBaseUri, isNull);
    expect(configuration.configurationError, contains('PINKALL_API_BASE_URL'));
    expect(configuration.configurationError, contains('PINKALL_WS_BASE_URL'));
  });

  test(
    'does not invent a credential when the runtime environment is empty',
    () {
      final PinkallBackendConfiguration configuration =
          PinkallBackendConfiguration.fromEnvironment(
            runtimeEnvironment: const <String, String>{},
            useLocalPocEndpoints: false,
          );

      expect(configuration.apiToken, isEmpty);
      expect(configuration.isConfigured, isFalse);
      expect(
        configuration.configurationError,
        contains('PINKALL_API_BASE_URL'),
      );
      expect(configuration.configurationError, contains('PINKALL_WS_BASE_URL'));
      expect(
        configuration.configurationError,
        isNot(contains('PINKALL_API_TOKEN')),
      );
    },
  );
}
