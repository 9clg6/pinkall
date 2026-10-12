import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kernel.provider.g.dart';

/// Initializes the real Telnyx dependency graph once for the application.
@Riverpod(keepAlive: true)
Future<void> kernel(Ref ref) async {
  await ref.watch(callRepositoryProvider.future);
}
