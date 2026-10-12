package com.pinkall.pinkall

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class RecordingImportPolicyTest {
    @Test
    fun acceptsOnlyAudioMimeTypes() {
        assertTrue(RecordingImportPolicy.isAudioMime("audio/mp4"))
        assertTrue(RecordingImportPolicy.isAudioMime(" Audio/WAV "))
        assertTrue(RecordingImportPolicy.isAudioMime("audio/opus"))
        assertFalse(RecordingImportPolicy.isAudioMime("audio/3gpp"))
        assertFalse(RecordingImportPolicy.isAudioMime("audio/custom"))
        assertFalse(RecordingImportPolicy.isAudioMime("video/mp4"))
        assertFalse(RecordingImportPolicy.isAudioMime(null))
    }

    @Test
    fun acceptsOnlyLocalRecordingSources() {
        assertTrue(RecordingImportPolicy.isLocalImportScheme("content"))
        assertTrue(RecordingImportPolicy.isLocalImportScheme(" FILE "))
        assertFalse(RecordingImportPolicy.isLocalImportScheme("pinkall"))
        assertFalse(RecordingImportPolicy.isLocalImportScheme("https"))
        assertFalse(RecordingImportPolicy.isLocalImportScheme(null))
    }

    @Test
    fun resolvesOnlySupportedLocalAudioImports() {
        assertEquals(
            "audio/mp4",
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "content",
                resolverMimeType = " Audio/MP4; codecs=mp4a.40.2 ",
                hintedMimeType = null,
            ),
        )
        assertEquals(
            "audio/mpeg",
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "file",
                resolverMimeType = null,
                hintedMimeType = "audio/mpeg",
            ),
        )
        assertNull(
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "pinkall",
                resolverMimeType = null,
                hintedMimeType = "audio/mpeg",
            ),
        )
        assertNull(
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "https",
                resolverMimeType = "audio/mp4",
                hintedMimeType = "audio/mp4",
            ),
        )
        assertNull(
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "content",
                resolverMimeType = "video/mp4",
                hintedMimeType = "audio/mp4",
            ),
        )
        assertNull(
            RecordingImportPolicy.resolveSupportedImportMimeType(
                uriScheme = "content",
                resolverMimeType = null,
                hintedMimeType = "audio/*",
            ),
        )
    }

    @Test
    fun sanitizesUntrustedDisplayNamesWithoutLosingReadableText() {
        assertEquals(
            "appel _ client_.m4a",
            RecordingImportPolicy.sanitizeDisplayName("../appel \u0000 client?.m4a", "m4a"),
        )
        assertEquals(
            "enregistrement.wav",
            RecordingImportPolicy.sanitizeDisplayName("../", "wav"),
        )
        assertEquals(
            "appel-client.mp3",
            RecordingImportPolicy.sanitizeDisplayName("appel-client", "mp3"),
        )
    }

    @Test
    fun mapsCommonAudioMimeTypesToSafeExtensions() {
        assertEquals("m4a", RecordingImportPolicy.extensionForMimeType("audio/mp4"))
        assertEquals("mp3", RecordingImportPolicy.extensionForMimeType("audio/mpeg"))
        assertEquals("opus", RecordingImportPolicy.extensionForMimeType("audio/opus"))
        assertEquals("audio", RecordingImportPolicy.extensionForMimeType("audio/custom"))
    }

    @Test
    fun acceptsOnlyCanonicalUuidImportIdentifiers() {
        assertTrue(RecordingImportPolicy.isSafeImportId("b6c47c8f-cd24-4c85-9f4a-8d5be96d522d"))
        assertFalse(RecordingImportPolicy.isSafeImportId("../../files"))
        assertFalse(RecordingImportPolicy.isSafeImportId("B6C47C8F-CD24-4C85-9F4A-8D5BE96D522D"))
    }
}
