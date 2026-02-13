// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get welcomeMessage => 'Willkommen bei Cal AI';

  @override
  String get trackMessage => 'Cleverer verfolgen. Besser essen.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get alreadyAccount => 'Hast du schon ein Konto?';

  @override
  String get signIn => 'Anmelden';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get calorieTrackingMadeEasy => 'Kalorienzählen leicht gemacht';

  @override
  String get onboardingStep1Title => 'Verfolge deine Mahlzeiten';

  @override
  String get onboardingStep1Description =>
      'Protokolliere deine Mahlzeiten einfach und verfolge deine Ernährung.';
}
