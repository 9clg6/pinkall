import 'dart:io';

import 'package:core_data/core_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_device.client.provider.g.dart';

/// Provides the native WebRTC audio-device boundary.
@riverpod
AudioDeviceClient audioDeviceClient(Ref ref) {
  return const FlutterWebRtcAudioDeviceClient();
}

/// Whether this runtime exposes desktop WebRTC audio-device routing.
///
/// Kept injectable so widget tests and unsupported embedders never invoke the
/// native desktop plugin merely because their host machine runs macOS.
@riverpod
bool supportsDesktopAudioDeviceSelection(Ref ref) => Platform.isMacOS;
