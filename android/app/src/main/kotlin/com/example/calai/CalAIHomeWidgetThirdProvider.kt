package com.example.calai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.net.Uri
import android.util.TypedValue
import android.widget.RemoteViews
import androidx.core.content.ContextCompat
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import kotlin.math.ceil

class CalAIHomeWidgetThirdProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val views = RemoteViews(context.packageName, R.layout.calai_home_widget_third)

            val streak = widgetData.getInt(STREAK_COUNT_KEY, 0).coerceAtLeast(0)
            val streakText = streak.toString()
            val streakBitmap = createStreakBitmap(context, streakText)
            views.setImageViewBitmap(R.id.widget3_streak_value_image, streakBitmap)

            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("calai://home"),
            )
            views.setOnClickPendingIntent(R.id.widget3_click_root, openAppIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun createStreakBitmap(context: Context, text: String): Bitmap {
        val safeText = if (text.isBlank()) "0" else text
        val fillColor = ContextCompat.getColor(context, R.color.widget3_streak_fill)
        val outlineColor = ContextCompat.getColor(context, R.color.widget3_streak_outline)
        val textSizePx = spToPx(context, 50f)
        val strokeWidthPx = dpToPx(context, 4f)
        val paddingPx = dpToPx(context, 8f)
        val typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)

        val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = fillColor
            style = Paint.Style.FILL
            textSize = textSizePx
            this.typeface = typeface
            textAlign = Paint.Align.LEFT
        }

        val strokePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = outlineColor
            style = Paint.Style.STROKE
            strokeWidth = strokeWidthPx
            strokeJoin = Paint.Join.ROUND
            strokeMiter = 10f
            textSize = textSizePx
            this.typeface = typeface
            textAlign = Paint.Align.LEFT
        }

        val textWidth = maxOf(fillPaint.measureText(safeText), strokePaint.measureText(safeText))
        val metrics = fillPaint.fontMetrics
        val textHeight = metrics.descent - metrics.ascent

        val bitmapWidth = ceil(textWidth + (paddingPx * 2f) + (strokeWidthPx * 2f)).toInt().coerceAtLeast(1)
        val bitmapHeight = ceil(textHeight + (paddingPx * 2f) + (strokeWidthPx * 2f)).toInt().coerceAtLeast(1)

        val baselineX = paddingPx + strokeWidthPx
        val baselineY = paddingPx + strokeWidthPx - metrics.ascent

        return Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888).apply {
            val canvas = Canvas(this)
            canvas.drawText(safeText, baselineX, baselineY, strokePaint)
            canvas.drawText(safeText, baselineX, baselineY, fillPaint)
        }
    }

    private fun spToPx(context: Context, value: Float): Float {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_SP,
            value,
            context.resources.displayMetrics
        )
    }

    private fun dpToPx(context: Context, value: Float): Float {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value,
            context.resources.displayMetrics
        )
    }

    companion object {
        const val STREAK_COUNT_KEY = "calai_widget_streak_count"
    }
}
