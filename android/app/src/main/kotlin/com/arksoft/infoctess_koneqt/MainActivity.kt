package com.arksoft.infoctess_koneqt

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
class MainActivity: FlutterActivity() {
    // private val CHANNEL = "samples.flutter.dev/battery"
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
    //         if (call.method == "getBatteryLevel") {
    //             val batteryLevel = getBatteryLevel()
    //             if (batteryLevel != -1) {
    //                 result.success(batteryLevel)
    //             } else {
    //                 result.error("UNAVAILABLE", "Battery level not available.", null)
    //             }
    //         } else {
    //             result.notImplemented()
    //         }
    //     }
    // }
    // private fun getBatteryLevel(): Int {
    //     val batteryLevel: Int
    //     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
    //         val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
    //         batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    //     } else {
    //         val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    //         batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    //     }
    //     return batteryLevel
    // }
}
