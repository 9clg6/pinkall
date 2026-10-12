import 'dart:async';

import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/auth/domain/entities/pinkall_auth_session.entity.dart';
import 'package:pinkall/features/auth/domain/params/pinkall_sign_in.param.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';
import 'package:pinkall/features/auth/presentation/widgets/pinkall_auth_gate.widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows invite-only sign-in and no public signup action', (
    WidgetTester tester,
  ) async {
    final _FakeAuthRepository repository = _FakeAuthRepository();
    await _pumpGate(tester, repository);

    expect(find.byKey(const Key('pinkall_sign_in_card')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_auth_email')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_auth_password')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_auth_submit')), findsOneWidget);
    expect(find.text('auth_invite_only'), findsOneWidget);
    expect(find.textContaining('Créer un compte'), findsNothing);
    expect(find.byKey(const Key('authenticated_workspace')), findsNothing);
  });

  testWidgets(
    'signs in, clears the password field, and reveals the workspace',
    (WidgetTester tester) async {
      final _FakeAuthRepository repository = _FakeAuthRepository();
      await _pumpGate(tester, repository);

      await tester.enterText(
        find.byKey(const Key('pinkall_auth_email')),
        '  Founder@Example.COM  ',
      );
      await tester.enterText(
        find.byKey(const Key('pinkall_auth_password')),
        'ephemeral-password',
      );
      await tester.tap(find.byKey(const Key('pinkall_auth_submit')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(repository.lastSignIn?.email, 'founder@example.com');
      expect(repository.lastSignIn?.password, 'ephemeral-password');
      expect(find.byKey(const Key('authenticated_workspace')), findsOneWidget);
      expect(find.byKey(const Key('pinkall_auth_password')), findsNothing);
      expect(find.byKey(const Key('pinkall_auth_logout')), findsOneWidget);
    },
  );

  testWidgets('restores a persisted session and provides accessible logout', (
    WidgetTester tester,
  ) async {
    final _FakeAuthRepository repository = _FakeAuthRepository(
      initialSession: const PinkallAuthSessionEntity(
        userId: 'user-1',
        email: 'founder@example.com',
      ),
    );
    await _pumpGate(tester, repository);

    expect(find.byKey(const Key('authenticated_workspace')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_auth_logout')), findsOneWidget);
    expect(find.text('founder@example.com'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pinkall_auth_logout')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(repository.signOutCount, 1);
    expect(find.byKey(const Key('pinkall_sign_in_card')), findsOneWidget);
    expect(find.byKey(const Key('authenticated_workspace')), findsNothing);
  });

  testWidgets('never renders raw provider or credential errors', (
    WidgetTester tester,
  ) async {
    const String sensitiveError = 'provider says token=secret password=hunter2';
    final _FakeAuthRepository repository = _FakeAuthRepository(
      signInError: Exception(sensitiveError),
    );
    await _pumpGate(tester, repository);

    await tester.enterText(
      find.byKey(const Key('pinkall_auth_email')),
      'founder@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('pinkall_auth_password')),
      'hunter2',
    );
    await tester.tap(find.byKey(const Key('pinkall_auth_submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('pinkall_auth_error')), findsOneWidget);
    expect(find.textContaining(sensitiveError), findsNothing);
    expect(find.textContaining('hunter2'), findsNothing);
  });
}

Future<void> _pumpGate(
  WidgetTester tester,
  PinkallAuthRepository repository,
) async {
  tester.view.physicalSize = const Size(900, 720);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        pinkallAuthRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: PinkallTheme.light,
        home: PinkallAuthGate(
          authenticatedChild: const ColoredBox(
            key: Key('authenticated_workspace'),
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final class _FakeAuthRepository implements PinkallAuthRepository {
  _FakeAuthRepository({
    PinkallAuthSessionEntity? initialSession,
    this.signInError,
  }) : _currentSession = initialSession;

  PinkallAuthSessionEntity? _currentSession;
  final Object? signInError;
  final StreamController<PinkallAuthSessionEntity?> _controller =
      StreamController<PinkallAuthSessionEntity?>.broadcast();
  PinkallSignInParam? lastSignIn;
  int signOutCount = 0;

  @override
  bool get isAvailable => true;

  @override
  String? get unavailableReason => null;

  @override
  bool get canSignOut => true;

  @override
  PinkallAuthSessionEntity? get currentSession => _currentSession;

  @override
  Stream<PinkallAuthSessionEntity?> get sessionChanges => _controller.stream;

  @override
  Future<String?> currentAccessToken() async =>
      _currentSession == null ? null : 'test-token';

  @override
  Future<void> signIn(PinkallSignInParam param) async {
    lastSignIn = param;
    final Object? error = signInError;
    if (error != null) {
      throw error;
    }
    _currentSession = PinkallAuthSessionEntity(
      userId: 'user-1',
      email: param.email,
    );
    _controller.add(_currentSession);
  }

  @override
  Future<void> signOut() async {
    signOutCount += 1;
    _currentSession = null;
    _controller.add(null);
  }
}
