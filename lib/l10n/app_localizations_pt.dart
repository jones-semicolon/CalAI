// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcomeMessage => 'Bem-vindo ao Cal AI';

  @override
  String get trackMessage => 'Acompanhe com mais inteligência. Coma melhor.';

  @override
  String get getStarted => 'Começar';

  @override
  String get alreadyAccount => 'Já tem uma conta?';

  @override
  String get signIn => 'Entrar';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get calorieTrackingMadeEasy =>
      'O acompanhamento de calorias ficou fácil';

  @override
  String get onboardingStep1Title => 'Registre suas refeições';

  @override
  String get onboardingStep1Description =>
      'Registre suas refeições facilmente e acompanhe sua nutrição.';
}
