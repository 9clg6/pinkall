import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinkall/features/auth/presentation/widgets/pinkall_auth_gate.widget.dart';
import 'package:pinkall/features/calls/domain/deep_links/call_deep_link.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Root widget for the Pinkall POC.
final class PinkallApp extends StatefulWidget {
  /// Creates the application with its router.
  const PinkallApp({required this.appRouter, this.incomingLinks, super.key});

  /// Application router shared for the widget lifetime.
  final AppRouter appRouter;

  /// Incoming URI stream override used by deterministic widget tests.
  ///
  /// Production listens to [AppLinks.uriLinkStream] when this is `null`.
  final Stream<Uri>? incomingLinks;

  @override
  State<PinkallApp> createState() => _PinkallAppState();
}

final class _PinkallAppState extends State<PinkallApp> {
  static const Set<String> _applicationRouteNames = <String>{
    WorkspaceSalesContextRoute.name,
    CallHomeRoute.name,
    ActiveCallRoute.name,
    CallHistoryRoute.name,
    CallProgressRoute.name,
    CrmRoute.name,
    InstantHelpRoute.name,
    RecordingImportRoute.name,
  };

  StreamSubscription<Uri>? _incomingLinkSubscription;
  _PendingCallDeepLink? _pendingDeepLink;
  bool _routerReady = false;
  bool _isOpeningDeepLink = false;
  bool _routerReplayScheduled = false;
  int _nextDeepLinkRequestId = 0;

  @override
  void initState() {
    super.initState();
    widget.appRouter.addListener(_handleRouterChanged);
    final Stream<Uri> incomingLinks =
        widget.incomingLinks ?? AppLinks().uriLinkStream;
    _incomingLinkSubscription = incomingLinks.listen(
      _handleIncomingLink,
      onError: _reportIncomingLinkError,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _routerReady = true;
      _replayPendingDeepLink();
    });
  }

  @override
  void dispose() {
    widget.appRouter.removeListener(_handleRouterChanged);
    unawaited(_incomingLinkSubscription?.cancel());
    super.dispose();
  }

  void _handleIncomingLink(Uri uri) {
    final CallDeepLink? deepLink = parseCallDeepLink(uri);
    if (deepLink == null) {
      return;
    }
    _pendingDeepLink = _PendingCallDeepLink(
      deepLink: deepLink,
      requestId: ++_nextDeepLinkRequestId,
    );
    _replayPendingDeepLink();
  }

  void _handleRouterChanged() {
    if (_routerReplayScheduled) {
      return;
    }
    _routerReplayScheduled = true;
    scheduleMicrotask(() {
      _routerReplayScheduled = false;
      if (mounted) {
        _replayPendingDeepLink();
      }
    });
  }

  void _replayPendingDeepLink() {
    final _PendingCallDeepLink? pendingDeepLink = _pendingDeepLink;
    if (!_routerReady || _isOpeningDeepLink || pendingDeepLink == null) {
      return;
    }
    final RouteData<dynamic> currentRoute = widget.appRouter.current;
    if (!_applicationRouteNames.contains(currentRoute.name)) {
      // The router can emit the initial link before its first application page
      // is mounted. Keep it queued until the initial onboarding route exists.
      return;
    }
    if (currentRoute.name == ActiveCallRoute.name) {
      // Replacing the route would detach the call controls without hanging up
      // the WebRTC session. Replay the request after the call route closes.
      return;
    }
    if (currentRoute.name == WorkspaceSalesContextRoute.name) {
      final WorkspaceSalesContextRouteArgs args = currentRoute
          .argsAs<WorkspaceSalesContextRouteArgs>(
            orElse: () => const WorkspaceSalesContextRouteArgs(),
          );
      if (args.editing) {
        // Preserve unsaved edits and replay the request after the editor closes.
        return;
      }
    }

    _pendingDeepLink = null;
    _isOpeningDeepLink = true;
    _openCallComposer(pendingDeepLink);
  }

  void _openCallComposer(_PendingCallDeepLink pendingDeepLink) {
    final RouteData<dynamic> currentRoute = widget.appRouter.current;
    final String phoneNumber = pendingDeepLink.deepLink.phoneNumber;
    final int requestId = pendingDeepLink.requestId;
    try {
      if (currentRoute.name == WorkspaceSalesContextRoute.name) {
        unawaited(
          widget.appRouter.replace(
            WorkspaceSalesContextRoute(
              initialPhoneNumber: phoneNumber,
              deepLinkRequestId: requestId,
            ),
          ),
        );
        return;
      }
      if (currentRoute.name == CallHomeRoute.name) {
        // Updating the existing composer preserves an in-flight dial/answer
        // operation and its view model instead of detaching a real call setup.
        unawaited(
          widget.appRouter.replace(
            CallHomeRoute(
              initialPhoneNumber: phoneNumber,
              deepLinkRequestId: requestId,
            ),
          ),
        );
        return;
      }
      unawaited(
        widget.appRouter.replaceAll(<PageRouteInfo>[
          CallHomeRoute(
            initialPhoneNumber: phoneNumber,
            deepLinkRequestId: requestId,
          ),
        ]),
      );
    } on Object catch (error, stackTrace) {
      _reportIncomingLinkError(error, stackTrace);
    } finally {
      _isOpeningDeepLink = false;
      if (mounted) {
        _handleRouterChanged();
      }
    }
  }

  void _reportIncomingLinkError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'Pinkall deep links',
        context: ErrorDescription('while receiving an application link'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => LocaleKeys.app_name.tr(),
      theme: PinkallTheme.light,
      routerConfig: widget.appRouter.config(),
      builder: (BuildContext context, Widget? child) =>
          PinkallAuthGate(authenticatedChild: child ?? const SizedBox.shrink()),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

final class _PendingCallDeepLink {
  const _PendingCallDeepLink({required this.deepLink, required this.requestId});

  final CallDeepLink deepLink;
  final int requestId;
}
