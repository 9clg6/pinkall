package com.pinkall.pinkall

import java.util.UUID

internal object RecordingImportPolicy {
    const val MAX_IMPORT_BYTES: Long = 200L * 1024L * 1024L

    private const val DEFAULT_DISPLAY_NAME = "enregistrement"
    private const val MAX_DISPLAY_NAME_LENGTH = 120
    private val unsafeDisplayNameCharacters = Regex("[^\\p{L}\\p{N}._() \\-]")
    private val repeatedWhitespace = Regex("\\s+")
    private val localImportSchemes = setOf("content", "file")
    private val supportedMimeTypes = setOf(
        "audio/aac",
        "audio/flac",
        "audio/m4a",
        "audio/mp3",
        "audio/mp4",
        "audio/mpeg",
        "audio/ogg",
        "audio/opus",
        "audio/vnd.wave",
        "audio/wav",
        "audio/wave",
        "audio/webm",
        "audio/x-aac",
        "audio/x-flac",
        "audio/x-m4a",
        "audio/x-wav",
    )

    fun isLocalImportScheme(scheme: String?): Boolean =
        scheme?.trim()?.lowercase() in localImportSchemes

    fun resolveSupportedImportMimeType(
        uriScheme: String?,
        resolverMimeType: String?,
        hintedMimeType: String?,
    ): String? {
        if (!isLocalImportScheme(uriScheme)) return null
        val mimeType = normalizeMimeType(resolverMimeType) ?: normalizeMimeType(hintedMimeType)
        return mimeType?.takeIf(supportedMimeTypes::contains)
    }

    fun isAudioMime(mimeType: String?): Boolean =
        normalizeMimeType(mimeType) in supportedMimeTypes

    fun extensionForMimeType(mimeType: String?): String = when (mimeType?.lowercase()) {
        "audio/aac", "audio/x-aac" -> "aac"
        "audio/flac", "audio/x-flac" -> "flac"
        "audio/mp4", "audio/x-m4a" -> "m4a"
        "audio/mpeg", "audio/mp3" -> "mp3"
        "audio/ogg" -> "ogg"
        "audio/opus" -> "opus"
        "audio/wav", "audio/x-wav", "audio/wave", "audio/vnd.wave" -> "wav"
        "audio/webm" -> "webm"
        else -> "audio"
    }

    fun sanitizeDisplayName(rawName: String?, fallbackExtension: String): String {
        val normalized = rawName
            ?.replace('\\', '_')
            ?.replace('/', '_')
            ?.replace(unsafeDisplayNameCharacters, "_")
            ?.replace(repeatedWhitespace, " ")
            ?.trim(' ', '.', '_')
            ?.take(MAX_DISPLAY_NAME_LENGTH)
            ?.trimEnd(' ', '.')
            .orEmpty()
        if (normalized.isNotBlank() && normalized != "." && normalized != "..") {
            return if (normalized.lowercase().endsWith(".${fallbackExtension.lowercase()}")) {
                normalized
            } else {
                "$normalized.$fallbackExtension"
            }
        }
        return "$DEFAULT_DISPLAY_NAME.$fallbackExtension"
    }

    fun isSafeImportId(id: String): Boolean = runCatching {
        UUID.fromString(id).toString() == id
    }.getOrDefault(false)

    private fun normalizeMimeType(mimeType: String?): String? = mimeType
        ?.substringBefore(';')
        ?.trim()
        ?.lowercase()
        ?.takeIf(String::isNotBlank)
}
