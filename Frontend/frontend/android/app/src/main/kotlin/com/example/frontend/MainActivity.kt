package com.example.frontend

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "parking_widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidget" -> {
                    val availableSlots = call.argument<Int>("availableSlots") ?: 0
                    val totalSlots = call.argument<Int>("totalSlots") ?: 0
                    WidgetUpdateHelper.updateWidget(this, availableSlots, totalSlots)
                    result.success("Widget updated")
                }
                "hasActiveWidgets" -> {
                    result.success(hasActiveWidgets())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasActiveWidgets(): Boolean {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val componentName = ComponentName(this, ParkingWidget::class.java)
        return appWidgetManager.getAppWidgetIds(componentName).isNotEmpty()
    }
}