import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/config/pinkall_supabase_local_storage.dart';

void main() {
  final Uri projectUrl = Uri.parse('https://project.supabase.co');
  final String sessionKey = PinkallSecureSupabaseLocalStorage.sessionKeyFor(
    projectUrl,
  );

  group('PinkallSecureSupabaseLocalStorage', () {
    test('migrates and removes the former plaintext session', () async {
      const String session = '{"access_token":"private-session"}';
      final _MemorySecureStore secureStore = _MemorySecureStore();
      final _MemoryLegacyStore legacyStore = _MemoryLegacyStore(
        <String, String>{sessionKey: session},
      );
      final PinkallSecureSupabaseLocalStorage storage =
          PinkallSecureSupabaseLocalStorage(
            projectUrl: projectUrl,
            secureStore: secureStore,
            legacyStore: legacyStore,
          );

      await storage.initialize();

      expect(await secureStore.read(sessionKey), session);
      expect(await legacyStore.read(sessionKey), isNull);
      expect(await storage.accessToken(), session);
      expect(storage.toString(), isNot(contains(session)));
    });

    test(
      'removes a stale plaintext copy when secure storage already wins',
      () async {
        const String secureSession = '{"access_token":"secure"}';
        final _MemorySecureStore secureStore = _MemorySecureStore(
          <String, String>{sessionKey: secureSession},
        );
        final _MemoryLegacyStore legacyStore = _MemoryLegacyStore(
          <String, String>{sessionKey: '{"access_token":"stale-plaintext"}'},
        );
        final PinkallSecureSupabaseLocalStorage storage =
            PinkallSecureSupabaseLocalStorage(
              projectUrl: projectUrl,
              secureStore: secureStore,
              legacyStore: legacyStore,
            );

        await storage.initialize();

        expect(await storage.accessToken(), secureSession);
        expect(await legacyStore.read(sessionKey), isNull);
      },
    );

    test(
      'keeps the legacy session when the secure copy cannot be verified',
      () async {
        const String session = '{"access_token":"recoverable"}';
        final _MemorySecureStore secureStore = _MemorySecureStore(
          <String, String>{},
          true,
        );
        final _MemoryLegacyStore legacyStore = _MemoryLegacyStore(
          <String, String>{sessionKey: session},
        );
        final PinkallSecureSupabaseLocalStorage storage =
            PinkallSecureSupabaseLocalStorage(
              projectUrl: projectUrl,
              secureStore: secureStore,
              legacyStore: legacyStore,
            );

        await expectLater(storage.initialize(), throwsA(isA<StateError>()));

        expect(await legacyStore.read(sessionKey), session);
        expect(await secureStore.read(sessionKey), isNull);
      },
    );

    test(
      'persists only in secure storage and removes legacy residue',
      () async {
        const String session = '{"access_token":"new-secure-session"}';
        final _MemorySecureStore secureStore = _MemorySecureStore();
        final _MemoryLegacyStore legacyStore = _MemoryLegacyStore(
          <String, String>{sessionKey: '{"access_token":"old-plaintext"}'},
        );
        final PinkallSecureSupabaseLocalStorage storage =
            PinkallSecureSupabaseLocalStorage(
              projectUrl: projectUrl,
              secureStore: secureStore,
              legacyStore: legacyStore,
            );

        await storage.persistSession(session);

        expect(await secureStore.read(sessionKey), session);
        expect(await legacyStore.read(sessionKey), isNull);
        expect(await storage.hasAccessToken(), isTrue);
      },
    );

    test('sign-out removes secure and legacy copies', () async {
      final _MemorySecureStore secureStore = _MemorySecureStore(
        <String, String>{sessionKey: '{"access_token":"secure"}'},
      );
      final _MemoryLegacyStore legacyStore = _MemoryLegacyStore(
        <String, String>{sessionKey: '{"access_token":"legacy"}'},
      );
      final PinkallSecureSupabaseLocalStorage storage =
          PinkallSecureSupabaseLocalStorage(
            projectUrl: projectUrl,
            secureStore: secureStore,
            legacyStore: legacyStore,
          );

      await storage.removePersistedSession();

      expect(await secureStore.read(sessionKey), isNull);
      expect(await legacyStore.read(sessionKey), isNull);
      expect(await storage.hasAccessToken(), isFalse);
    });
  });
}

final class _MemorySecureStore implements PinkallSecureKeyValueStore {
  _MemorySecureStore([Map<String, String>? values, this.ignoreWrites = false])
    : _values = <String, String>{...?values};

  final Map<String, String> _values;
  final bool ignoreWrites;

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    if (!ignoreWrites) {
      _values[key] = value;
    }
  }
}

final class _MemoryLegacyStore implements PinkallLegacySessionStore {
  _MemoryLegacyStore(Map<String, String> values)
    : _values = <String, String>{...values};

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}
