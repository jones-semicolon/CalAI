import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calai/l10n/app_localizations.dart';

enum HomeWidgetKind { calories, nutrition, streak }

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
  static const String _localePreferenceKey = 'app_locale';

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
    String? ctaText,
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
    final l10n = await _loadL10n();
    final resolvedCtaText = ctaText ?? l10n.homeWidgetLogFoodCta;
    await HomeWidget.saveWidgetData<int>(_caloriesKey, calories);
    await HomeWidget.saveWidgetData<int>(_calorieGoalKey, calorieGoal);
    await HomeWidget.saveWidgetData<String>(_ctaKey, resolvedCtaText);
    await HomeWidget.saveWidgetData<int>(_proteinKey, protein);
    await HomeWidget.saveWidgetData<int>(_proteinGoalKey, proteinGoal);
    await HomeWidget.saveWidgetData<int>(_carbsKey, carbs);
    await HomeWidget.saveWidgetData<int>(_carbsGoalKey, carbsGoal);
    await HomeWidget.saveWidgetData<int>(_fatsKey, fats);
    await HomeWidget.saveWidgetData<int>(_fatsGoalKey, fatsGoal);
    await HomeWidget.saveWidgetData<int>(_streakCountKey, streakCount);

    // Backward-compatible keys for the current native layout.
    await HomeWidget.saveWidgetData<String>(_titleKey, l10n.homeWidgetCaloriesTodayTitle);
    await HomeWidget.saveWidgetData<String>(
      _subtitleKey,
      l10n.homeWidgetCaloriesSubtitle(calories, calorieGoal),
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

  static _AndroidWidgetProviderConfig _providerConfigForKind(
    HomeWidgetKind kind,
  ) {
    switch (kind) {
      case HomeWidgetKind.calories:
        return const _AndroidWidgetProviderConfig(
          providerClass: _androidWidgetProviderClass,
          qualifiedProviderName: _androidQualifiedProviderName,
        );
      case HomeWidgetKind.nutrition:
        return const _AndroidWidgetProviderConfig(
          providerClass: _androidSecondWidgetProviderClass,
          qualifiedProviderName: _androidSecondQualifiedProviderName,
        );
      case HomeWidgetKind.streak:
        return const _AndroidWidgetProviderConfig(
          providerClass: _androidThirdWidgetProviderClass,
          qualifiedProviderName: _androidThirdQualifiedProviderName,
        );
    }
  }

  static Future<bool> requestPinWidget({
    HomeWidgetKind kind = HomeWidgetKind.calories,
  }) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final isSupported = await HomeWidget.isRequestPinWidgetSupported();
    if (isSupported != true) {
      return false;
    }

    final config = _providerConfigForKind(kind);

    await HomeWidget.requestPinWidget(
      name: config.providerClass,
      androidName: config.providerClass,
      qualifiedAndroidName: config.qualifiedProviderName,
    );

    return true;
  }

  static Future<bool> setupAndRequestPinWidget({
    required int calories,
    required int calorieGoal,
    String? ctaText,
    HomeWidgetKind kind = HomeWidgetKind.calories,
  }) async {
    await saveCalorieWidgetData(
      calories: calories,
      calorieGoal: calorieGoal,
      dateId: _todayDateId,
      ctaText: ctaText,
    );
    await updateWidget(dateId: _todayDateId);
    return requestPinWidget(kind: kind);
  }

  static Future<Set<HomeWidgetKind>> getPinnedWidgetKinds() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return <HomeWidgetKind>{};
    }

    final List<HomeWidgetInfo> installed;
    try {
      installed = await HomeWidget.getInstalledWidgets();
    } catch (error, stackTrace) {
      debugPrint(
        'HomeWidgetService.getPinnedWidgetKinds failed: $error\n$stackTrace',
      );
      return <HomeWidgetKind>{};
    }
    final pinnedKinds = <HomeWidgetKind>{};

    if (Platform.isIOS) {
      for (final widget in installed) {
        final kind = widget.iOSKind;
        if (kind == _iOSCaloriesWidgetKind) {
          pinnedKinds.add(HomeWidgetKind.calories);
        } else if (kind == _iOSNutritionWidgetKind) {
          pinnedKinds.add(HomeWidgetKind.nutrition);
        } else if (kind == _iOSStreakWidgetKind) {
          pinnedKinds.add(HomeWidgetKind.streak);
        }
      }
      return pinnedKinds;
    }

    for (final kind in HomeWidgetKind.values) {
      final config = _providerConfigForKind(kind);
      final isPinned = installed.any((widget) {
        final className = widget.androidClassName ?? '';
        return className == '.${config.providerClass}' ||
            className.endsWith(config.providerClass) ||
            className.contains(config.providerClass);
      });

      if (isPinned) {
        pinnedKinds.add(kind);
      }
    }

    return pinnedKinds;
  }

  static Future<bool> isWidgetPinned({required HomeWidgetKind kind}) async {
    final pinnedKinds = await getPinnedWidgetKinds();
    return pinnedKinds.contains(kind);
  }

  static Future<AppLocalizations> _loadL10n() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localePreferenceKey);
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    Locale locale;
    if (savedCode != null && savedCode.isNotEmpty) {
      locale = Locale(savedCode);
    } else {
      locale = Locale(deviceLocale.languageCode);
    }

    final supportedCodes = AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet();
    final resolved = supportedCodes.contains(locale.languageCode)
        ? locale
        : const Locale('en');

    return AppLocalizations.delegate.load(resolved);
  }
}

class _AndroidWidgetProviderConfig {
  final String providerClass;
  final String qualifiedProviderName;

  const _AndroidWidgetProviderConfig({
    required this.providerClass,
    required this.qualifiedProviderName,
  });
}
