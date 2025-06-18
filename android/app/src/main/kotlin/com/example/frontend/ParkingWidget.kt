package com.example.frontend

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.content.ComponentName

class ParkingWidget : AppWidgetProvider() {
    
    companion object {
        private const val PREFS_NAME = "parking_widget_prefs"
        private const val PREF_AVAILABLE_SLOTS = "available_slots"
        private const val PREF_TOTAL_SLOTS = "total_slots"
        private const val PREF_LAST_UPDATE = "last_update"
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { updateAppWidget(context, appWidgetManager, it) }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val views = RemoteViews(context.packageName, R.layout.widget_layout) // Changed to widget_layout

        // Update widget views
        views.setTextViewText(R.id.available_slots, prefs.getInt(PREF_AVAILABLE_SLOTS, 0).toString())
        views.setTextViewText(R.id.total_slots, "/${prefs.getInt(PREF_TOTAL_SLOTS, 0)}")
        views.setTextViewText(R.id.last_update, formatLastUpdate(prefs.getLong(PREF_LAST_UPDATE, 0)))

        // Set click intents
        views.setOnClickPendingIntent(R.id.widget_container, 
            PendingIntent.getActivity(
                context, 0, 
                Intent(context, MainActivity::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        )

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun formatLastUpdate(timestamp: Long): String {
        return if (timestamp > 0) {
            val minutes = (System.currentTimeMillis() - timestamp) / (1000 * 60)
            when {
                minutes < 1 -> "Just now"
                minutes < 60 -> "${minutes}m ago"
                else -> "${minutes / 60}h ago"
            }
        } else "No data"
    }
}

class WidgetUpdateHelper {
    companion object {
        fun updateWidget(context: Context, availableSlots: Int, totalSlots: Int) {
            context.getSharedPreferences("parking_widget_prefs", Context.MODE_PRIVATE).edit().apply {
                putInt("available_slots", availableSlots)
                putInt("total_slots", totalSlots)
                putLong("last_update", System.currentTimeMillis())
                apply()
            }

            val intent = Intent(context, ParkingWidget::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, 
                    AppWidgetManager.getInstance(context)
                        .getAppWidgetIds(ComponentName(context, ParkingWidget::class.java)))
            }
            context.sendBroadcast(intent)
        }
    }
}