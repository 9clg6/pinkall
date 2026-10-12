import 'package:auto_route/auto_route.dart';
import 'package:core_data/core_data.dart';
import 'package:flutter/material.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.screen.dart';
import 'package:pinkall/features/calls/presentation/screens/history/call_history.screen.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.screen.dart';
import 'package:pinkall/features/calls/presentation/screens/progress/call_progress.screen.dart';
import 'package:pinkall/features/coaching/presentation/screens/objections/objection_library.screen.dart';
import 'package:pinkall/features/crm/presentation/crm.screen.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.screen.dart';
import 'package:pinkall/features/onboarding/presentation/screens/workspace_sales_context/workspace_sales_context.screen.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.screen.dart';

part 'app_router.gr.dart';

/// Native route configuration for the Pinkall POC.
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
final class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: WorkspaceSalesContextRoute.page, path: '/', initial: true),
    AutoRoute(page: CallHomeRoute.page, path: '/phone'),
    AutoRoute(
      page: ActiveCallRoute.page,
      path: '/call/:callId/session/:sessionId',
    ),
    AutoRoute(page: CallHistoryRoute.page, path: '/history'),
    AutoRoute(page: CallProgressRoute.page, path: '/progress'),
    AutoRoute(page: ObjectionLibraryRoute.page, path: '/objections'),
    AutoRoute(page: CrmRoute.page, path: '/crm'),
    AutoRoute(page: InstantHelpRoute.page, path: '/instant-help'),
    AutoRoute(page: RecordingImportRoute.page, path: '/import-recording'),
  ];
}
