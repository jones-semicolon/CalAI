// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeMessage => 'Bienvenue sur Cal AI';

  @override
  String get trackMessage => 'Suivez plus intelligemment. Mangez mieux.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get alreadyAccount => 'Vous avez déjà un compte ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get chooseLanguage => 'Choisissez la langue';

  @override
  String get calorieTrackingMadeEasy => 'Le suivi des calories est facile';

  @override
  String get onboardingStep1Title => 'Suivez vos repas';

  @override
  String get onboardingStep1Description =>
      'Notez facilement vos repas et suivez votre nutrition.';
}
