package com.pinkall.pinkall

import java.io.File
import javax.xml.parsers.DocumentBuilderFactory
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.w3c.dom.Element

class DeepLinkManifestTest {
    private val mainActivity: Element by lazy {
        val workingDirectory = File(requireNotNull(System.getProperty("user.dir")))
        val manifestFile = listOf(
            File(workingDirectory, "src/main/AndroidManifest.xml"),
            File(workingDirectory, "app/src/main/AndroidManifest.xml"),
        ).firstOrNull(File::isFile)
            ?: error("Unable to find the Android app manifest from $workingDirectory")
        val document = DocumentBuilderFactory.newInstance().apply {
            isNamespaceAware = true
        }.newDocumentBuilder().parse(manifestFile)

        document.getElementsByTagName("activity").elements()
            .firstOrNull { it.androidAttribute("name") == ".MainActivity" }
            ?: error("MainActivity is missing from the Android manifest")
    }

    @Test
    fun delegatesDeepLinksExclusivelyToAppLinks() {
        val deepLinkingMetaData = mainActivity.getElementsByTagName("meta-data")
            .elements()
            .firstOrNull {
                it.androidAttribute("name") == "flutter_deeplinking_enabled"
            }

        assertNotNull(deepLinkingMetaData)
        assertEquals("false", deepLinkingMetaData?.androidAttribute("value"))
    }

    @Test
    fun registersPinkallAndVerifiedHttpsCallLinks() {
        val filters = mainActivity.getElementsByTagName("intent-filter").elements()
        val customSchemeFilter = filters.firstOrNull {
            it.hasViewAction() &&
                it.hasRequiredLinkCategories() &&
                it.dataElements().any { data ->
                    data.androidAttribute("scheme") == "pinkall" &&
                        data.androidAttribute("host") == "call"
                }
        }
        assertNotNull(customSchemeFilter)

        val httpsFilter = filters.firstOrNull {
            it.androidAttribute("autoVerify") == "true" &&
                it.hasViewAction() &&
                it.hasRequiredLinkCategories() &&
                it.dataElements().any { data ->
                    data.androidAttribute("scheme") == "https" &&
                        data.androidAttribute("host") == "www.pinkall.app" &&
                        data.androidAttribute("path") == "/call"
                }
        }
        assertNotNull("Missing verified HTTPS deep link for www.pinkall.app", httpsFilter)
        assertTrue(
            "The redirecting apex host must not participate in verification",
            filters.none { filter ->
                filter.androidAttribute("autoVerify") == "true" &&
                    filter.dataElements().any { data ->
                        data.androidAttribute("host") == "pinkall.app"
                    }
            },
        )
    }

    @Test
    fun keepsExistingAudioImportIntents() {
        val filters = mainActivity.getElementsByTagName("intent-filter").elements()

        listOf(
            "android.intent.action.SEND",
            "android.intent.action.VIEW",
        ).forEach { action ->
            assertTrue(
                "Missing audio import filter for $action",
                filters.any {
                    it.hasAction(action) &&
                        it.hasCategory("android.intent.category.DEFAULT") &&
                        it.dataElements().any { data ->
                            data.androidAttribute("mimeType") == "audio/*"
                        }
                },
            )
        }
    }

    private fun Element.hasViewAction(): Boolean =
        hasAction("android.intent.action.VIEW")

    private fun Element.hasRequiredLinkCategories(): Boolean =
        hasCategory("android.intent.category.DEFAULT") &&
            hasCategory("android.intent.category.BROWSABLE")

    private fun Element.hasAction(name: String): Boolean =
        getElementsByTagName("action").elements()
            .any { it.androidAttribute("name") == name }

    private fun Element.hasCategory(name: String): Boolean =
        getElementsByTagName("category").elements()
            .any { it.androidAttribute("name") == name }

    private fun Element.dataElements(): List<Element> =
        getElementsByTagName("data").elements()

    private fun Element.androidAttribute(name: String): String =
        getAttributeNS(ANDROID_NAMESPACE, name)

    private fun org.w3c.dom.NodeList.elements(): List<Element> =
        (0 until length).mapNotNull { item(it) as? Element }

    private companion object {
        const val ANDROID_NAMESPACE = "http://schemas.android.com/apk/res/android"
    }
}
