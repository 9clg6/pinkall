package com.pinkall.pinkall

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONObject

class PinkallFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        IncomingCallCoordinator.storeToken(applicationContext, token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        if (!IncomingCallCoordinator.featureEnabled(applicationContext)) return
        val metadata = metadata(message.data) ?: return
        val callID = metadata["call_id"]?.takeIf(String::isNotBlank) ?: return
        val callerName = metadata["caller_name"]?.takeIf(String::isNotBlank)
        val callerNumber = metadata["caller_number"]?.takeIf(String::isNotBlank)
        val voiceSdkID = metadata["voice_sdk_id"]?.takeIf(String::isNotBlank)
        val event = buildMap {
            put("type", "incomingCall")
            put("call_id", callID)
            if (callerName != null) put("caller_name", callerName)
            if (callerNumber != null) put("caller_number", callerNumber)
            if (voiceSdkID != null) put("voice_sdk_id", voiceSdkID)
        }
        IncomingCallCoordinator.emit(applicationContext, event)
        PinkallConnectionService.reportIncomingCall(
            context = applicationContext,
            callID = callID,
            callerName = callerName,
            callerNumber = callerNumber,
        )
    }

    private fun metadata(data: Map<String, String>): Map<String, String>? {
        val encoded = data["metadata"]
        if (encoded.isNullOrBlank()) return data
        return runCatching {
            val json = JSONObject(encoded)
            json.keys().asSequence().associateWith { key -> json.optString(key) }
        }.getOrNull()
    }
}
