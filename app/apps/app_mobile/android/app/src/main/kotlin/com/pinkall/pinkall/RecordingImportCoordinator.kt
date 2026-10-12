package com.pinkall.pinkall

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.provider.OpenableColumns
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.ArrayDeque
import java.util.UUID
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

internal class RecordingImportCoordinator(
    private val activity: FlutterActivity,
) : AutoCloseable {
    private val pendingActions = ArrayDeque<PendingRecordingAction>()
    private val pendingActionsLock = Any()
    private val importExecutor: ExecutorService = Executors.newSingleThreadExecutor()

    private var consumeInFlight = false
    private var pickerResult: MethodChannel.Result? = null
    private var directImportInFlight = false

    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_CONSUME_PENDING_ACTION -> consumePendingAction(result)
            METHOD_PICK_RECORDING -> pickRecording(result)
            METHOD_DISCARD_IMPORT -> {
                call.argument<String>(ARGUMENT_ID)?.let(::discardImport)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    fun enqueueIntent(incomingIntent: Intent?) {
        val action = incomingIntent?.let(::toPendingAction) ?: return
        synchronized(pendingActionsLock) {
            pendingActions.addLast(action)
        }
    }

    override fun close() {
        pickerResult?.error(
            ERROR_IMPORT_IO_FAILURE,
            "The recording picker was interrupted.",
            null,
        )
        pickerResult = null
        importExecutor.shutdownNow()
    }

    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_PICK_RECORDING) return false
        val result = pickerResult ?: return true
        pickerResult = null
        if (resultCode != Activity.RESULT_OK) {
            result.success(null)
            return true
        }
        val uri = data?.data
        if (uri == null) {
            result.error(
                ERROR_IMPORT_IO_FAILURE,
                "The selected recording is unavailable.",
                null,
            )
            return true
        }
        importPickedAudioFile(
            PendingRecordingAction.AudioFile(uri, data.type),
            result,
        )
        return true
    }

    private fun toPendingAction(incomingIntent: Intent): PendingRecordingAction? =
        when (incomingIntent.action) {
            ACTION_PICK_RECORDING -> PendingRecordingAction.PickRecording
            Intent.ACTION_SEND -> incomingIntent.sharedAudioUri()?.let { uri ->
                uri.toSupportedAudioAction(incomingIntent.type)
            }
            Intent.ACTION_VIEW -> incomingIntent.data?.let { uri ->
                uri.toSupportedAudioAction(incomingIntent.type)
            }
            else -> null
        }

    private fun Uri.toSupportedAudioAction(
        hintedMimeType: String?,
    ): PendingRecordingAction.AudioFile? {
        if (!RecordingImportPolicy.isLocalImportScheme(scheme)) return null
        val resolverMimeType = runCatching {
            activity.contentResolver.getType(this)
        }.getOrNull()
        val mimeType = RecordingImportPolicy.resolveSupportedImportMimeType(
            uriScheme = scheme,
            resolverMimeType = resolverMimeType,
            hintedMimeType = hintedMimeType,
        ) ?: return null
        return PendingRecordingAction.AudioFile(this, mimeType)
    }

    private fun consumePendingAction(result: MethodChannel.Result) {
        synchronized(pendingActionsLock) {
            if (consumeInFlight) {
                result.success(null)
                return
            }
            consumeInFlight = true
        }
        consumeNextPendingAction(result)
    }

    private fun pickRecording(result: MethodChannel.Result) {
        if (pickerResult != null || isImportBusy()) {
            result.error(
                ERROR_IMPORT_IO_FAILURE,
                "Another recording import is already in progress.",
                null,
            )
            return
        }
        pickerResult = result
        val pickerIntent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "audio/*"
            putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf(
                    "audio/aac",
                    "audio/flac",
                    "audio/mp4",
                    "audio/mpeg",
                    "audio/ogg",
                    "audio/opus",
                    "audio/wav",
                    "audio/webm",
                ),
            )
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        try {
            activity.startActivityForResult(pickerIntent, REQUEST_PICK_RECORDING)
        } catch (_: RuntimeException) {
            pickerResult = null
            result.error(
                ERROR_IMPORT_IO_FAILURE,
                "The recording picker could not be opened.",
                null,
            )
        }
    }

    private fun isImportBusy(): Boolean = synchronized(pendingActionsLock) {
        consumeInFlight || directImportInFlight
    }

    private fun consumeNextPendingAction(result: MethodChannel.Result) {
        val pendingAction = synchronized(pendingActionsLock) {
            pendingActions.pollFirst()
        }
        when (pendingAction) {
            null -> completeConsumption(result, null)
            PendingRecordingAction.PickRecording -> completeConsumption(
                result,
                mapOf(KEY_KIND to KIND_PICK_RECORDING),
            )
            is PendingRecordingAction.AudioFile -> importAudioFile(pendingAction, result)
        }
    }

    private fun importAudioFile(
        action: PendingRecordingAction.AudioFile,
        result: MethodChannel.Result,
    ) {
        importExecutor.execute {
            val importResult = runCatching { copyIntoPrivateCache(action) }
                .onFailure { error ->
                    // Provider exceptions can include the original URI. Keep it out of logs.
                    Log.w(TAG, "Rejected recording import (${error.javaClass.simpleName})")
                }
            activity.runOnUiThread {
                importResult.fold(
                    onSuccess = { importedFile ->
                        completeConsumption(result, importedFile.toChannelMap())
                    },
                    onFailure = { error ->
                        completeConsumptionWithError(result, error)
                    },
                )
            }
        }
    }

    private fun importPickedAudioFile(
        action: PendingRecordingAction.AudioFile,
        result: MethodChannel.Result,
    ) {
        synchronized(pendingActionsLock) {
            directImportInFlight = true
        }
        importExecutor.execute {
            val importResult = runCatching { copyIntoPrivateCache(action) }
                .onFailure { error ->
                    Log.w(TAG, "Rejected picked recording (${error.javaClass.simpleName})")
                }
            activity.runOnUiThread {
                synchronized(pendingActionsLock) {
                    directImportInFlight = false
                }
                importResult.fold(
                    onSuccess = { importedFile -> result.success(importedFile.toChannelMap()) },
                    onFailure = { error -> completeDirectImportWithError(result, error) },
                )
            }
        }
    }

    private fun completeDirectImportWithError(
        result: MethodChannel.Result,
        error: Throwable,
    ) {
        val rejection = error as? RecordingImportRejection
        result.error(
            rejection?.code ?: ERROR_IMPORT_IO_FAILURE,
            rejection?.safeMessage ?: "Unable to create the private recording copy.",
            null,
        )
    }

    private fun completeConsumption(result: MethodChannel.Result, value: Any?) {
        synchronized(pendingActionsLock) {
            consumeInFlight = false
        }
        result.success(value)
    }

    private fun completeConsumptionWithError(
        result: MethodChannel.Result,
        error: Throwable,
    ) {
        synchronized(pendingActionsLock) {
            consumeInFlight = false
        }
        val rejection = error as? RecordingImportRejection
        result.error(
            rejection?.code ?: ERROR_IMPORT_IO_FAILURE,
            rejection?.safeMessage ?: "Unable to create the private recording copy.",
            null,
        )
    }

    private fun copyIntoPrivateCache(action: PendingRecordingAction.AudioFile): ImportedRecording {
        val mimeType = resolveValidatedMimeType(action)
        val metadata = queryMetadata(action.uri)
        validateDeclaredSize(metadata.sizeBytes)

        val id = UUID.randomUUID().toString()
        val extension = RecordingImportPolicy.extensionForMimeType(mimeType)
        val destination = createDestination(id, extension)
        try {
            copyWithLimit(action.uri, destination.partialFile)
            check(destination.partialFile.renameTo(destination.importedFile)) {
                "Unable to finalize recording import"
            }
            validateNonEmpty(destination.importedFile)
            return ImportedRecording(
                id = id,
                displayName = RecordingImportPolicy.sanitizeDisplayName(
                    metadata.displayName,
                    extension,
                ),
                mimeType = mimeType,
                file = destination.importedFile,
            )
        } catch (error: Throwable) {
            destination.partialFile.delete()
            destination.importedFile.delete()
            throw error
        }
    }

    private fun resolveValidatedMimeType(action: PendingRecordingAction.AudioFile): String {
        if (!RecordingImportPolicy.isLocalImportScheme(action.uri.scheme)) {
            throw RecordingImportRejection(
                ERROR_UNSUPPORTED_AUDIO,
                "The shared recording source is unsupported.",
            )
        }
        val resolverMimeType = runCatching {
            activity.contentResolver.getType(action.uri)
        }.getOrNull()
        val mimeType = RecordingImportPolicy.resolveSupportedImportMimeType(
            uriScheme = action.uri.scheme,
            resolverMimeType = resolverMimeType,
            hintedMimeType = action.hintedMimeType,
        )
        if (mimeType == null) {
            throw RecordingImportRejection(
                ERROR_UNSUPPORTED_AUDIO,
                "Only audio recordings can be imported.",
            )
        }
        return mimeType
    }

    private fun validateDeclaredSize(declaredSize: Long?) {
        if (declaredSize != null &&
            declaredSize >= 0L &&
            declaredSize > RecordingImportPolicy.MAX_IMPORT_BYTES
        ) {
            throw RecordingImportRejection(
                ERROR_RECORDING_TOO_LARGE,
                "The recording exceeds the 200 MiB import limit.",
            )
        }
    }

    private fun createDestination(id: String, extension: String): ImportDestination {
        val importDirectory = File(activity.cacheDir, IMPORT_DIRECTORY_NAME).apply {
            check(exists() || mkdirs()) { "Unable to create recording import cache" }
        }
        return ImportDestination(
            partialFile = File(importDirectory, "$id.partial"),
            importedFile = File(importDirectory, "$id.$extension"),
        )
    }

    private fun copyWithLimit(uri: Uri, destination: File) {
        val inputStream = activity.contentResolver.openInputStream(uri)
            ?: error("Unable to open recording")
        inputStream.use { input ->
            FileOutputStream(destination).use { output ->
                val buffer = ByteArray(COPY_BUFFER_SIZE)
                var copiedBytes = 0L
                while (true) {
                    val byteCount = input.read(buffer)
                    if (byteCount < 0) break
                    copiedBytes += byteCount
                    if (copiedBytes > RecordingImportPolicy.MAX_IMPORT_BYTES) {
                        throw RecordingImportRejection(
                            ERROR_RECORDING_TOO_LARGE,
                            "The recording exceeds the 200 MiB import limit.",
                        )
                    }
                    output.write(buffer, 0, byteCount)
                }
                output.fd.sync()
            }
        }
    }

    private fun validateNonEmpty(importedFile: File) {
        if (importedFile.length() <= 0L) {
            throw RecordingImportRejection(
                ERROR_UNSUPPORTED_AUDIO,
                "The shared audio recording is empty.",
            )
        }
    }

    private fun queryMetadata(uri: Uri): RecordingMetadata {
        var cursor: Cursor? = null
        return try {
            cursor = activity.contentResolver.query(
                uri,
                arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE),
                null,
                null,
                null,
            )
            if (cursor?.moveToFirst() != true) return RecordingMetadata()
            val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            val sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE)
            RecordingMetadata(
                displayName = nameIndex.takeIf { it >= 0 }?.let(cursor::getString),
                sizeBytes = sizeIndex.takeIf { it >= 0 && !cursor.isNull(it) }
                    ?.let(cursor::getLong),
            )
        } catch (_: RuntimeException) {
            // Some document providers omit metadata. The streaming limit stays authoritative.
            RecordingMetadata()
        } finally {
            cursor?.close()
        }
    }

    private fun discardImport(id: String): Boolean {
        if (!RecordingImportPolicy.isSafeImportId(id)) return false
        val importDirectory = File(activity.cacheDir, IMPORT_DIRECTORY_NAME)
        val canonicalDirectory = runCatching { importDirectory.canonicalFile }.getOrNull()
            ?: return false
        val candidates = importDirectory.listFiles().orEmpty().filter { file ->
            file.isFile && (file.name == id || file.name.startsWith("$id."))
        }
        return candidates.fold(false) { deletedAny, file ->
            val isAppOwned = runCatching {
                file.canonicalFile.parentFile == canonicalDirectory
            }.getOrDefault(false)
            (isAppOwned && file.delete()) || deletedAny
        }
    }

    @Suppress("DEPRECATION")
    private fun Intent.sharedAudioUri(): Uri? {
        val streamUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            getParcelableExtra(Intent.EXTRA_STREAM)
        }
        return streamUri ?: clipData?.takeIf { it.itemCount > 0 }?.getItemAt(0)?.uri
    }

    private sealed interface PendingRecordingAction {
        data object PickRecording : PendingRecordingAction

        data class AudioFile(
            val uri: Uri,
            val hintedMimeType: String?,
        ) : PendingRecordingAction
    }

    private data class RecordingMetadata(
        val displayName: String? = null,
        val sizeBytes: Long? = null,
    )

    private data class ImportDestination(
        val partialFile: File,
        val importedFile: File,
    )

    private data class ImportedRecording(
        val id: String,
        val displayName: String,
        val mimeType: String,
        val file: File,
    ) {
        fun toChannelMap(): Map<String, Any> = mapOf(
            KEY_KIND to KIND_AUDIO_FILE,
            KEY_ID to id,
            KEY_NAME to displayName,
            KEY_MIME_TYPE to mimeType,
            KEY_PATH to file.absolutePath,
            KEY_SIZE_BYTES to file.length(),
        )
    }

    private class RecordingImportRejection(
        val code: String,
        val safeMessage: String,
    ) : Exception()

    private companion object {
        const val TAG = "PinkallRecordingImport"
        const val METHOD_CONSUME_PENDING_ACTION = "consumePendingAction"
        const val METHOD_PICK_RECORDING = "pickRecording"
        const val METHOD_DISCARD_IMPORT = "discardImport"
        const val ARGUMENT_ID = "id"

        const val ACTION_PICK_RECORDING = "com.pinkall.pinkall.action.PICK_RECORDING"
        const val REQUEST_PICK_RECORDING = 0x504B
        const val IMPORT_DIRECTORY_NAME = "recording_imports"
        const val COPY_BUFFER_SIZE = 64 * 1024

        const val KEY_KIND = "kind"
        const val KEY_ID = "id"
        const val KEY_NAME = "name"
        const val KEY_MIME_TYPE = "mime_type"
        const val KEY_PATH = "path"
        const val KEY_SIZE_BYTES = "size_bytes"
        const val KIND_PICK_RECORDING = "pick_recording"
        const val KIND_AUDIO_FILE = "audio_file"

        const val ERROR_UNSUPPORTED_AUDIO = "unsupported_audio"
        const val ERROR_RECORDING_TOO_LARGE = "recording_too_large"
        const val ERROR_IMPORT_IO_FAILURE = "import_io_failure"
    }
}
