package com.example.tok_tik

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val iconChannel = "com.toktik.app/icon"
    private val aliases = mapOf(
        "normal" to "MainActivityNormal",
        "halloween" to "MainActivityHalloween",
        "christmas" to "MainActivityChristmas",
        "valentine" to "MainActivityValentine",
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, iconChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "setIcon") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val season = call.arguments as? String
                val aliasToEnable = season?.let(aliases::get)
                if (aliasToEnable == null) {
                    result.error("INVALID_SEASON", "Unknown app icon season.", null)
                    return@setMethodCallHandler
                }

                try {
                    setEnabledAlias(aliasToEnable)
                    result.success(null)
                } catch (error: Exception) {
                    result.error("ICON_UPDATE_FAILED", error.message, null)
                }
            }
    }

    private fun setEnabledAlias(aliasToEnable: String) {
        val packageManager = packageManager
        for (alias in aliases.values) {
            val component = ComponentName(this, "${packageName}.$alias")
            val state = if (alias == aliasToEnable) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                component,
                state,
                PackageManager.DONT_KILL_APP,
            )
        }
    }
}
