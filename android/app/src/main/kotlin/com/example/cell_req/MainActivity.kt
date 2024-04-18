package com.example.cell_req

import android.content.pm.PackageManager
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest // Import statement for MessageDigest

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.cell_req/signature"
    private val KNOWN_SHA256_FINGERPRINT = "AwUJFAMZ5r6Pxwcdr9lWaYxwb0exrZoQUlJrO1CtjRU="

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {
                "checkAppSignature" -> {
                    val isSignatureValid = checkAppSignature()
                    result.success(isSignatureValid)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun checkAppSignature(): Boolean {
        try {
            val packageInfo =
                    packageManager.getPackageInfo(
                            packageName,
                            PackageManager.GET_SIGNING_CERTIFICATES
                    )
            val signatures = packageInfo.signingInfo.apkContentsSigners
            for (signature in signatures) {
                val messageDigest = MessageDigest.getInstance("SHA-256")
                val sha256Digest = messageDigest.digest(signature.toByteArray())

                val base64String = Base64.encodeToString(sha256Digest, Base64.NO_WRAP)

                println("Known fingerprint Base64: $KNOWN_SHA256_FINGERPRINT")
                println("Extracted fingerprint Base64: $base64String")

                if (KNOWN_SHA256_FINGERPRINT.equals(base64String, ignoreCase = true)) {
                    return true
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return false
    }
}
