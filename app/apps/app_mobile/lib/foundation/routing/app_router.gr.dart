// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ActiveCallScreen]
class ActiveCallRoute extends PageRouteInfo<ActiveCallRouteArgs> {
  ActiveCallRoute({
    required String callId,
    required String sessionId,
    String? remoteNumber,
    bool incoming = false,
    bool companion = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ActiveCallRoute.name,
         args: ActiveCallRouteArgs(
           callId: callId,
           sessionId: sessionId,
           remoteNumber: remoteNumber,
           incoming: incoming,
           companion: companion,
           key: key,
         ),
         rawPathParams: {'callId': callId, 'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'ActiveCallRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ActiveCallRouteArgs>(
        orElse: () => ActiveCallRouteArgs(
          callId: pathParams.getString('callId'),
          sessionId: pathParams.getString('sessionId'),
        ),
      );
      return ActiveCallScreen(
        callId: args.callId,
        sessionId: args.sessionId,
        remoteNumber: args.remoteNumber,
        incoming: args.incoming,
        companion: args.companion,
        key: args.key,
      );
    },
  );
}

class ActiveCallRouteArgs {
  const ActiveCallRouteArgs({
    required this.callId,
    required this.sessionId,
    this.remoteNumber,
    this.incoming = false,
    this.companion = false,
    this.key,
  });

  final String callId;

  final String sessionId;

  final String? remoteNumber;

  final bool incoming;

  final bool companion;

  final Key? key;

  @override
  String toString() {
    return 'ActiveCallRouteArgs{callId: $callId, sessionId: $sessionId, remoteNumber: $remoteNumber, incoming: $incoming, companion: $companion, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ActiveCallRouteArgs) return false;
    return callId == other.callId &&
        sessionId == other.sessionId &&
        remoteNumber == other.remoteNumber &&
        incoming == other.incoming &&
        companion == other.companion &&
        key == other.key;
  }

  @override
  int get hashCode =>
      callId.hashCode ^
      sessionId.hashCode ^
      remoteNumber.hashCode ^
      incoming.hashCode ^
      companion.hashCode ^
      key.hashCode;
}

/// generated route for
/// [CallHistoryScreen]
class CallHistoryRoute extends PageRouteInfo<void> {
  const CallHistoryRoute({List<PageRouteInfo>? children})
    : super(CallHistoryRoute.name, initialChildren: children);

  static const String name = 'CallHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CallHistoryScreen();
    },
  );
}

/// generated route for
/// [CallHomeScreen]
class CallHomeRoute extends PageRouteInfo<CallHomeRouteArgs> {
  CallHomeRoute({
    String? initialPhoneNumber,
    int? deepLinkRequestId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CallHomeRoute.name,
         args: CallHomeRouteArgs(
           initialPhoneNumber: initialPhoneNumber,
           deepLinkRequestId: deepLinkRequestId,
           key: key,
         ),
         rawQueryParams: {'number': initialPhoneNumber},
         initialChildren: children,
       );

  static const String name = 'CallHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<CallHomeRouteArgs>(
        orElse: () => CallHomeRouteArgs(
          initialPhoneNumber: queryParams.optString('number'),
        ),
      );
      return CallHomeScreen(
        initialPhoneNumber: args.initialPhoneNumber,
        deepLinkRequestId: args.deepLinkRequestId,
        key: args.key,
      );
    },
  );
}

class CallHomeRouteArgs {
  const CallHomeRouteArgs({
    this.initialPhoneNumber,
    this.deepLinkRequestId,
    this.key,
  });

  final String? initialPhoneNumber;

  final int? deepLinkRequestId;

  final Key? key;

  @override
  String toString() {
    return 'CallHomeRouteArgs{initialPhoneNumber: $initialPhoneNumber, deepLinkRequestId: $deepLinkRequestId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CallHomeRouteArgs) return false;
    return initialPhoneNumber == other.initialPhoneNumber &&
        deepLinkRequestId == other.deepLinkRequestId &&
        key == other.key;
  }

  @override
  int get hashCode =>
      initialPhoneNumber.hashCode ^ deepLinkRequestId.hashCode ^ key.hashCode;
}

/// generated route for
/// [CallProgressScreen]
class CallProgressRoute extends PageRouteInfo<void> {
  const CallProgressRoute({List<PageRouteInfo>? children})
    : super(CallProgressRoute.name, initialChildren: children);

  static const String name = 'CallProgressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CallProgressScreen();
    },
  );
}

/// generated route for
/// [CrmScreen]
class CrmRoute extends PageRouteInfo<void> {
  const CrmRoute({List<PageRouteInfo>? children})
    : super(CrmRoute.name, initialChildren: children);

  static const String name = 'CrmRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CrmScreen();
    },
  );
}

/// generated route for
/// [InstantHelpScreen]
class InstantHelpRoute extends PageRouteInfo<void> {
  const InstantHelpRoute({List<PageRouteInfo>? children})
    : super(InstantHelpRoute.name, initialChildren: children);

  static const String name = 'InstantHelpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InstantHelpScreen();
    },
  );
}

/// generated route for
/// [ObjectionLibraryScreen]
class ObjectionLibraryRoute extends PageRouteInfo<void> {
  const ObjectionLibraryRoute({List<PageRouteInfo>? children})
    : super(ObjectionLibraryRoute.name, initialChildren: children);

  static const String name = 'ObjectionLibraryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ObjectionLibraryScreen();
    },
  );
}

/// generated route for
/// [RecordingImportScreen]
class RecordingImportRoute extends PageRouteInfo<RecordingImportRouteArgs> {
  RecordingImportRoute({
    RecordingAudioImport? initialImport,
    bool openPicker = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         RecordingImportRoute.name,
         args: RecordingImportRouteArgs(
           initialImport: initialImport,
           openPicker: openPicker,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'RecordingImportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecordingImportRouteArgs>(
        orElse: () => const RecordingImportRouteArgs(),
      );
      return RecordingImportScreen(
        initialImport: args.initialImport,
        openPicker: args.openPicker,
        key: args.key,
      );
    },
  );
}

class RecordingImportRouteArgs {
  const RecordingImportRouteArgs({
    this.initialImport,
    this.openPicker = false,
    this.key,
  });

  final RecordingAudioImport? initialImport;

  final bool openPicker;

  final Key? key;

  @override
  String toString() {
    return 'RecordingImportRouteArgs{initialImport: $initialImport, openPicker: $openPicker, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RecordingImportRouteArgs) return false;
    return initialImport == other.initialImport &&
        openPicker == other.openPicker &&
        key == other.key;
  }

  @override
  int get hashCode =>
      initialImport.hashCode ^ openPicker.hashCode ^ key.hashCode;
}

/// generated route for
/// [WorkspaceSalesContextScreen]
class WorkspaceSalesContextRoute
    extends PageRouteInfo<WorkspaceSalesContextRouteArgs> {
  WorkspaceSalesContextRoute({
    bool editing = false,
    String? initialPhoneNumber,
    int? deepLinkRequestId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         WorkspaceSalesContextRoute.name,
         args: WorkspaceSalesContextRouteArgs(
           editing: editing,
           initialPhoneNumber: initialPhoneNumber,
           deepLinkRequestId: deepLinkRequestId,
           key: key,
         ),
         rawQueryParams: {'number': initialPhoneNumber},
         initialChildren: children,
       );

  static const String name = 'WorkspaceSalesContextRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<WorkspaceSalesContextRouteArgs>(
        orElse: () => WorkspaceSalesContextRouteArgs(
          initialPhoneNumber: queryParams.optString('number'),
        ),
      );
      return WorkspaceSalesContextScreen(
        editing: args.editing,
        initialPhoneNumber: args.initialPhoneNumber,
        deepLinkRequestId: args.deepLinkRequestId,
        key: args.key,
      );
    },
  );
}

class WorkspaceSalesContextRouteArgs {
  const WorkspaceSalesContextRouteArgs({
    this.editing = false,
    this.initialPhoneNumber,
    this.deepLinkRequestId,
    this.key,
  });

  final bool editing;

  final String? initialPhoneNumber;

  final int? deepLinkRequestId;

  final Key? key;

  @override
  String toString() {
    return 'WorkspaceSalesContextRouteArgs{editing: $editing, initialPhoneNumber: $initialPhoneNumber, deepLinkRequestId: $deepLinkRequestId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkspaceSalesContextRouteArgs) return false;
    return editing == other.editing &&
        initialPhoneNumber == other.initialPhoneNumber &&
        deepLinkRequestId == other.deepLinkRequestId &&
        key == other.key;
  }

  @override
  int get hashCode =>
      editing.hashCode ^
      initialPhoneNumber.hashCode ^
      deepLinkRequestId.hashCode ^
      key.hashCode;
}
