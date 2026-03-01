// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Startseite';

  @override
  String get progressTab => 'Fortschritt';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get welcomeMessage => 'Willkommen bei Cal AI';

  @override
  String get trackMessage => 'Track smarter. Besser essen.';

  @override
  String get getStarted => 'Erste Schritte';

  @override
  String get alreadyAccount => 'Haben Sie bereits ein Konto?';

  @override
  String get signIn => 'Anmelden';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get personalDetails => 'Persönliche Daten';

  @override
  String get adjustMacronutrients => 'Makronährstoffe anpassen';

  @override
  String get weightHistory => 'Gewichtsverlauf';

  @override
  String get homeWidget => 'Startseite-Widget';

  @override
  String get chooseHomeWidgets => 'Startseite-Widgets wählen';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Tippen Sie auf Optionen, um Widgets hinzuzufügen oder zu entfernen.';

  @override
  String get updatingWidgetSelection => 'Widget-Auswahl wird aktualisiert...';

  @override
  String get requestingWidgetPermission => 'Anfrage für Widget-Berechtigung...';

  @override
  String get widget1 => 'Widget Nr. 1';

  @override
  String get widget2 => 'Widget Nr. 2';

  @override
  String get widget3 => 'Widget Nr. 3';

  @override
  String get calorieTrackerWidget => 'Kalorien-Tracker';

  @override
  String get nutritionTrackerWidget => 'Ernährungs-Tracker';

  @override
  String get streakTrackerWidget => 'Streak-Tracker';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName aus der Auswahl entfernt.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'Um $widgetName zu entfernen, entfernen Sie es von Ihrem Startbildschirm. Die Auswahl wird automatisch synchronisiert.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'Um $widgetName hinzuzufügen, drücken Sie lange auf den Startbildschirm, tippen Sie auf + und wählen Sie dann Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return '$widgetName-Widget hinzugefügt.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Berechtigung zum Hinzufügen von $widgetName erforderlich. Wir haben die Einstellungen für Sie geöffnet.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'Die Berechtigungseinstellungen konnten nicht geöffnet werden. Bitte aktivieren Sie die Berechtigungen manuell, um $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen =>
      'Keine Widgets auf dem Startbildschirm hinzuzufügen';

  @override
  String selectedWidgets(Object widgets) {
    return 'Ausgewählt: $widgets';
  }

  @override
  String get backupData => 'Sichern Sie Ihre Daten';

  @override
  String get signInToSync =>
      'Melden Sie sich an, um Ihren Fortschritt und Ihre Ziele zu synchronisieren';

  @override
  String get accountSuccessfullyBackedUp => 'Konto erfolgreich gesichert!';

  @override
  String get failedToLinkAccount => 'Konto konnte nicht verknüpft werden.';

  @override
  String get googleAccountAlreadyLinked =>
      'Dieses Google-Konto ist bereits mit einem anderen Cal AI-Profil verknüpft.';

  @override
  String get caloriesLabel => 'Kalorien';

  @override
  String get eatenLabel => 'gegessen';

  @override
  String get leftLabel => 'übrig';

  @override
  String get proteinLabel => 'Eiwei?';

  @override
  String get carbsLabel => 'Kohlenhydrate';

  @override
  String get fatsLabel => 'Fette';

  @override
  String get fiberLabel => 'Ballaststoffe';

  @override
  String get sugarLabel => 'Zucker';

  @override
  String get sodiumLabel => 'Natrium';

  @override
  String get stepsLabel => 'Schritte';

  @override
  String get stepsTodayLabel => 'Schritte heute';

  @override
  String get caloriesBurnedLabel => 'Verbrannte Kalorien';

  @override
  String get stepTrackingActive => 'Schrittverfolgung aktiv!';

  @override
  String get waterLabel => 'Wasser';

  @override
  String get servingSizeLabel => 'Portionsgröße';

  @override
  String get waterSettingsTitle => 'Wassereinstellungen';

  @override
  String get hydrationQuestion =>
      'Wie viel Wasser brauchen Sie, um hydriert zu bleiben?';

  @override
  String get hydrationInfo =>
      'Jedermann Die Bedürfnisse unterscheiden sich geringfügig, wir empfehlen jedoch, jeden Tag mindestens 8 Tassen Wasser zu sich zu nehmen.';

  @override
  String get healthScoreTitle => 'Gesundheitsbewertung';

  @override
  String get healthSummaryNoData =>
      'Für heute wurden keine Daten erfasst. Fangen Sie an, Ihre Mahlzeiten zu verfolgen, um Erkenntnisse über Ihre Gesundheit zu erhalten!';

  @override
  String get healthSummaryLowIntake =>
      'Ihre Aufnahme ist ziemlich gering. Konzentrieren Sie sich darauf, Ihre Kalorien- und Proteinziele zu erreichen, um Energie und Muskeln zu erhalten.';

  @override
  String get healthSummaryLowProtein =>
      'Kohlenhydrate und Fett sind auf dem richtigen Weg, aber Ihr Proteingehalt ist niedrig. Eine Erhöhung des Proteingehalts kann beim Muskelerhalt helfen.';

  @override
  String get healthSummaryGreat =>
      'Tolle Arbeit! Ihre Ernährung ist heute ausgewogen.';

  @override
  String get recentlyLoggedTitle => 'Zuletzt protokolliert';

  @override
  String errorLoadingLogs(Object error) {
    return 'Fehler beim Laden der Protokolle: $error';
  }

  @override
  String get deleteLabel => 'Löschen';

  @override
  String get tapToAddFirstEntry =>
      'Tippen Sie auf +, um Ihren ersten Eintrag hinzuzufügen';

  @override
  String unableToLoadProgress(Object error) {
    return 'Fortschritt konnte nicht geladen werden: $error';
  }

  @override
  String get myWeightTitle => 'Mein Gewicht';

  @override
  String goalWithValue(Object value) {
    return 'Ziel $value';
  }

  @override
  String get noGoalSet => 'Kein Ziel festgelegt';

  @override
  String get logWeightCta => 'Protokollgewicht';

  @override
  String get dayStreakTitle => 'Tag Streak';

  @override
  String get progressPhotosTitle => 'Fortschrittsfotos';

  @override
  String get progressPhotoPrompt =>
      'Möchten Sie ein Foto hinzufügen, um Ihren Fortschritt zu verfolgen?';

  @override
  String get uploadPhotoCta => 'Ein Foto hochladen';

  @override
  String get goalProgressTitle => 'Zielfortschritt';

  @override
  String get ofGoalLabel => 'des Ziels';

  @override
  String get logoutLabel => 'Abmelden';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutConfirmMessage => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get cancelLabel => 'Abbrechen';

  @override
  String get preferencesLabel => 'Einstellungen';

  @override
  String get appearanceLabel => 'Aussehen';

  @override
  String get appearanceDescription =>
      'Wählen Sie Hell, Dunkel oder Systemdarstellung';

  @override
  String get lightLabel => 'Hell';

  @override
  String get darkLabel => 'Dunkel';

  @override
  String get automaticLabel => 'Automatisch';

  @override
  String get addBurnedCaloriesLabel => 'Verbrannte Kalorien hinzufügen';

  @override
  String get addBurnedCaloriesDescription =>
      'Verbrannte Kalorien zum Tagesziel hinzufügen';

  @override
  String get rolloverCaloriesLabel => 'Rollover-Kalorien';

  @override
  String get rolloverCaloriesDescription =>
      'Bis zu 200 übriggebliebene Kalorien zum heutigen Ziel hinzufügen';

  @override
  String get measurementUnitLabel => 'Maßeinheit';

  @override
  String get measurementUnitDescription =>
      'Alle Werte werden in imperiale Einheiten umgerechnet (derzeit metrisch).';

  @override
  String get inviteFriendsLabel => 'Freunde einladen';

  @override
  String get defaultUserName => 'Benutzer';

  @override
  String get enterYourNameLabel => 'Geben Sie Ihren Namen ein';

  @override
  String yearsOldLabel(Object years) {
    return '$years Jahre alt';
  }

  @override
  String get termsAndConditionsLabel => 'Allgemeine Geschäftsbedingungen';

  @override
  String get privacyPolicyLabel => 'Datenschutzerklärung';

  @override
  String get supportEmailLabel => 'Support-E-Mail';

  @override
  String get featureRequestLabel => 'Funktionsanfrage';

  @override
  String get deleteAccountQuestion => 'Konto löschen?';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountMessage =>
      'Sind Sie absolut sicher? Dadurch werden Ihr Cal AI-Verlauf, Ihre Gewichtsprotokolle und Ihre benutzerdefinierten Ziele dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deletePermanentlyLabel => 'Dauerhaft löschen';

  @override
  String get onboardingChooseGenderTitle => 'Wählen Sie Ihr Geschlecht';

  @override
  String get onboardingChooseGenderSubtitle =>
      'Dies wird zur Kalibrierung Ihres benutzerdefinierten Plans verwendet.';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderOther => 'Andere';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'Wie viele Trainingseinheiten machen Sie pro Woche?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'Dies wird zur Kalibrierung Ihres benutzerdefinierten Plans verwendet.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Workouts jetzt und dann';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle =>
      'A ein paar Trainingseinheiten pro Woche';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Engagierter Sportler';

  @override
  String get onboardingHearAboutUsTitle => 'Wo haben Sie von uns erfahren?';

  @override
  String get sourceTikTok => 'Tik Tok';

  @override
  String get sourceYouTube => 'YouTube';

  @override
  String get sourceGoogle => 'Google';

  @override
  String get sourcePlayStore => 'Play Store';

  @override
  String get sourceFacebook => 'Facebook';

  @override
  String get sourceFriendFamily => 'Freund oder Familie';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Andere';

  @override
  String get yourBmiTitle => 'Ihr BMI';

  @override
  String get yourWeightIsLabel => 'Ihr Gewicht ist';

  @override
  String get bmiUnderweightLabel => 'Untergewicht';

  @override
  String get bmiHealthyLabel => 'Gesund';

  @override
  String get bmiOverweightLabel => 'Übergewicht';

  @override
  String get bmiObeseLabel => 'Adipös';

  @override
  String get calorieTrackingMadeEasy => 'Kalorienverfolgung leicht gemacht';

  @override
  String get onboardingStep1Title => 'Verfolgen Sie Ihre Mahlzeiten';

  @override
  String get onboardingStep1Description =>
      'Protokollieren Sie Ihre Mahlzeiten einfach und verfolgen Sie Ihre Ernährung.';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get signInWithEmail => 'Mit E-Mail anmelden';

  @override
  String signInFailed(Object error) {
    return 'Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get continueLabel => 'Weiter';

  @override
  String get skipLabel => 'Überspringen';

  @override
  String get noLabel => 'Nein';

  @override
  String get yesLabel => 'Ja';

  @override
  String get submitLabel => 'Senden';

  @override
  String get referralCodeLabel => 'Empfehlung Code';

  @override
  String get heightLabel => 'Höhe';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get imperialLabel => 'US-Einheiten';

  @override
  String get metricLabel => 'Metrik';

  @override
  String get month1Label => 'Monat 1';

  @override
  String get month6Label => 'Monat 6';

  @override
  String get traditionalDietLabel => 'Traditionelle Diät';

  @override
  String get weightChartSummary =>
      '80 % der Cal AI-Benutzer behalten ihren Gewichtsverlust auch 6 Monate später bei';

  @override
  String get comparisonWithoutCalAi => 'Ohne\\nCal AI';

  @override
  String get comparisonWithCalAi => 'Mit\\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI macht es einfach und macht';

  @override
  String get comparisonBottomLine2 => 'Sie verantwortlich';

  @override
  String get speedSlowSteady => 'Langsam und stetig';

  @override
  String get speedRecommended => 'Empfohlen';

  @override
  String get speedAggressiveWarning =>
      'Möglicherweise fühlen Sie sich sehr müde und entwickeln schlaffe Haut';

  @override
  String get subscriptionHeadline =>
      'Schalten Sie CalAI frei, um Ihre Ziele schneller zu erreichen.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Nur PHP $yearlyPrice pro Jahr (PHP $monthlyPrice/Monat)';
  }

  @override
  String get goalGainWeight => 'Nehmen Sie zu';

  @override
  String get goalLoseWeight => 'Gewicht verlieren';

  @override
  String get goalMaintainWeight => 'Gewicht halten';

  @override
  String editGoalTitle(Object title) {
    return 'Bearbeiten Sie das $title-Ziel';
  }

  @override
  String get revertLabel => 'Zurücksetzen';

  @override
  String get doneLabel => 'Erledigt';

  @override
  String get dashboardShouldGainWeight => 'gewinnen';

  @override
  String get dashboardShouldLoseWeight => 'verlieren';

  @override
  String get dashboardShouldMaintainWeight => 'pflegen';

  @override
  String get dashboardCongratsPlanReady =>
      'Herzlichen Glückwunsch\\nIhr individueller Plan ist fertig!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'Sie sollten $action:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit von $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Tägliche Empfehlung';

  @override
  String get dashboardEditAnytime => 'Sie können dies jederzeit bearbeiten';

  @override
  String get dashboardHowToReachGoals => 'So erreichen Sie Ihre Ziele:';

  @override
  String get dashboardReachGoalLifeScore =>
      'Holen Sie sich Ihren wöchentlichen Life-Score und verbessern Sie Ihre Routine.';

  @override
  String get dashboardReachGoalTrackFood => 'Verfolgen Sie Ihr Essen';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Befolgen Sie Ihre tägliche Kalorienempfehlung';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Balancieren Sie Ihre Kohlenhydrate, Proteine ​​und Fette';

  @override
  String get dashboardPlanSourcesTitle =>
      'Plan basierend auf den folgenden Quellen, neben anderen von Experten begutachteten medizinischen Studien:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Grundumsatz';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Kalorienzählen – Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'Internationale Gesellschaft für Sporternährung';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'Nationale Gesundheitsinstitute';

  @override
  String get factorsNetCarbsMass => 'Nettokohlenhydrate/Masse';

  @override
  String get factorsNetCarbDensity => 'Nettokohlenhydratdichte';

  @override
  String get factorsSodiumMass => 'Natrium / Masse';

  @override
  String get factorsSodiumDensity => 'Natriumdichte';

  @override
  String get factorsSugarMass => 'Zucker / Masse';

  @override
  String get factorsSugarDensity => 'Zuckerdichte';

  @override
  String get factorsProcessedScore => 'Verarbeitete Partitur';

  @override
  String get factorsIngredientQuality => 'Qualität der Zutaten';

  @override
  String get factorsProcessedScoreDescription =>
      'Der verarbeitete Wert berücksichtigt Farbstoffe, Nitrate, Samenöle, künstliche Aromen/Süßstoffe und andere Faktoren.';

  @override
  String get healthScoreExplanationIntro =>
      'Unser Gesundheitsscore ist eine komplexe Formel, die mehrere Faktoren bei einer Vielzahl gängiger Lebensmittel berücksichtigt.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'Nachfolgend sind die Faktoren aufgeführt, die wir bei der Berechnung des Gesundheitsfaktors berücksichtigen:';

  @override
  String get netCarbsLabel => 'Netto-Kohlenhydrate';

  @override
  String get howDoesItWork => 'Wie funktioniert es?';

  @override
  String get goodLabel => 'Gut';

  @override
  String get badLabel => 'Schlecht';

  @override
  String get dailyRecommendationFor => 'Tagesempfehlung für';

  @override
  String get loadingCustomizingHealthPlan => 'Gesundheitsplan anpassen...';

  @override
  String get loadingApplyingBmrFormula => 'Anwendung der BMR-Formel...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'Schätzen Sie Ihr Stoffwechselalter...';

  @override
  String get loadingFinalizingResults => 'Endgültige Ergebnisse...';

  @override
  String get loadingSetupForYou => 'Wir richten alles für Sie ein';

  @override
  String get step4TriedOtherCalorieApps =>
      'Haben Sie andere Kalorien-Tracking-Apps ausprobiert?';

  @override
  String get step5CalAiLongTermResults =>
      'Cal AI schafft langfristige Ergebnisse';

  @override
  String get step6HeightWeightTitle => 'Größe und Gewicht';

  @override
  String get step6HeightWeightSubtitle =>
      'Dies wird bei der Berechnung Ihrer täglichen Ernährungsziele berücksichtigt.';

  @override
  String get step7WhenWereYouBorn => 'Wann wurdest du geboren?';

  @override
  String get step8GoalQuestionTitle => 'Was ist Ihr Ziel?';

  @override
  String get step8GoalQuestionSubtitle =>
      'Dies hilft uns, einen Plan für Ihre Kalorienzufuhr zu erstellen.';

  @override
  String get step9SpecificDietQuestion => 'Befolgen Sie eine bestimmte Diät?';

  @override
  String get step9DietClassic => 'Klassiker';

  @override
  String get step9DietPescatarian => 'Pescatarianer';

  @override
  String get step9DietVegetarian => 'Vegetarier';

  @override
  String get step9DietVegan => 'Vegane Ernährung';

  @override
  String get step91DesiredWeightQuestion => 'Was ist Ihr Wunschgewicht?';

  @override
  String get step92GoalActionGaining => 'Gewinnen';

  @override
  String get step92GoalActionLosing => 'Verlieren';

  @override
  String get step92RealisticTargetSuffix =>
      'ist ein realistisches Ziel. Es ist überhaupt nicht schwer!';

  @override
  String get step92SocialProof =>
      '90 % der Benutzer sagen, dass die Veränderung nach der Verwendung von Cal AI offensichtlich ist und nicht einfach wieder auftritt.';

  @override
  String get step93GoalVerbGain => 'Gewinnen';

  @override
  String get step93GoalVerbLose => 'Verlieren';

  @override
  String get step93SpeedQuestionTitle =>
      'Wie schnell möchten Sie Ihr Ziel erreichen?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return '$action Gewichtsgeschwindigkeit pro Woche';
  }

  @override
  String get step94ComparisonTitle =>
      'Verlieren Sie mit Cal AI doppelt so viel Gewicht wie alleine';

  @override
  String get step95ObstaclesTitle =>
      'Was hält Sie davon ab, Ihre Ziele zu erreichen?';

  @override
  String get step10AccomplishTitle => 'Was möchten Sie erreichen?';

  @override
  String get step10OptionHealthier => 'Gesünder essen und leben';

  @override
  String get step10OptionEnergyMood =>
      'Steigern Sie meine Energie und Stimmung';

  @override
  String get step10OptionConsistency => 'Bleiben Sie motiviert und konsequent';

  @override
  String get step10OptionBodyConfidence => 'Fühle mich besser in meinem Körper';

  @override
  String get step11PotentialTitle =>
      'Sie haben großes Potenzial, Ihr Ziel zu erreichen';

  @override
  String get step12ThankYouTitle => 'Vielen Dank für Ihr Vertrauen!';

  @override
  String get step12PersonalizeSubtitle =>
      'Lassen Sie uns nun Cal AI für Sie personalisieren ...';

  @override
  String get step12PrivacyCardTitle =>
      'Ihre Privatsphäre und Sicherheit sind uns wichtig.';

  @override
  String get step12PrivacyCardBody =>
      'Wir versprechen, Ihre\\npersönlichen Daten stets vertraulich und sicher zu behandeln.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Erreichen Sie Ihre Ziele mit Benachrichtigungen';

  @override
  String get step13NotificationPrompt =>
      'Cal AI möchte Ihnen Benachrichtigungen senden';

  @override
  String get allowLabel => 'Erlauben';

  @override
  String get dontAllowLabel => 'Nicht zulassen';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'Verbrannte Kalorien zu Ihrem Tagesziel hinzufügen?';

  @override
  String get step15RolloverQuestion =>
      'Überschüssige Kalorien auf den nächsten Tag übertragen?';

  @override
  String get step15RolloverUpTo => 'Rollover bis';

  @override
  String get step15RolloverCap => '200 kcal';

  @override
  String get step16ReferralTitle => 'Empfehlungscode eingeben (optional)';

  @override
  String get step16ReferralSubtitle => 'Sie können diesen Schritt überspringen';

  @override
  String get step17AllDone => 'Alles erledigt!';

  @override
  String get step17GeneratePlanTitle =>
      'Zeit, Ihren individuellen Plan zu erstellen!';

  @override
  String get step18CalculationError =>
      'Plan konnte nicht berechnet werden. Bitte überprüfen Sie Ihre Verbindung.';

  @override
  String get step18TryAgain => 'Versuchen Sie es erneut';

  @override
  String get step19CreateAccountTitle => 'Ein Konto erstellen';

  @override
  String get authInvalidEmailMessage =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get authCheckYourEmailTitle => 'Überprüfen Sie Ihre E-Mails';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'Wir haben einen Anmeldelink an $email gesendet';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get authWhatsYourEmail => 'Wie lautet Ihre E-Mail?';

  @override
  String get authPasswordlessHint =>
      'Wir senden Ihnen einen Link zur Anmeldung ohne Passwort.';

  @override
  String get emailExampleHint => 'name@beispiel.de';

  @override
  String get notSetLabel => 'Nicht festgelegt';

  @override
  String get goalWeightLabel => 'Zielgewicht';

  @override
  String get changeGoalLabel => 'Ziel ändern';

  @override
  String get currentWeightLabel => 'Aktuelles Gewicht';

  @override
  String get dateOfBirthLabel => 'Geburtsdatum';

  @override
  String get genderLabel => 'Geschlecht';

  @override
  String get dailyStepGoalLabel => 'Tägliches Schrittziel';

  @override
  String get stepGoalLabel => 'Schrittziel';

  @override
  String get setHeightTitle => 'Höhe einstellen';

  @override
  String get setGenderTitle => 'Geschlecht festlegen';

  @override
  String get setBirthdayTitle => 'Geburtstag festlegen';

  @override
  String get setWeightTitle => 'Gewicht einstellen';

  @override
  String get editNameTitle => 'Namen bearbeiten';

  @override
  String get calorieGoalLabel => 'Kalorienziel';

  @override
  String get proteinGoalLabel => 'Proteinziel';

  @override
  String get carbGoalLabel => 'Kohlenhydratziel';

  @override
  String get fatGoalLabel => 'Fettziel';

  @override
  String get sugarLimitLabel => 'Zuckergrenze';

  @override
  String get fiberGoalLabel => 'Ballaststoffziel';

  @override
  String get sodiumLimitLabel => 'Natriumgrenze';

  @override
  String get hideMicronutrientsLabel => 'Mikronährstoffe ausblenden';

  @override
  String get viewMicronutrientsLabel => 'Mikronährstoffe anzeigen';

  @override
  String get autoGenerateGoalsLabel => 'Ziele automatisch generieren';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Ziele konnten nicht generiert werden: $error';
  }

  @override
  String get calculatingCustomGoals =>
      'Ihre benutzerdefinierten Ziele werden berechnet...';

  @override
  String get logExerciseLabel => 'Training protokollieren';

  @override
  String get savedFoodsLabel => 'Gespeicherte Lebensmittel';

  @override
  String get foodDatabaseLabel => 'Essen Datenbank';

  @override
  String get scanFoodLabel => 'Essen scannen';

  @override
  String get exerciseTitle => 'Übung';

  @override
  String get runTitle => 'Laufen';

  @override
  String get weightLiftingTitle => 'Gewichtheben';

  @override
  String get describeTitle => 'Beschreiben';

  @override
  String get runDescription => 'Laufen, Joggen, Sprinten usw.';

  @override
  String get weightLiftingDescription => 'Maschinen, Hanteln usw.';

  @override
  String get describeWorkoutDescription => 'Schreiben Sie Ihr Training in Text';

  @override
  String get setIntensityLabel => 'Einstellen Intensität';

  @override
  String get durationLabel => 'Dauer';

  @override
  String get minutesShortLabel => 'Minuten';

  @override
  String get minutesAbbrevSuffix => 'm';

  @override
  String get addLabel => 'Hinzufügen';

  @override
  String get intensityLabel => 'Intensität';

  @override
  String get intensityHighLabel => 'Hoch';

  @override
  String get intensityMediumLabel => 'Mittel';

  @override
  String get intensityLowLabel => 'Niedrig';

  @override
  String get runIntensityHighDescription =>
      'Sprinten – 14 Meilen pro Stunde (4 Minuten Meilen)';

  @override
  String get runIntensityMediumDescription =>
      'Joggen – 6 Meilen pro Stunde (10 Minuten Meilen)';

  @override
  String get runIntensityLowDescription =>
      'Chill Walk – 3 Meilen pro Stunde (20 Minuten). Meilen)';

  @override
  String get weightIntensityHighDescription =>
      'Training bis zum Muskelversagen, schwer atmen';

  @override
  String get weightIntensityMediumDescription =>
      'Ins Schwitzen geraten, viele Wiederholungen';

  @override
  String get weightIntensityLowDescription =>
      'Nicht ins Schwitzen geraten, wenig Anstrengung geben';

  @override
  String get exerciseLoggedSuccessfully => 'Übung erfolgreich protokolliert!';

  @override
  String get exerciseParsedAndLogged => 'Übung analysiert und protokolliert!';

  @override
  String get describeExerciseTitle => 'Übung beschreiben';

  @override
  String get whatDidYouDoHint => 'Was haben Sie gemacht?';

  @override
  String get describeExerciseExample =>
      'Beispiel: 5 Stunden Wandern im Freien, Gefühl der Erschöpfung';

  @override
  String get servingLabel => 'Portion';

  @override
  String get productNotFoundMessage => 'Produkt nicht gefunden.';

  @override
  String couldNotIdentify(Object text) {
    return '„$text“ konnte nicht identifiziert werden.';
  }

  @override
  String get identifyingFoodMessage => 'Lebensmittel identifizieren...';

  @override
  String get loggedSuccessfullyMessage => 'Erfolgreich angemeldet!';

  @override
  String get barcodeScannerLabel => 'Barcode-Scanner';

  @override
  String get barcodeLabel => 'Strichcode';

  @override
  String get foodLabel => 'Lebensmitteletikett';

  @override
  String get galleryLabel => 'Galerie';

  @override
  String get bestScanningPracticesTitle => 'Beste Scan-Praktiken';

  @override
  String get generalTipsTitle => 'Allgemeine Tipps:';

  @override
  String get scanTipKeepFoodInside =>
      'Halten Sie die Lebensmittel innerhalb der Scanlinien';

  @override
  String get scanTipHoldPhoneStill =>
      'Halten Sie Ihr Telefon ruhig, damit das Bild nicht verschwommen ist';

  @override
  String get scanTipAvoidObscureAngles =>
      'Nehmen Sie das Bild nicht aus unklaren Winkeln auf';

  @override
  String get scanNowLabel => 'Jetzt scannen';

  @override
  String get allTabLabel => 'Alle';

  @override
  String get myMealsTabLabel => 'Meine Mahlzeiten';

  @override
  String get myFoodsTabLabel => 'Meine Lebensmittel';

  @override
  String get savedScansTabLabel => 'Gespeicherte Scans';

  @override
  String get logEmptyFoodLabel => 'Leeres Essen protokollieren';

  @override
  String get searchResultsLabel => 'Suchergebnisse';

  @override
  String get suggestionsLabel => 'Vorschläge';

  @override
  String get noItemsFoundLabel => 'Keine Artikel gefunden.';

  @override
  String get noSuggestionsAvailableLabel => 'Keine Vorschläge verfügbar';

  @override
  String get noSavedScansYetLabel => 'Noch keine gespeicherten Scans';

  @override
  String get describeWhatYouAteHint =>
      'Beschreiben Sie, was Sie gegessen haben';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return '$foodName zu $dateId hinzugefügt';
  }

  @override
  String get failedToAddFood =>
      'Essen konnte nicht hinzugefügt werden. Versuchen Sie es erneut.';

  @override
  String get invalidFoodIdMessage => 'Ungültige Lebensmittel-ID';

  @override
  String get foodNotFoundMessage => 'Essen nicht gefunden';

  @override
  String get couldNotLoadFoodDetails =>
      'Die Lebensmitteldetails konnten nicht geladen werden';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Standard';

  @override
  String get selectedFoodTitle => 'Ausgewählte Speisen';

  @override
  String get measurementLabel => 'Messung';

  @override
  String get otherNutritionFactsLabel => 'Weitere Nährwertangaben';

  @override
  String get numberOfServingsLabel => 'Anzahl der Portionen';

  @override
  String get logLabel => 'Protokoll';

  @override
  String get nutrientsTitle => 'Nährstoffe';

  @override
  String get totalNutritionLabel => 'Gesamternährung';

  @override
  String get enterFoodNameHint => 'Geben Sie den Lebensmittelnamen ein';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get statsLabel => 'Statistiken';

  @override
  String get intensityModerateLabel => 'Mäßig';

  @override
  String get thisWeekLabel => 'Diese Woche';

  @override
  String get lastWeekLabel => 'Letzte Woche';

  @override
  String get twoWeeksAgoLabel => 'Vor 2 Wochen';

  @override
  String get threeWeeksAgoLabel => 'Vor 3 Wochen';

  @override
  String get totalCaloriesLabel => 'Gesamtkalorien';

  @override
  String get calsLabel => 'Kal.';

  @override
  String get dayShortSun => 'So';

  @override
  String get dayShortMon => 'Mo';

  @override
  String get dayShortTue => 'Di';

  @override
  String get dayShortWed => 'Mi';

  @override
  String get dayShortThu => 'Do';

  @override
  String get dayShortFri => 'Fr';

  @override
  String get dayShortSat => 'Sa';

  @override
  String get ninetyDaysLabel => '90 Tage';

  @override
  String get sixMonthsLabel => '6 Monate';

  @override
  String get oneYearLabel => '1 Jahr';

  @override
  String get allTimeLabel => 'Alle Zeiten';

  @override
  String get waitingForFirstLogLabel =>
      'Ich warte auf Ihr erstes Protokoll ...';

  @override
  String get editGoalPickerTitle => 'Zielauswahl bearbeiten';

  @override
  String get bmiDisclaimerTitle => 'Haftungsausschluss';

  @override
  String get bmiDisclaimerBody =>
      'Wie bei den meisten Gesundheitsmaßstäben ist der BMI kein perfekter Test. Beispielsweise können die Ergebnisse durch eine Schwangerschaft oder eine hohe Muskelmasse verfälscht werden, und es ist möglicherweise kein guter Indikator für die Gesundheit von Kindern oder älteren Menschen.';

  @override
  String get bmiWhyItMattersTitle => 'Warum ist der BMI dann wichtig?';

  @override
  String get bmiWhyItMattersBody =>
      'Generell gilt: Je höher Ihr BMI, desto höher ist das Risiko, eine Reihe von Erkrankungen zu entwickeln, die mit Übergewicht in Zusammenhang stehen, darunter:\\n� Diabetes\\n� Arthritis\\n� Lebererkrankungen\\n� verschiedene Arten von Krebs (z. B. Brust-, Dickdarm- und Prostatakrebs)\\n� hoher Blutdruck (Hypertonie)\\n� hoher Cholesterinspiegel\\n� Schlafapnoe';

  @override
  String get noWeightHistoryYet =>
      'Es wurde noch kein Gewichtsverlauf aufgezeichnet.';

  @override
  String get overLabel => 'über';

  @override
  String get dailyBreakdownTitle => 'Tägliche Aufschlüsselung';

  @override
  String get editDailyGoalsLabel => 'Bearbeiten Sie die täglichen Ziele';

  @override
  String get errorLoadingData => 'Fehler beim Laden der Daten';

  @override
  String get gramsLabel => 'Gramm';

  @override
  String get healthStatusNotEvaluated => 'Nicht bewertet';

  @override
  String get healthStatusCriticallyLow => 'Kritisch niedrig';

  @override
  String get healthStatusNeedsImprovement => 'Verbesserungsbedarf';

  @override
  String get healthStatusFairProgress => 'Fairer Fortschritt';

  @override
  String get healthStatusGoodHealth => 'Gute Gesundheit';

  @override
  String get healthStatusExcellentHealth => 'Ausgezeichnete Gesundheit';

  @override
  String get remindersTitle => 'Erinnerungen';

  @override
  String get failedLoadReminderSettings =>
      'Erinnerungseinstellungen konnten nicht geladen werden.';

  @override
  String get smartNutritionRemindersTitle =>
      'Erinnerungen an intelligente Ernährung';

  @override
  String get dailyReminderAtLabel => 'Tägliche Erinnerung um';

  @override
  String get setSmartNutritionTimeLabel =>
      'Zeit für intelligente Ernährung festlegen';

  @override
  String get waterRemindersTitle => 'Wassererinnerungen';

  @override
  String get everyLabel => 'Jede';

  @override
  String get hourUnitLabel => 'Stunde(n)';

  @override
  String get fromLabel => 'ab';

  @override
  String get setWaterStartTimeLabel => 'Startzeit für Wasser festlegen';

  @override
  String get breakfastReminderTitle => 'Erinnerung an das Frühstück';

  @override
  String get lunchReminderTitle => 'Erinnerung an das Mittagessen';

  @override
  String get dinnerReminderTitle => 'Abendessen Erinnerung';

  @override
  String get snackReminderTitle => 'Snack-Erinnerung';

  @override
  String get goalTrackingAlertsTitle => 'Zielverfolgungswarnungen';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Benachrichtigungen zu Kalorien und Makrozielen, die nahe/überschritten sind';

  @override
  String get stepsExerciseReminderTitle => 'Schritte/Trainingserinnerung';

  @override
  String get dailyAtLabel => 'Täglich um';

  @override
  String get setActivityReminderTimeLabel =>
      'Aktivitätserinnerungszeit festlegen';

  @override
  String get intervalLabel => 'Intervall:';

  @override
  String get setTimeLabel => 'Einstellen time';

  @override
  String get languageNameEnglish => 'Englisch';

  @override
  String get languageNameSpanish => 'Spanisch';

  @override
  String get languageNamePortuguese => 'Portugiesisch';

  @override
  String get languageNameFrench => 'Französisch';

  @override
  String get languageNameGerman => 'Deutsch';

  @override
  String get languageNameItalian => 'Italienisch';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Der Anfang ist der schwierigste Teil. Dafür sind Sie bereit!';

  @override
  String get progressMessageKeepPushing =>
      'Sie machen Fortschritte. Jetzt ist es an der Zeit, weiter zu pushen!';

  @override
  String get progressMessagePayingOff =>
      'Ihr Engagement zahlt sich aus. Weitermachen!';

  @override
  String get progressMessageFinalStretch =>
      'Es ist die letzte Etappe. Fordern Sie sich selbst!';

  @override
  String get progressMessageCongrats =>
      'Du hast es geschafft! Herzlichen Glückwunsch!';

  @override
  String dayStreakWithCount(Object count) {
    return '$count-Tage-Serie';
  }

  @override
  String get streakLostTitle => 'Serie verloren';

  @override
  String get streakActiveSubtitle =>
      'Du bist richtig gut dabei! Protokolliere weiter, um deinen Schwung zu halten.';

  @override
  String get streakLostSubtitle =>
      'Gib nicht auf. Melden Sie noch heute Ihre Mahlzeiten an, um wieder auf den richtigen Weg zu kommen.';

  @override
  String get dayInitialSun => 'S';

  @override
  String get dayInitialMon => 'M';

  @override
  String get dayInitialTue => 'D';

  @override
  String get dayInitialWed => 'M';

  @override
  String get dayInitialThu => 'D';

  @override
  String get dayInitialFri => 'F';

  @override
  String get dayInitialSat => 'S';

  @override
  String get alertCalorieGoalExceededTitle => 'Kalorienziel überschritten';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'Du bist $over kcal über deinem Tagesziel.';
  }

  @override
  String get alertNearCalorieLimitTitle => 'Du bist nahe deinem Kalorienlimit';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Nur noch $remaining kcal übrig. Planen Sie Ihre nächste Mahlzeit sorgfältig.';
  }

  @override
  String get alertProteinBehindTitle => 'Protein-Ziel liegt hinter';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'Sie benötigen noch etwa $missing g Protein, um das heutige Ziel zu erreichen.';
  }

  @override
  String get alertCarbTargetExceededTitle => 'Kohlenhydrat-Ziel überschritten';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'Kohlenhydrate liegen $over g über Ziel.';
  }

  @override
  String get alertFatTargetExceededTitle => 'Fett-Ziel überschritten';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'Fett liegt $over g über Ziel.';
  }

  @override
  String get smartNutritionTipTitle => 'Intelligenter Ernährungstipp';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal links';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal über';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g verbleibendes Protein';
  }

  @override
  String get smartNutritionProteinGoalReached => 'Proteinziel erreicht';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage und $proteinMessage. Protokollieren Sie Ihre nächste Mahlzeit, um auf dem Laufenden zu bleiben.';
  }

  @override
  String get notificationStepsExerciseTitle =>
      'Schritte und Trainingserinnerung';

  @override
  String get notificationStepsExerciseBody =>
      'Protokollieren Sie Ihre Schritte oder Ihr Training, um das heutige Aktivitätsziel zu erreichen.';

  @override
  String get notificationBreakfastTitle => 'Frühstückserinnerung';

  @override
  String get notificationBreakfastBody =>
      'Protokollieren Sie das Frühstück, um früher mit der Kalorien- und Makroverfolgung zu beginnen.';

  @override
  String get notificationLunchTitle => 'Mittagessenerinnerung';

  @override
  String get notificationLunchBody =>
      'Mittagspause. Fügen Sie Ihre Mahlzeit hinzu, um Ihren täglichen Fortschritt genau zu halten.';

  @override
  String get notificationDinnerTitle => 'Abendessen-Erinnerung';

  @override
  String get notificationDinnerBody =>
      'Protokollieren Sie das Abendessen und schließen Sie Ihren Tag mit vollständigen Nährwertdaten ab.';

  @override
  String get notificationSnackTitle => 'Snack-Erinnerung';

  @override
  String get notificationSnackBody =>
      'Fügen Sie Ihren Snack hinzu, damit Kalorien und Makros mit Ihren Zielen übereinstimmen.';

  @override
  String get smartNutritionDailyTitle => 'Intelligente Ernährungskontrolle';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Ziel $calories kcal, ${protein}g Protein, ${carbs}g Kohlenhydrate, ${fats}g Fett. Protokollieren Sie Ihre letzte Mahlzeit, um Ihren Plan korrekt zu halten.';
  }

  @override
  String get notificationWaterTitle => 'Wassererinnerung';

  @override
  String get notificationWaterBody =>
      'Kontrolle der Flüssigkeitszufuhr. Protokollieren Sie ein Glas Wasser in Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Protokollieren Sie Ihre Lebensmittel';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Kalorien heute';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories von $goal kcal';
  }
}
