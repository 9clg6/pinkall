import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/data/datasource/telnyx.remote_data_source.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call.repository.provider.g.dart';

/// Provides the Telnyx-backed domain call repository.
@riverpod
Future<CallRepository> callRepository(Ref ref) async {
  final TelnyxRemoteDataSource remoteDataSource = await ref.watch(
    telnyxRemoteDataSourceProvider.future,
  );
  return CallRepositoryImpl(telnyxRemoteDataSource: remoteDataSource);
}
