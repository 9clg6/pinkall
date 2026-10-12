package com.pinkall.pinkall

import android.Manifest
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.telecom.Connection
import android.telecom.ConnectionRequest
import android.telecom.ConnectionService
import android.telecom.DisconnectCause
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager

class PinkallConnectionService : ConnectionService() {
    override fun onCreateIncomingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest,
    ): Connection {
        val extras = request.extras.getBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS)
            ?: request.extras
        val callID = extras.getString(EXTRA_CALL_ID).orEmpty()
        val callerName = extras.getString(EXTRA_CALLER_NAME)
        val callerNumber = extras.getString(EXTRA_CALLER_NUMBER)
        return PinkallIncomingConnection(
            context = applicationContext,
            callID = callID,
            callerName = callerName,
            callerNumber = callerNumber,
        )
    }

    companion object {
        private const val PHONE_ACCOUNT_ID = "pinkall_voip"
        private const val EXTRA_CALL_ID = "com.pinkall.extra.CALL_ID"
        private const val EXTRA_CALLER_NAME = "com.pinkall.extra.CALLER_NAME"
        private const val EXTRA_CALLER_NUMBER = "com.pinkall.extra.CALLER_NUMBER"

        private fun phoneAccountHandle(context: Context) = PhoneAccountHandle(
            ComponentName(context, PinkallConnectionService::class.java),
            PHONE_ACCOUNT_ID,
        )

        fun registerPhoneAccount(context: Context): Boolean {
            if (
                context.checkSelfPermission(Manifest.permission.MANAGE_OWN_CALLS) !=
                PackageManager.PERMISSION_GRANTED
            ) return false
            val telecom = context.getSystemService(TelecomManager::class.java) ?: return false
            return runCatching {
                val account = PhoneAccount.builder(
                    phoneAccountHandle(context),
                    "Pinkall",
                ).setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED).build()
                telecom.registerPhoneAccount(account)
                true
            }.getOrDefault(false)
        }

        fun isPhoneAccountRegistered(context: Context): Boolean {
            val telecom = context.getSystemService(TelecomManager::class.java) ?: return false
            return runCatching {
                telecom.getPhoneAccount(phoneAccountHandle(context)) != null
            }.getOrDefault(false)
        }

        fun reportIncomingCall(
            context: Context,
            callID: String,
            callerName: String?,
            callerNumber: String?,
        ): Boolean {
            if (!IncomingCallCoordinator.featureEnabled(context)) return false
            if (!registerPhoneAccount(context)) return false
            val telecom = context.getSystemService(TelecomManager::class.java) ?: return false
            val callExtras = Bundle().apply {
                putString(EXTRA_CALL_ID, callID)
                putString(EXTRA_CALLER_NAME, callerName)
                putString(EXTRA_CALLER_NUMBER, callerNumber)
            }
            val extras = Bundle().apply {
                putParcelable(
                    TelecomManager.EXTRA_INCOMING_CALL_ADDRESS,
                    Uri.fromParts("tel", callerNumber ?: "unknown", null),
                )
                putBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS, callExtras)
            }
            return runCatching {
                telecom.addNewIncomingCall(phoneAccountHandle(context), extras)
                true
            }.getOrDefault(false)
        }
    }
}

private class PinkallIncomingConnection(
    private val context: Context,
    private val callID: String,
    callerName: String?,
    callerNumber: String?,
) : Connection() {
    private var answered = false

    init {
        connectionProperties = PROPERTY_SELF_MANAGED
        audioModeIsVoip = true
        setAddress(
            Uri.fromParts("tel", callerNumber ?: "unknown", null),
            TelecomManager.PRESENTATION_ALLOWED,
        )
        setCallerDisplayName(
            callerName ?: callerNumber ?: "Pinkall",
            TelecomManager.PRESENTATION_ALLOWED,
        )
        setRinging()
    }

    override fun onAnswer() {
        answered = true
        IncomingCallCoordinator.emit(
            context,
            mapOf("type" to "answerRequested", "call_id" to callID),
        )
        setActive()
    }

    override fun onReject() {
        decline()
    }

    override fun onDisconnect() {
        if (!answered) {
            IncomingCallCoordinator.emit(
                context,
                mapOf("type" to "declineRequested", "call_id" to callID),
            )
        }
        setDisconnected(DisconnectCause(DisconnectCause.LOCAL))
        destroy()
    }

    private fun decline() {
        IncomingCallCoordinator.emit(
            context,
            mapOf("type" to "declineRequested", "call_id" to callID),
        )
        setDisconnected(DisconnectCause(DisconnectCause.REJECTED))
        destroy()
    }
}
