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

class CalAIHomeWidgetSecondProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val layoutId = R.layout.calai_home_widget_second
            val views = RemoteViews(context.packageName, layoutId)

            val calories = widgetData.getInt(CALORIES_KEY, 0)
            val goal = widgetData.getInt(CALORIE_GOAL_KEY, 0)
            val protein = widgetData.getInt(PROTEIN_KEY, 0)
            val proteinGoal = widgetData.getInt(PROTEIN_GOAL_KEY, 0)
            val carbs = widgetData.getInt(CARBS_KEY, 0)
            val carbsGoal = widgetData.getInt(CARBS_GOAL_KEY, 0)
            val fats = widgetData.getInt(FATS_KEY, 0)
            val fatsGoal = widgetData.getInt(FATS_GOAL_KEY, 0)

            val remaining = goal - calories
            val displayValue = abs(remaining)
            val statusLabel = if (remaining < 0) "over" else "left"
            views.setTextViewText(R.id.widget_ring_value, displayValue.toString())
            views.setTextViewText(R.id.widget_ring_label, "Calories $statusLabel")

            val proteinDisplay = buildMacroDisplay(protein, proteinGoal, "Protein")
            val carbsDisplay = buildMacroDisplay(carbs, carbsGoal, "Carbs")
            val fatsDisplay = buildMacroDisplay(fats, fatsGoal, "Fats")

            views.setTextViewText(R.id.widget_protein_value, proteinDisplay.valueText)
            views.setTextViewText(R.id.widget_protein_label, proteinDisplay.labelText)
            views.setTextViewText(R.id.widget_carbs_value, carbsDisplay.valueText)
            views.setTextViewText(R.id.widget_carbs_label, carbsDisplay.labelText)
            views.setTextViewText(R.id.widget_fats_value, fatsDisplay.valueText)
            views.setTextViewText(R.id.widget_fats_label, fatsDisplay.labelText)

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
            val openScanFoodIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("calai://scan-food"),
            )
            val openBarcodeIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("calai://barcode"),
            )
            views.setOnClickPendingIntent(R.id.widget_main_panel, openAppIntent)
            views.setOnClickPendingIntent(R.id.widget_scan_food_action, openScanFoodIntent)
            views.setOnClickPendingIntent(R.id.widget_barcode_action, openBarcodeIntent)

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
        val size = dpToPx(context, 100f)
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
            color = ContextCompat.getColor(context, R.color.widget2_track)
        }

        val progressPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeCap = Paint.Cap.ROUND
            strokeWidth = stroke
            color = ContextCompat.getColor(context, R.color.widget2_primary)
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

    private fun buildMacroDisplay(consumed: Int, target: Int, label: String): MacroDisplay {
        val remaining = target - consumed
        val absValue = abs(remaining)
        val statusLabel = if (remaining < 0) "over" else "left"
        return MacroDisplay(
            valueText = "${absValue}g",
            labelText = "$label $statusLabel",
        )
    }

    private data class MacroDisplay(
        val valueText: String,
        val labelText: String,
    )

    companion object {
        const val CALORIES_KEY = "calai_widget_calories"
        const val CALORIE_GOAL_KEY = "calai_widget_calorie_goal"
        const val PROTEIN_KEY = "calai_widget_protein"
        const val PROTEIN_GOAL_KEY = "calai_widget_protein_goal"
        const val CARBS_KEY = "calai_widget_carbs"
        const val CARBS_GOAL_KEY = "calai_widget_carbs_goal"
        const val FATS_KEY = "calai_widget_fats"
        const val FATS_GOAL_KEY = "calai_widget_fats_goal"
    }
}
