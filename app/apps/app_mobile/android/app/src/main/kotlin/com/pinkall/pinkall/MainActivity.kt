package com.pinkall.pinkall

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var recordingImportChannel: MethodChannel? = null
    private var recordingImportCoordinator: RecordingImportCoordinator? = null
    private var incomingCallCoordinator: IncomingCallCoordinator? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        recordingImportCoordinator?.close()
        val coordinator = RecordingImportCoordinator(this)
        recordingImportCoordinator = coordinator
        recordingImportChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            RECORDING_IMPORT_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler(coordinator::handleMethodCall)
        }
        coordinator.enqueueIntent(intent)
        incomingCallCoordinator?.close()
        incomingCallCoordinator = IncomingCallCoordinator(
            applicationContext,
            flutterEngine.dartExecutor.binaryMessenger,
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        recordingImportChannel?.setMethodCallHandler(null)
        recordingImportChannel = null
        recordingImportCoordinator?.close()
        recordingImportCoordinator = null
        incomingCallCoordinator?.close()
        incomingCallCoordinator = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        // Flutter and installed plugins must receive every incoming intent as well.
        super.onNewIntent(intent)
        setIntent(intent)
        recordingImportCoordinator?.enqueueIntent(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (recordingImportCoordinator?.handleActivityResult(requestCode, resultCode, data) == true) {
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onDestroy() {
        recordingImportCoordinator?.close()
        recordingImportCoordinator = null
        incomingCallCoordinator?.close()
        incomingCallCoordinator = null
        super.onDestroy()
    }

    private companion object {
        const val RECORDING_IMPORT_CHANNEL = "com.pinkall.recording_import/methods"
    }
}
