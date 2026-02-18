// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeMessage => 'Bienvenido a Cal AI';

  @override
  String get trackMessage => 'Sigue más inteligente. Come mejor.';

  @override
  String get getStarted => 'Empezar';

  @override
  String get alreadyAccount => '¿Ya tienes una cuenta?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get chooseLanguage => 'Elige idioma';

  @override
  String get calorieTrackingMadeEasy => 'El seguimiento de calorías es fácil';

  @override
  String get onboardingStep1Title => 'Registra tus comidas';

  @override
  String get onboardingStep1Description =>
      'Registra tus comidas fácilmente y controla tu nutrición.';
}
