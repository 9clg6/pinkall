import 'dart:async';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final AppConfig config = AppConfig.fromPlatformEnvironment();
  if (config.strictConfiguration && config.validationErrors.isNotEmpty) {
    stderr.writeln('Pinkall configuration is invalid:');
    for (final String error in config.validationErrors) {
      stderr.writeln('- $error');
    }
    exitCode = 78;
    return;
  }

  late final PinkallBackend backend;
  try {
    backend = PinkallBackend.create(config);
  } on StateError catch (error) {
    stderr.writeln('Pinkall startup refused: ${error.message}');
    exitCode = 78;
    return;
  }
  try {
    await backend.initialize();
  } on Object catch (error) {
    stderr.writeln(
      'Pinkall storage initialization failed: '
      '${storageInitializationDiagnostic(error)}',
    );
    try {
      await backend.dispose();
    } on Object {
      // The initialization failure remains the primary startup diagnostic.
    }
    exitCode = 75;
    return;
  }
  final ApiRouter router = ApiRouter(backend: backend);
  final HttpServer server = await shelf_io.serve(
    router.handler,
    config.host,
    config.port,
  );
  stdout.writeln(
    'Pinkall API listening on http://${server.address.host}:${server.port} '
    '(storage=${backend.store.storageDescription})',
  );

  final Completer<void> shutdown = Completer<void>();
  StreamSubscription<ProcessSignal>? interruptSubscription;
  StreamSubscription<ProcessSignal>? terminateSubscription;
  void requestShutdown(ProcessSignal signal) {
    if (!shutdown.isCompleted) {
      stdout.writeln('Received $signal; shutting down.');
      shutdown.complete();
    }
  }

  interruptSubscription = ProcessSignal.sigint.watch().listen(requestShutdown);
  if (!Platform.isWindows) {
    terminateSubscription = ProcessSignal.sigterm.watch().listen(
      requestShutdown,
    );
  }
  await shutdown.future;
  await server.close(force: false);
  await backend.dispose();
  await interruptSubscription.cancel();
  await terminateSubscription?.cancel();
}

/// Produces a startup diagnostic without serializing connection details.
String storageInitializationDiagnostic(Object error) {
  if (error is DurabilityException) {
    final Object? cause = error.cause;
    return 'DurabilityException(code=${error.code}, '
        'cause=${cause?.runtimeType ?? 'none'})';
  }
  return error.runtimeType.toString();
}
