import 'package:pinkall/core/config/pinkall_supabase_configuration.dart';
import 'package:pinkall/core/config/pinkall_supabase_local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Injectable Supabase initialization boundary used by startup tests.
typedef PinkallSupabaseInitializer =
    Future<SupabaseClient> Function({
      required Uri url,
      required String publishableKey,
    });

/// Initializes Supabase only when the two public values are valid.
///
/// Initialization failures are deliberately reduced to `null`; the AuthGate
/// renders a sanitized unavailable state and no provider exception reaches UI.
Future<SupabaseClient?> initializePinkallSupabase(
  PinkallSupabaseConfiguration configuration, {
  PinkallSupabaseInitializer initializer = _initializeOfficialClient,
}) async {
  if (!configuration.isConfigured) {
    return null;
  }
  try {
    return await initializer(
      url: configuration.url!,
      publishableKey: configuration.publishableKey,
    );
  } on Object {
    return null;
  }
}

Future<SupabaseClient> _initializeOfficialClient({
  required Uri url,
  required String publishableKey,
}) async {
  final Supabase instance = await Supabase.initialize(
    url: url.toString(),
    publishableKey: publishableKey,
    debug: false,
    authOptions: FlutterAuthClientOptions(
      localStorage: PinkallSecureSupabaseLocalStorage(projectUrl: url),
    ),
  );
  return instance.client;
}
