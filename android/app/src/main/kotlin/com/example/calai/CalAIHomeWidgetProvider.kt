package com.example.calai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.net.Uri
import android.util.TypedValue
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import kotlin.math.abs

class CalAIHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val layoutId = R.layout.calai_home_widget
            val views = RemoteViews(context.packageName, layoutId)

            val calories = widgetData.getInt(CALORIES_KEY, 0)
            val goal = widgetData.getInt(CALORIE_GOAL_KEY, 0)
            val ctaText = widgetData.getString(CTA_KEY, "Log your food") ?: "Log your food"

            val remaining = goal - calories
            val displayValue = abs(remaining)
            val statusLabel = if (remaining < 0) "over" else "left"
            views.setTextViewText(R.id.widget_ring_value, displayValue.toString())
            views.setTextViewText(R.id.widget_ring_label, "Calories $statusLabel")
            views.setTextViewText(R.id.widget_cta_text, ctaText)

            val progress = if (goal > 0) {
                (calories.toFloat() / goal.toFloat()).coerceIn(0f, 1f)
            } else {
                0f
            }
            val ringBitmap = createRingBitmap(context, progress)
            views.setImageViewBitmap(R.id.widget_ring, ringBitmap)

            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("calai://home"),
            )
            val openFoodIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("calai://food-database"),
            )
            views.setOnClickPendingIntent(R.id.widget_indicator, openAppIntent)
            views.setOnClickPendingIntent(R.id.widget_cta, openFoodIntent)
            views.setOnClickPendingIntent(R.id.widget_cta_icon_bg, openFoodIntent)
            views.setOnClickPendingIntent(R.id.widget_cta_text, openFoodIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle
    ) {
        onUpdate(
            context,
            appWidgetManager,
            intArrayOf(appWidgetId),
            HomeWidgetPlugin.getData(context)
        )
    }

    private fun createRingBitmap(context: Context, progress: Float): Bitmap {
        val size = dpToPx(context, 72f)
        val stroke = dpToPx(context, 7f)
        val bitmap = Bitmap.createBitmap(size.toInt(), size.toInt(), Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        val center = size / 2f
        val radius = center - stroke / 2f
        val rect = RectF(
            center - radius,
            center - radius,
            center + radius,
            center + radius,
        )

        val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeWidth = stroke
            color = ContextCompat.getColor(context, R.color.widget_track)
        }

        val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeWidth = stroke
            color = ContextCompat.getColor(context, R.color.widget_primary)
        }

        canvas.drawArc(rect, 0f, 360f, false, trackPaint)
        canvas.drawArc(rect, -90f, 360f * progress.coerceIn(0f, 1f), false, progressPaint)

        return bitmap
    }

    private fun dpToPx(context: Context, dp: Float): Float {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            dp,
            context.resources.displayMetrics,
        )
    }

    companion object {
        const val TITLE_KEY = "calai_widget_title"
        const val SUBTITLE_KEY = "calai_widget_subtitle"
        const val CALORIES_KEY = "calai_widget_calories"
        const val CALORIE_GOAL_KEY = "calai_widget_calorie_goal"
        const val CTA_KEY = "calai_widget_cta"
    }
}
