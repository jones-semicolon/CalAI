// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeMessage => 'Welcome to Cal AI';

  @override
  String get trackMessage => 'Track smarter. Eat better.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign in';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get calorieTrackingMadeEasy => 'Calorie tracking made easy';

  @override
  String get onboardingStep1Title => 'Track your meals';

  @override
  String get onboardingStep1Description =>
      'Log your meals easily and track your nutrition.';
}
