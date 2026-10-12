import 'dart:async';

import 'package:core_data/core_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telnyx.sdk_client.provider.g.dart';

/// Provides the official Telnyx WebRTC SDK boundary.
///
/// The transport owns active calls, so it must outlive screen and use-case
/// providers. Disposing it while a route is changing sends BYE for every open
/// call.
@Riverpod(keepAlive: true)
Future<TelnyxSdkClient> telnyxSdkClient(Ref ref) async {
  final TelnyxSdkClient client = TelnyxSdkClientImpl();
  ref.onDispose(() => unawaited(client.dispose()));
  return client;
}
