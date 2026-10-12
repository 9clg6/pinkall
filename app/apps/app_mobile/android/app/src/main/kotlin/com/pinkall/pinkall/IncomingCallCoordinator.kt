package com.pinkall.pinkall

import android.content.Context
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import com.google.firebase.FirebaseApp
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

internal class IncomingCallCoordinator(
    private val context: Context,
    messenger: BinaryMessenger,
) : EventChannel.StreamHandler, AutoCloseable {
    private val methodChannel = MethodChannel(messenger, METHOD_CHANNEL)
    private val eventChannel = EventChannel(messenger, EVENT_CHANNEL)
    private var eventSink: EventChannel.EventSink? = null

    init {
        methodChannel.setMethodCallHandler(::handleMethodCall)
        eventChannel.setStreamHandler(this)
        shared = this
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(result)
            "getCapability" -> result.success(capability(context))
            "getNotificationToken" -> result.success(notificationToken(context))
            "dispose" -> {
                eventSink = null
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun initialize(result: MethodChannel.Result) {
        if (!featureEnabled(context) || !firebaseConfigured(context)) {
            result.success(capability(context))
            return
        }
        val firebaseApp = runCatching {
            FirebaseApp.getApps(context).firstOrNull() ?: FirebaseApp.initializeApp(context)
        }.getOrNull()
        if (firebaseApp == null) {
            result.success(
                capability(
                    context,
                    runtimeFailure = "Firebase could not initialize from Android resources.",
                ),
            )
            return
        }
        PinkallConnectionService.registerPhoneAccount(context)
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                task.result?.takeIf(String::isNotBlank)?.let { token ->
                    storeToken(context, token)
                }
            }
            result.success(
                capability(
                    context,
                    runtimeFailure = task.exception?.javaClass?.simpleName,
                ),
            )
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
        consumePendingEvent(context)?.let(events::success)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun close() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
        if (shared === this) shared = null
    }

    private fun deliver(event: Map<String, String>) {
        Handler(Looper.getMainLooper()).post {
            val sink = eventSink
            if (sink != null) {
                sink.success(event)
            } else {
                persistPendingEvent(context, event)
            }
        }
    }

    companion object {
        private const val METHOD_CHANNEL = "com.pinkall.incoming_calls/methods"
        private const val EVENT_CHANNEL = "com.pinkall.incoming_calls/events"
        private const val FEATURE_FLAG = "com.pinkall.INCOMING_CALLS_ENABLED"
        private const val PREFERENCES = "pinkall_incoming_calls"
        private const val TOKEN_KEY = "fcm_token"
        private const val PENDING_EVENT_KEY = "pending_event"

        @Volatile
        private var shared: IncomingCallCoordinator? = null

        fun featureEnabled(context: Context): Boolean = runCatching {
            val applicationInfo = context.packageManager.getApplicationInfo(
                context.packageName,
                PackageManager.GET_META_DATA,
            )
            applicationInfo.metaData?.getBoolean(FEATURE_FLAG, false) == true
        }.getOrDefault(false)

        fun firebaseConfigured(context: Context): Boolean =
            context.resources.getIdentifier(
                "google_app_id",
                "string",
                context.packageName,
            ) != 0

        fun notificationToken(context: Context): String? =
            context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                .getString(TOKEN_KEY, null)
                ?.takeIf(String::isNotBlank)

        fun storeToken(context: Context, token: String) {
            if (token.isBlank()) return
            context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                .edit()
                .putString(TOKEN_KEY, token)
                .apply()
            emit(context, mapOf("type" to "tokenUpdated"))
        }

        fun emit(context: Context, event: Map<String, String>) {
            val active = shared
            if (active != null) {
                active.deliver(event)
            } else {
                persistPendingEvent(context, event)
            }
        }

        fun capability(
            context: Context,
            runtimeFailure: String? = null,
        ): Map<String, Any> {
            if (!featureEnabled(context)) {
                return capabilityMap(
                    status = "disabled",
                    tokenAvailable = false,
                    backgroundReady = false,
                    nativeUIReady = false,
                    missing = listOf("android_feature_flag_disabled"),
                    detail = "Enable only after Firebase and Telnyx credentials exist.",
                )
            }
            if (!firebaseConfigured(context)) {
                return capabilityMap(
                    status = "configurationRequired",
                    tokenAvailable = false,
                    backgroundReady = false,
                    nativeUIReady = false,
                    missing = listOf("google_services_json", "firebase_android_app"),
                    detail = "Firebase Android resources are not present in this build.",
                )
            }
            val tokenAvailable = notificationToken(context) != null
            val connectionServiceReady = PinkallConnectionService.isPhoneAccountRegistered(context)
            val backgroundReady = tokenAvailable && connectionServiceReady
            val missing = buildList {
                if (!tokenAvailable) add("fcm_token_pending")
                if (!connectionServiceReady) add("android_phone_account_registration")
                // ConnectionService owns audio/lifecycle only; no fake system UI claim.
                add("android_incoming_call_notification_ui")
                if (runtimeFailure != null) add("firebase_runtime_initialization")
            }
            return capabilityMap(
                status = if (!tokenAvailable && runtimeFailure == null) {
                    "registering"
                } else {
                    "configurationRequired"
                },
                tokenAvailable = tokenAvailable,
                backgroundReady = backgroundReady,
                nativeUIReady = false,
                missing = missing,
                detail = runtimeFailure
                    ?: "FCM and ConnectionService are gated; Android incoming-call UI is not complete.",
            )
        }

        private fun capabilityMap(
            status: String,
            tokenAvailable: Boolean,
            backgroundReady: Boolean,
            nativeUIReady: Boolean,
            missing: List<String>,
            detail: String?,
        ): Map<String, Any> = buildMap {
            put("status", status)
            put("platform", "android")
            put("transport", "fcm")
            put("token_available", tokenAvailable)
            put("background_delivery_ready", backgroundReady)
            put("native_call_ui_ready", nativeUIReady)
            put("missing_requirements", missing)
            if (detail != null) put("detail", detail)
        }

        private fun persistPendingEvent(context: Context, event: Map<String, String>) {
            context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                .edit()
                .putString(PENDING_EVENT_KEY, JSONObject(event).toString())
                .apply()
        }

        private fun consumePendingEvent(context: Context): Map<String, String>? {
            val preferences = context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
            val raw = preferences.getString(PENDING_EVENT_KEY, null) ?: return null
            preferences.edit().remove(PENDING_EVENT_KEY).apply()
            return runCatching {
                val json = JSONObject(raw)
                json.keys().asSequence().associateWith { key -> json.getString(key) }
            }.getOrNull()
        }
    }
}
