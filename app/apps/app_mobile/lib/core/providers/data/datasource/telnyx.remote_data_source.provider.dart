import 'package:core_data/core_data.dart';
import 'package:pinkall/core/providers/data/endpoint/telnyx.sdk_client.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telnyx.remote_data_source.provider.g.dart';

/// Provides the Telnyx WebRTC remote data source.
@riverpod
Future<TelnyxRemoteDataSource> telnyxRemoteDataSource(Ref ref) async {
  final TelnyxSdkClient sdkClient = await ref.watch(
    telnyxSdkClientProvider.future,
  );
  return TelnyxRemoteDataSourceImpl(telnyxSdkClient: sdkClient);
}
