import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class HomeWidgetService {
  static const String _androidWidgetProviderClass = 'CalAIHomeWidgetProvider';
  static const String _androidQualifiedProviderName =
      'com.example.calai.CalAIHomeWidgetProvider';
  static const String _iOSWidgetKind = 'CalAIHomeWidget';
  static const String _iOSAppGroupId = 'group.com.example.calai';

  static const String _titleKey = 'calai_widget_title';
  static const String _subtitleKey = 'calai_widget_subtitle';
  static const String _caloriesKey = 'calai_widget_calories';
  static const String _calorieGoalKey = 'calai_widget_calorie_goal';
  static const String _ctaKey = 'calai_widget_cta';

  static String get _todayDateId =>
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

  static bool _isTodayDate(String? dateId) {
    if (dateId == null || dateId.isEmpty) return true;
    return dateId == _todayDateId;
  }

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(_iOSAppGroupId);
    }
  }

  static Future<void> saveCalorieWidgetData({
    required int calories,
    required int calorieGoal,
    required String dateId,
    String ctaText = 'Log your food',
  }) async {
    //checked only date today to prevent updating widget with old data when user opens app after a few days.
    if (!_isTodayDate(dateId)) return;

    await initialize();
    await HomeWidget.saveWidgetData<int>(_caloriesKey, calories);
    await HomeWidget.saveWidgetData<int>(_calorieGoalKey, calorieGoal);
    await HomeWidget.saveWidgetData<String>(_ctaKey, ctaText);

    // Backward-compatible keys for the current native layout.
    await HomeWidget.saveWidgetData<String>(_titleKey, 'Calories today');
    await HomeWidget.saveWidgetData<String>(
      _subtitleKey,
      '$calories / $calorieGoal kcal',
    );
  }

  static Future<void> updateWidget({required String dateId}) async {
    if (!_isTodayDate(dateId)) return;

    await initialize();
    await HomeWidget.updateWidget(
      name: _androidWidgetProviderClass,
      androidName: _androidWidgetProviderClass,
      qualifiedAndroidName: _androidQualifiedProviderName,
      iOSName: _iOSWidgetKind,
    );
  }

  static Future<bool> requestPinWidget() async {
    if (!Platform.isAndroid) {
      return false;
    }

    final isSupported = await HomeWidget.isRequestPinWidgetSupported();
    if (isSupported != true) {
      return false;
    }

    await HomeWidget.requestPinWidget(
      name: _androidWidgetProviderClass,
      androidName: _androidWidgetProviderClass,
      qualifiedAndroidName: _androidQualifiedProviderName,
    );

    return true;
  }

  static Future<bool> setupAndRequestPinWidget({
    required int calories,
    required int calorieGoal,
    String ctaText = 'Log your food',
  }) async {
    await saveCalorieWidgetData(
      calories: calories,
      calorieGoal: calorieGoal,
      dateId: _todayDateId,
      ctaText: ctaText,
    );
    await updateWidget(dateId: _todayDateId);
    return requestPinWidget();
  }
}
