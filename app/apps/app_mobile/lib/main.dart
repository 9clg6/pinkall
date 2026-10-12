import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/core/config/pinkall_supabase_bootstrap.dart';
import 'package:pinkall/core/config/pinkall_supabase_configuration.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/presentation/pinkall_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Starts the Pinkall POC.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final AppRouter appRouter = AppRouter();
  final PinkallSupabaseConfiguration supabaseConfiguration =
      PinkallSupabaseConfiguration.fromEnvironment();
  final SupabaseClient? supabaseClient = await initializePinkallSupabase(
    supabaseConfiguration,
  );

  runApp(
    ProviderScope(
      // Override is intentionally not exported by flutter_riverpod 3.3.1.
      // ignore: always_specify_types
      overrides: [
        pinkallSupabaseConfigurationProvider.overrideWithValue(
          supabaseConfiguration,
        ),
        pinkallSupabaseClientProvider.overrideWithValue(supabaseClient),
      ],
      child: EasyLocalization(
        supportedLocales: const <Locale>[Locale('fr'), Locale('en')],
        fallbackLocale: const Locale('fr'),
        path: 'assets/translations',
        child: PinkallApp(appRouter: appRouter),
      ),
    ),
  );
}
