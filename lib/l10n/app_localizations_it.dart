// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get welcomeMessage => 'Benvenuto su Cal AI';

  @override
  String get trackMessage =>
      'Monitora in modo più intelligente. Mangia meglio.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get alreadyAccount => 'Hai già un account?';

  @override
  String get signIn => 'Accedi';

  @override
  String get chooseLanguage => 'Scegli la lingua';

  @override
  String get calorieTrackingMadeEasy =>
      'Il monitoraggio delle calorie è facile';

  @override
  String get onboardingStep1Title => 'Tieni traccia dei tuoi pasti';

  @override
  String get onboardingStep1Description =>
      'Registra facilmente i tuoi pasti e monitora la tua nutrizione.';
}
