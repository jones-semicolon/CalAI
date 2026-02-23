import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class HomeWidgetService {
  static const String _androidWidgetProviderClass = 'CalAIHomeWidgetProvider';
  static const String _androidQualifiedProviderName =
      'com.example.calai.CalAIHomeWidgetProvider';
  static const String _androidSecondWidgetProviderClass =
      'CalAIHomeWidgetSecondProvider';
  static const String _androidSecondQualifiedProviderName =
      'com.example.calai.CalAIHomeWidgetSecondProvider';
  static const String _androidThirdWidgetProviderClass =
      'CalAIHomeWidgetThirdProvider';
  static const String _androidThirdQualifiedProviderName =
      'com.example.calai.CalAIHomeWidgetThirdProvider';
  static const String _iOSCaloriesWidgetKind = 'CalAIHomeWidgetCalories';
  static const String _iOSNutritionWidgetKind = 'CalAIHomeWidgetNutrition';
  static const String _iOSStreakWidgetKind = 'CalAIHomeWidgetStreak';
  static const String _iOSAppGroupId = 'group.com.example.calai';

  static const String _titleKey = 'calai_widget_title';
  static const String _subtitleKey = 'calai_widget_subtitle';
  static const String _caloriesKey = 'calai_widget_calories';
  static const String _calorieGoalKey = 'calai_widget_calorie_goal';
  static const String _ctaKey = 'calai_widget_cta';
  static const String _proteinKey = 'calai_widget_protein';
  static const String _proteinGoalKey = 'calai_widget_protein_goal';
  static const String _carbsKey = 'calai_widget_carbs';
  static const String _carbsGoalKey = 'calai_widget_carbs_goal';
  static const String _fatsKey = 'calai_widget_fats';
  static const String _fatsGoalKey = 'calai_widget_fats_goal';
  static const String _streakCountKey = 'calai_widget_streak_count';

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
    int protein = 0,
    int proteinGoal = 0,
    int carbs = 0,
    int carbsGoal = 0,
    int fats = 0,
    int fatsGoal = 0,
    int streakCount = 0,
  }) async {
    //checked only date today to prevent updating widget with old data when user opens app after a few days.
    if (!_isTodayDate(dateId)) return;

    await initialize();
    await HomeWidget.saveWidgetData<int>(_caloriesKey, calories);
    await HomeWidget.saveWidgetData<int>(_calorieGoalKey, calorieGoal);
    await HomeWidget.saveWidgetData<String>(_ctaKey, ctaText);
    await HomeWidget.saveWidgetData<int>(_proteinKey, protein);
    await HomeWidget.saveWidgetData<int>(_proteinGoalKey, proteinGoal);
    await HomeWidget.saveWidgetData<int>(_carbsKey, carbs);
    await HomeWidget.saveWidgetData<int>(_carbsGoalKey, carbsGoal);
    await HomeWidget.saveWidgetData<int>(_fatsKey, fats);
    await HomeWidget.saveWidgetData<int>(_fatsGoalKey, fatsGoal);
    await HomeWidget.saveWidgetData<int>(_streakCountKey, streakCount);

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
      iOSName: _iOSCaloriesWidgetKind,
    );
    await HomeWidget.updateWidget(
      name: _androidSecondWidgetProviderClass,
      androidName: _androidSecondWidgetProviderClass,
      qualifiedAndroidName: _androidSecondQualifiedProviderName,
      iOSName: _iOSNutritionWidgetKind,
    );
    await HomeWidget.updateWidget(
      name: _androidThirdWidgetProviderClass,
      androidName: _androidThirdWidgetProviderClass,
      qualifiedAndroidName: _androidThirdQualifiedProviderName,
      iOSName: _iOSStreakWidgetKind,
    );
  }

  static Future<void> saveStreakWidgetData({
    required int streakCount,
    required String dateId,
  }) async {
    if (!_isTodayDate(dateId)) return;
    await initialize();
    await HomeWidget.saveWidgetData<int>(_streakCountKey, streakCount);
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
