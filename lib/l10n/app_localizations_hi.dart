// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get welcomeMessage => 'Cal AI में आपका स्वागत है';

  @override
  String get trackMessage => 'और स्मार्ट तरीके से ट्रैक करें। बेहतर खाएं।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get alreadyAccount => 'क्या पहले से एक खाता है?';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get calorieTrackingMadeEasy => 'कैलोरी ट्रैकिंग आसान है';

  @override
  String get onboardingStep1Title => 'अपने भोजन को ट्रैक करें';

  @override
  String get onboardingStep1Description =>
      'अपने भोजन को आसानी से लॉग करें और अपने पोषण को ट्रैक करें।';
}
