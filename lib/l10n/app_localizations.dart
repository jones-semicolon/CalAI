import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cal AI'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @progressTab.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cal AI'**
  String get welcomeMessage;

  /// No description provided for @trackMessage.
  ///
  /// In en, this message translates to:
  /// **'Track smarter. Eat better.'**
  String get trackMessage;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @adjustMacronutrients.
  ///
  /// In en, this message translates to:
  /// **'Adjust Macronutrients'**
  String get adjustMacronutrients;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;

  /// No description provided for @homeWidget.
  ///
  /// In en, this message translates to:
  /// **'Home Widget'**
  String get homeWidget;

  /// No description provided for @chooseHomeWidgets.
  ///
  /// In en, this message translates to:
  /// **'Choose Home Widgets'**
  String get chooseHomeWidgets;

  /// No description provided for @tapOptionsToAddRemoveWidgets.
  ///
  /// In en, this message translates to:
  /// **'Tap options to add or remove widgets.'**
  String get tapOptionsToAddRemoveWidgets;

  /// No description provided for @updatingWidgetSelection.
  ///
  /// In en, this message translates to:
  /// **'Updating widget selection...'**
  String get updatingWidgetSelection;

  /// No description provided for @requestingWidgetPermission.
  ///
  /// In en, this message translates to:
  /// **'Requesting widget permission...'**
  String get requestingWidgetPermission;

  /// No description provided for @widget1.
  ///
  /// In en, this message translates to:
  /// **'Widget 1'**
  String get widget1;

  /// No description provided for @widget2.
  ///
  /// In en, this message translates to:
  /// **'Widget 2'**
  String get widget2;

  /// No description provided for @widget3.
  ///
  /// In en, this message translates to:
  /// **'Widget 3'**
  String get widget3;

  /// No description provided for @calorieTrackerWidget.
  ///
  /// In en, this message translates to:
  /// **'Calorie Tracker'**
  String get calorieTrackerWidget;

  /// No description provided for @nutritionTrackerWidget.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Tracker'**
  String get nutritionTrackerWidget;

  /// No description provided for @streakTrackerWidget.
  ///
  /// In en, this message translates to:
  /// **'Streak Tracker'**
  String get streakTrackerWidget;

  /// No description provided for @removedFromSelection.
  ///
  /// In en, this message translates to:
  /// **'{widgetName} removed from selection.'**
  String removedFromSelection(Object widgetName);

  /// No description provided for @removeFromHomeScreenInstruction.
  ///
  /// In en, this message translates to:
  /// **'To remove {widgetName}, remove it from your home screen. Selection syncs automatically.'**
  String removeFromHomeScreenInstruction(Object widgetName);

  /// No description provided for @addFromHomeScreenInstruction.
  ///
  /// In en, this message translates to:
  /// **'To add {widgetName}, long-press the Home Screen, tap +, then select Cal AI.'**
  String addFromHomeScreenInstruction(Object widgetName);

  /// No description provided for @widgetAdded.
  ///
  /// In en, this message translates to:
  /// **'{widgetName} widget added.'**
  String widgetAdded(Object widgetName);

  /// No description provided for @permissionNeededToAddWidget.
  ///
  /// In en, this message translates to:
  /// **'Permission needed to add {widgetName}. We opened settings for you.'**
  String permissionNeededToAddWidget(Object widgetName);

  /// No description provided for @couldNotOpenPermissionSettings.
  ///
  /// In en, this message translates to:
  /// **'Could not open permission settings. Please enable permissions manually to add {widgetName}.'**
  String couldNotOpenPermissionSettings(Object widgetName);

  /// No description provided for @noWidgetsOnHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'No widgets on home screen'**
  String get noWidgetsOnHomeScreen;

  /// No description provided for @selectedWidgets.
  ///
  /// In en, this message translates to:
  /// **'Selected: {widgets}'**
  String selectedWidgets(Object widgets);

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup your data'**
  String get backupData;

  /// No description provided for @signInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your progress & goals'**
  String get signInToSync;

  /// No description provided for @accountSuccessfullyBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Account successfully backed up!'**
  String get accountSuccessfullyBackedUp;

  /// No description provided for @failedToLinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to link account.'**
  String get failedToLinkAccount;

  /// No description provided for @googleAccountAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This Google account is already linked to another Cal AI profile.'**
  String get googleAccountAlreadyLinked;

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @eatenLabel.
  ///
  /// In en, this message translates to:
  /// **'eaten'**
  String get eatenLabel;

  /// No description provided for @leftLabel.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get leftLabel;

  /// No description provided for @proteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteinLabel;

  /// No description provided for @carbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbsLabel;

  /// No description provided for @fatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fatsLabel;

  /// No description provided for @fiberLabel.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiberLabel;

  /// No description provided for @sugarLabel.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugarLabel;

  /// No description provided for @sodiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodiumLabel;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// No description provided for @stepsTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps Today'**
  String get stepsTodayLabel;

  /// No description provided for @caloriesBurnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurnedLabel;

  /// No description provided for @stepTrackingActive.
  ///
  /// In en, this message translates to:
  /// **'Step tracking active!'**
  String get stepTrackingActive;

  /// No description provided for @waterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get waterLabel;

  /// No description provided for @servingSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Serving Size'**
  String get servingSizeLabel;

  /// No description provided for @waterSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Water settings'**
  String get waterSettingsTitle;

  /// No description provided for @hydrationQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much water do you need to stay hydrated?'**
  String get hydrationQuestion;

  /// No description provided for @hydrationInfo.
  ///
  /// In en, this message translates to:
  /// **'Everyone\'s needs are slightly different, but we recommend aiming for at least 64 fl oz (8 cups) of water each day.'**
  String get hydrationInfo;

  /// No description provided for @healthScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Health score'**
  String get healthScoreTitle;

  /// No description provided for @healthSummaryNoData.
  ///
  /// In en, this message translates to:
  /// **'No data logged for today. Start tracking your meals to see your health insights!'**
  String get healthSummaryNoData;

  /// No description provided for @healthSummaryLowIntake.
  ///
  /// In en, this message translates to:
  /// **'Your intake is quite low. Focus on hitting your calorie and protein targets to maintain energy and muscle.'**
  String get healthSummaryLowIntake;

  /// No description provided for @healthSummaryLowProtein.
  ///
  /// In en, this message translates to:
  /// **'Carbs and fat are on track, but you\'re low in protein. Increasing protein can help with muscle retention.'**
  String get healthSummaryLowProtein;

  /// No description provided for @healthSummaryGreat.
  ///
  /// In en, this message translates to:
  /// **'Great job! Your nutrition is well-balanced today.'**
  String get healthSummaryGreat;

  /// No description provided for @recentlyLoggedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently logged'**
  String get recentlyLoggedTitle;

  /// No description provided for @errorLoadingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error loading logs: {error}'**
  String errorLoadingLogs(Object error);

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @tapToAddFirstEntry.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first entry'**
  String get tapToAddFirstEntry;

  /// No description provided for @unableToLoadProgress.
  ///
  /// In en, this message translates to:
  /// **'Unable to load progress: {error}'**
  String unableToLoadProgress(Object error);

  /// No description provided for @myWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'My Weight'**
  String get myWeightTitle;

  /// No description provided for @goalWithValue.
  ///
  /// In en, this message translates to:
  /// **'Goal {value}'**
  String goalWithValue(Object value);

  /// No description provided for @noGoalSet.
  ///
  /// In en, this message translates to:
  /// **'No Goal Set'**
  String get noGoalSet;

  /// No description provided for @logWeightCta.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeightCta;

  /// No description provided for @dayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get dayStreakTitle;

  /// No description provided for @progressPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Photos'**
  String get progressPhotosTitle;

  /// No description provided for @progressPhotoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Want to add a photo to track your progress?'**
  String get progressPhotoPrompt;

  /// No description provided for @uploadPhotoCta.
  ///
  /// In en, this message translates to:
  /// **'Upload a Photo'**
  String get uploadPhotoCta;

  /// No description provided for @goalProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Progress'**
  String get goalProgressTitle;

  /// No description provided for @ofGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'of goal'**
  String get ofGoalLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutLabel;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @preferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesLabel;

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceLabel;

  /// No description provided for @appearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose light, dark, or system appearance'**
  String get appearanceDescription;

  /// No description provided for @lightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightLabel;

  /// No description provided for @darkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkLabel;

  /// No description provided for @automaticLabel.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automaticLabel;

  /// No description provided for @addBurnedCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Burned Calories'**
  String get addBurnedCaloriesLabel;

  /// No description provided for @addBurnedCaloriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add burned calories to daily goal'**
  String get addBurnedCaloriesDescription;

  /// No description provided for @rolloverCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Rollover Calories'**
  String get rolloverCaloriesLabel;

  /// No description provided for @rolloverCaloriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add up to 200 leftover calories into today\'s goal'**
  String get rolloverCaloriesDescription;

  /// No description provided for @measurementUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement unit'**
  String get measurementUnitLabel;

  /// No description provided for @measurementUnitDescription.
  ///
  /// In en, this message translates to:
  /// **'All values will be converted to imperial (currently on metrics)'**
  String get measurementUnitDescription;

  /// No description provided for @inviteFriendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get inviteFriendsLabel;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get defaultUserName;

  /// No description provided for @enterYourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourNameLabel;

  /// No description provided for @yearsOldLabel.
  ///
  /// In en, this message translates to:
  /// **'{years} years old'**
  String yearsOldLabel(Object years);

  /// No description provided for @termsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsLabel;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @supportEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get supportEmailLabel;

  /// No description provided for @featureRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequestLabel;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure? This will permanently delete your Cal AI history, weight logs, and custom goals. This action cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deletePermanentlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanentlyLabel;

  /// No description provided for @onboardingChooseGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your Gender'**
  String get onboardingChooseGenderTitle;

  /// No description provided for @onboardingChooseGenderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will be used to calibrate your custom plan.'**
  String get onboardingChooseGenderSubtitle;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @onboardingWorkoutsPerWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'How many workouts do you do per week?'**
  String get onboardingWorkoutsPerWeekTitle;

  /// No description provided for @onboardingWorkoutsPerWeekSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will be used to calibrate your custom plan.'**
  String get onboardingWorkoutsPerWeekSubtitle;

  /// No description provided for @workoutRangeLowTitle.
  ///
  /// In en, this message translates to:
  /// **'0-2'**
  String get workoutRangeLowTitle;

  /// No description provided for @workoutRangeLowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workouts now and then'**
  String get workoutRangeLowSubtitle;

  /// No description provided for @workoutRangeModerateTitle.
  ///
  /// In en, this message translates to:
  /// **'3-5'**
  String get workoutRangeModerateTitle;

  /// No description provided for @workoutRangeModerateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few workouts per week'**
  String get workoutRangeModerateSubtitle;

  /// No description provided for @workoutRangeHighTitle.
  ///
  /// In en, this message translates to:
  /// **'6+'**
  String get workoutRangeHighTitle;

  /// No description provided for @workoutRangeHighSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dedicated athlete'**
  String get workoutRangeHighSubtitle;

  /// No description provided for @onboardingHearAboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Where did you hear about us?'**
  String get onboardingHearAboutUsTitle;

  /// No description provided for @sourceTikTok.
  ///
  /// In en, this message translates to:
  /// **'Tik Tok'**
  String get sourceTikTok;

  /// No description provided for @sourceYouTube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get sourceYouTube;

  /// No description provided for @sourceGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get sourceGoogle;

  /// No description provided for @sourcePlayStore.
  ///
  /// In en, this message translates to:
  /// **'Play Store'**
  String get sourcePlayStore;

  /// No description provided for @sourceFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get sourceFacebook;

  /// No description provided for @sourceFriendFamily.
  ///
  /// In en, this message translates to:
  /// **'Friend or family'**
  String get sourceFriendFamily;

  /// No description provided for @sourceTv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get sourceTv;

  /// No description provided for @sourceInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get sourceInstagram;

  /// No description provided for @sourceX.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get sourceX;

  /// No description provided for @sourceOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sourceOther;

  /// No description provided for @yourBmiTitle.
  ///
  /// In en, this message translates to:
  /// **'Your BMI'**
  String get yourBmiTitle;

  /// No description provided for @yourWeightIsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your weight is'**
  String get yourWeightIsLabel;

  /// No description provided for @bmiUnderweightLabel.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweightLabel;

  /// No description provided for @bmiHealthyLabel.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get bmiHealthyLabel;

  /// No description provided for @bmiOverweightLabel.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweightLabel;

  /// No description provided for @bmiObeseLabel.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObeseLabel;

  /// No description provided for @calorieTrackingMadeEasy.
  ///
  /// In en, this message translates to:
  /// **'Calorie tracking made easy'**
  String get calorieTrackingMadeEasy;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Track your meals'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Log your meals easily and track your nutrition.'**
  String get onboardingStep1Description;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed: {error}'**
  String signInFailed(Object error);

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @skipLabel.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @submitLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitLabel;

  /// No description provided for @referralCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCodeLabel;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @imperialLabel.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperialLabel;

  /// No description provided for @metricLabel.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metricLabel;

  /// No description provided for @month1Label.
  ///
  /// In en, this message translates to:
  /// **'Month 1'**
  String get month1Label;

  /// No description provided for @month6Label.
  ///
  /// In en, this message translates to:
  /// **'Month 6'**
  String get month6Label;

  /// No description provided for @traditionalDietLabel.
  ///
  /// In en, this message translates to:
  /// **'Traditional Diet'**
  String get traditionalDietLabel;

  /// No description provided for @weightChartSummary.
  ///
  /// In en, this message translates to:
  /// **'80% of Cal AI users maintain their weight loss even 6 months later'**
  String get weightChartSummary;

  /// No description provided for @comparisonWithoutCalAi.
  ///
  /// In en, this message translates to:
  /// **'Without\\nCal AI'**
  String get comparisonWithoutCalAi;

  /// No description provided for @comparisonWithCalAi.
  ///
  /// In en, this message translates to:
  /// **'With\\nCal AI'**
  String get comparisonWithCalAi;

  /// No description provided for @comparisonLeftValue.
  ///
  /// In en, this message translates to:
  /// **'20%'**
  String get comparisonLeftValue;

  /// No description provided for @comparisonRightValue.
  ///
  /// In en, this message translates to:
  /// **'2X'**
  String get comparisonRightValue;

  /// No description provided for @comparisonBottomLine1.
  ///
  /// In en, this message translates to:
  /// **'Cal AI makes it easy and holds'**
  String get comparisonBottomLine1;

  /// No description provided for @comparisonBottomLine2.
  ///
  /// In en, this message translates to:
  /// **'you accountable'**
  String get comparisonBottomLine2;

  /// No description provided for @speedSlowSteady.
  ///
  /// In en, this message translates to:
  /// **'Slow and steady'**
  String get speedSlowSteady;

  /// No description provided for @speedRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get speedRecommended;

  /// No description provided for @speedAggressiveWarning.
  ///
  /// In en, this message translates to:
  /// **'You may feel very tired and develop loose skin'**
  String get speedAggressiveWarning;

  /// No description provided for @subscriptionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Unlock CalAI to reach\\nyour goals faster.'**
  String get subscriptionHeadline;

  /// No description provided for @subscriptionPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Just PHP {yearlyPrice} per year (PHP {monthlyPrice}/mo)'**
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice);

  /// No description provided for @goalGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get goalGainWeight;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLoseWeight;

  /// No description provided for @goalMaintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintain Weight'**
  String get goalMaintainWeight;

  /// No description provided for @editGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit {title} Goal'**
  String editGoalTitle(Object title);

  /// No description provided for @revertLabel.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get revertLabel;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// No description provided for @dashboardShouldGainWeight.
  ///
  /// In en, this message translates to:
  /// **'gain'**
  String get dashboardShouldGainWeight;

  /// No description provided for @dashboardShouldLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'lose'**
  String get dashboardShouldLoseWeight;

  /// No description provided for @dashboardShouldMaintainWeight.
  ///
  /// In en, this message translates to:
  /// **'maintain'**
  String get dashboardShouldMaintainWeight;

  /// No description provided for @dashboardCongratsPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Congratulations\\nyour custom plan is ready!'**
  String get dashboardCongratsPlanReady;

  /// No description provided for @dashboardYouShouldGoal.
  ///
  /// In en, this message translates to:
  /// **'You should {action}:'**
  String dashboardYouShouldGoal(Object action);

  /// No description provided for @dashboardWeightGoalByDate.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} by {date}'**
  String dashboardWeightGoalByDate(Object value, Object unit, Object date);

  /// No description provided for @dashboardDailyRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Daily Recommendation'**
  String get dashboardDailyRecommendation;

  /// No description provided for @dashboardEditAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can edit this any time'**
  String get dashboardEditAnytime;

  /// No description provided for @dashboardHowToReachGoals.
  ///
  /// In en, this message translates to:
  /// **'How to reach your goals:'**
  String get dashboardHowToReachGoals;

  /// No description provided for @dashboardReachGoalLifeScore.
  ///
  /// In en, this message translates to:
  /// **'Get your weekly life score and improve your routine.'**
  String get dashboardReachGoalLifeScore;

  /// No description provided for @dashboardReachGoalTrackFood.
  ///
  /// In en, this message translates to:
  /// **'Track your food'**
  String get dashboardReachGoalTrackFood;

  /// No description provided for @dashboardReachGoalFollowCalories.
  ///
  /// In en, this message translates to:
  /// **'Follow your daily calorie recommendation'**
  String get dashboardReachGoalFollowCalories;

  /// No description provided for @dashboardReachGoalBalanceMacros.
  ///
  /// In en, this message translates to:
  /// **'Balance your carbs, protein, fat'**
  String get dashboardReachGoalBalanceMacros;

  /// No description provided for @dashboardPlanSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan based on the following sources, among other peer-reviewed medical studies:'**
  String get dashboardPlanSourcesTitle;

  /// No description provided for @dashboardSourceBasalMetabolicRate.
  ///
  /// In en, this message translates to:
  /// **'Basal metabolic rate'**
  String get dashboardSourceBasalMetabolicRate;

  /// No description provided for @dashboardSourceCalorieCountingHarvard.
  ///
  /// In en, this message translates to:
  /// **'Calorie counting - Harvard'**
  String get dashboardSourceCalorieCountingHarvard;

  /// No description provided for @dashboardSourceInternationalSportsNutrition.
  ///
  /// In en, this message translates to:
  /// **'International Society of Sports Nutrition'**
  String get dashboardSourceInternationalSportsNutrition;

  /// No description provided for @dashboardSourceNationalInstitutesHealth.
  ///
  /// In en, this message translates to:
  /// **'National Institutes of Health'**
  String get dashboardSourceNationalInstitutesHealth;

  /// No description provided for @factorsNetCarbsMass.
  ///
  /// In en, this message translates to:
  /// **'Net carbs / mass'**
  String get factorsNetCarbsMass;

  /// No description provided for @factorsNetCarbDensity.
  ///
  /// In en, this message translates to:
  /// **'Net carb density'**
  String get factorsNetCarbDensity;

  /// No description provided for @factorsSodiumMass.
  ///
  /// In en, this message translates to:
  /// **'Sodium / mass'**
  String get factorsSodiumMass;

  /// No description provided for @factorsSodiumDensity.
  ///
  /// In en, this message translates to:
  /// **'Sodium density'**
  String get factorsSodiumDensity;

  /// No description provided for @factorsSugarMass.
  ///
  /// In en, this message translates to:
  /// **'Sugar / mass'**
  String get factorsSugarMass;

  /// No description provided for @factorsSugarDensity.
  ///
  /// In en, this message translates to:
  /// **'Sugar density'**
  String get factorsSugarDensity;

  /// No description provided for @factorsProcessedScore.
  ///
  /// In en, this message translates to:
  /// **'Processed score'**
  String get factorsProcessedScore;

  /// No description provided for @factorsIngredientQuality.
  ///
  /// In en, this message translates to:
  /// **'Ingredient quality'**
  String get factorsIngredientQuality;

  /// No description provided for @factorsProcessedScoreDescription.
  ///
  /// In en, this message translates to:
  /// **'The processed score takes into account dyes, nitrates, seed oils, artificial flavoring / sweeteners, and other factors.'**
  String get factorsProcessedScoreDescription;

  /// No description provided for @healthScoreExplanationIntro.
  ///
  /// In en, this message translates to:
  /// **'Our health score is a complex formula taking into account several factors given a multitude of common foods.'**
  String get healthScoreExplanationIntro;

  /// No description provided for @healthScoreExplanationFactorsLead.
  ///
  /// In en, this message translates to:
  /// **'Below are the factors we take into account when calculating health score:'**
  String get healthScoreExplanationFactorsLead;

  /// No description provided for @netCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Net carbs'**
  String get netCarbsLabel;

  /// No description provided for @howDoesItWork.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get howDoesItWork;

  /// No description provided for @goodLabel.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodLabel;

  /// No description provided for @badLabel.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get badLabel;

  /// No description provided for @dailyRecommendationFor.
  ///
  /// In en, this message translates to:
  /// **'Daily recommendation for'**
  String get dailyRecommendationFor;

  /// No description provided for @loadingCustomizingHealthPlan.
  ///
  /// In en, this message translates to:
  /// **'Customizing health plan...'**
  String get loadingCustomizingHealthPlan;

  /// No description provided for @loadingApplyingBmrFormula.
  ///
  /// In en, this message translates to:
  /// **'Applying BMR formula...'**
  String get loadingApplyingBmrFormula;

  /// No description provided for @loadingEstimatingMetabolicAge.
  ///
  /// In en, this message translates to:
  /// **'Estimating your metabolic age...'**
  String get loadingEstimatingMetabolicAge;

  /// No description provided for @loadingFinalizingResults.
  ///
  /// In en, this message translates to:
  /// **'Finalizing results...'**
  String get loadingFinalizingResults;

  /// No description provided for @loadingSetupForYou.
  ///
  /// In en, this message translates to:
  /// **'We\'re setting everything\\nup for you'**
  String get loadingSetupForYou;

  /// No description provided for @step4TriedOtherCalorieApps.
  ///
  /// In en, this message translates to:
  /// **'Have you tried other calorie tracking apps?'**
  String get step4TriedOtherCalorieApps;

  /// No description provided for @step5CalAiLongTermResults.
  ///
  /// In en, this message translates to:
  /// **'Cal AI creates long-term results'**
  String get step5CalAiLongTermResults;

  /// No description provided for @step6HeightWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Height & Weight'**
  String get step6HeightWeightTitle;

  /// No description provided for @step6HeightWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will be taken into account when calculating your daily nutrition goals.'**
  String get step6HeightWeightSubtitle;

  /// No description provided for @step7WhenWereYouBorn.
  ///
  /// In en, this message translates to:
  /// **'When were you born?'**
  String get step7WhenWereYouBorn;

  /// No description provided for @step8GoalQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your goal?'**
  String get step8GoalQuestionTitle;

  /// No description provided for @step8GoalQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us generate a plan for your calorie intake.'**
  String get step8GoalQuestionSubtitle;

  /// No description provided for @step9SpecificDietQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you follow a specific diet?'**
  String get step9SpecificDietQuestion;

  /// No description provided for @step9DietClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get step9DietClassic;

  /// No description provided for @step9DietPescatarian.
  ///
  /// In en, this message translates to:
  /// **'Pescatarian'**
  String get step9DietPescatarian;

  /// No description provided for @step9DietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get step9DietVegetarian;

  /// No description provided for @step9DietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get step9DietVegan;

  /// No description provided for @step91DesiredWeightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your desired weight?'**
  String get step91DesiredWeightQuestion;

  /// No description provided for @step92GoalActionGaining.
  ///
  /// In en, this message translates to:
  /// **'Gaining'**
  String get step92GoalActionGaining;

  /// No description provided for @step92GoalActionLosing.
  ///
  /// In en, this message translates to:
  /// **'Losing'**
  String get step92GoalActionLosing;

  /// No description provided for @step92RealisticTargetSuffix.
  ///
  /// In en, this message translates to:
  /// **' is a realistic target. It\'s not hard at all!'**
  String get step92RealisticTargetSuffix;

  /// No description provided for @step92SocialProof.
  ///
  /// In en, this message translates to:
  /// **'90% of users say the change is obvious after using Cal AI, and it\'s not easy to rebound.'**
  String get step92SocialProof;

  /// No description provided for @step93GoalVerbGain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get step93GoalVerbGain;

  /// No description provided for @step93GoalVerbLose.
  ///
  /// In en, this message translates to:
  /// **'Lose'**
  String get step93GoalVerbLose;

  /// No description provided for @step93SpeedQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'How fast do you want to reach your goal?'**
  String get step93SpeedQuestionTitle;

  /// No description provided for @step93WeightSpeedPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{action} weight speed per week'**
  String step93WeightSpeedPerWeek(Object action);

  /// No description provided for @step94ComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lose twice as much weight with Cal AI vs on your own'**
  String get step94ComparisonTitle;

  /// No description provided for @step95ObstaclesTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s stopping you from reaching your goals?'**
  String get step95ObstaclesTitle;

  /// No description provided for @step10AccomplishTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to accomplish?'**
  String get step10AccomplishTitle;

  /// No description provided for @step10OptionHealthier.
  ///
  /// In en, this message translates to:
  /// **'Eat and live healthier'**
  String get step10OptionHealthier;

  /// No description provided for @step10OptionEnergyMood.
  ///
  /// In en, this message translates to:
  /// **'Boost my energy and mood'**
  String get step10OptionEnergyMood;

  /// No description provided for @step10OptionConsistency.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated and consistent'**
  String get step10OptionConsistency;

  /// No description provided for @step10OptionBodyConfidence.
  ///
  /// In en, this message translates to:
  /// **'Feel better about my body'**
  String get step10OptionBodyConfidence;

  /// No description provided for @step11PotentialTitle.
  ///
  /// In en, this message translates to:
  /// **'You have great potential to crush your goal'**
  String get step11PotentialTitle;

  /// No description provided for @step12ThankYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for\\ntrusting us!'**
  String get step12ThankYouTitle;

  /// No description provided for @step12PersonalizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Now let\'s personalize Cal AI for you...'**
  String get step12PersonalizeSubtitle;

  /// No description provided for @step12PrivacyCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your privacy and security matter to us.'**
  String get step12PrivacyCardTitle;

  /// No description provided for @step12PrivacyCardBody.
  ///
  /// In en, this message translates to:
  /// **'We promise to always keep your\\npersonal information private and secure.'**
  String get step12PrivacyCardBody;

  /// No description provided for @step13ReachGoalsWithNotifications.
  ///
  /// In en, this message translates to:
  /// **'Reach your goals with notifications'**
  String get step13ReachGoalsWithNotifications;

  /// No description provided for @step13NotificationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Cal AI would like to send you notifications'**
  String get step13NotificationPrompt;

  /// No description provided for @allowLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allowLabel;

  /// No description provided for @dontAllowLabel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Allow'**
  String get dontAllowLabel;

  /// No description provided for @step14AddBurnedCaloriesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add calories burned back to your daily goal?'**
  String get step14AddBurnedCaloriesQuestion;

  /// No description provided for @step15RolloverQuestion.
  ///
  /// In en, this message translates to:
  /// **'Rollover extra calories to the next day?'**
  String get step15RolloverQuestion;

  /// No description provided for @step15RolloverUpTo.
  ///
  /// In en, this message translates to:
  /// **'Rollover up to '**
  String get step15RolloverUpTo;

  /// No description provided for @step15RolloverCap.
  ///
  /// In en, this message translates to:
  /// **'200 cals'**
  String get step15RolloverCap;

  /// No description provided for @step16ReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter referral code (optional)'**
  String get step16ReferralTitle;

  /// No description provided for @step16ReferralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can skip this step'**
  String get step16ReferralSubtitle;

  /// No description provided for @step17AllDone.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get step17AllDone;

  /// No description provided for @step17GeneratePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to generate your custom plan!'**
  String get step17GeneratePlanTitle;

  /// No description provided for @step18CalculationError.
  ///
  /// In en, this message translates to:
  /// **'Could not calculate plan. Please check your connection.'**
  String get step18CalculationError;

  /// No description provided for @step18TryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get step18TryAgain;

  /// No description provided for @step19CreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get step19CreateAccountTitle;

  /// No description provided for @authInvalidEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authInvalidEmailMessage;

  /// No description provided for @authCheckYourEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckYourEmailTitle;

  /// No description provided for @authSignInLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a sign-in link to {email}'**
  String authSignInLinkSentMessage(Object email);

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okLabel;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericErrorMessage(Object error);

  /// No description provided for @authWhatsYourEmail.
  ///
  /// In en, this message translates to:
  /// **'What\'s your email?'**
  String get authWhatsYourEmail;

  /// No description provided for @authPasswordlessHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a link to sign in without a password.'**
  String get authPasswordlessHint;

  /// No description provided for @emailExampleHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailExampleHint;

  /// No description provided for @notSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSetLabel;

  /// No description provided for @goalWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal Weight'**
  String get goalWeightLabel;

  /// No description provided for @changeGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Goal'**
  String get changeGoalLabel;

  /// No description provided for @currentWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeightLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @dailyStepGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Step Goal'**
  String get dailyStepGoalLabel;

  /// No description provided for @stepGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Step Goal'**
  String get stepGoalLabel;

  /// No description provided for @setHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Height'**
  String get setHeightTitle;

  /// No description provided for @setGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Gender'**
  String get setGenderTitle;

  /// No description provided for @setBirthdayTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Birthday'**
  String get setBirthdayTitle;

  /// No description provided for @setWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Weight'**
  String get setWeightTitle;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editNameTitle;

  /// No description provided for @calorieGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal'**
  String get calorieGoalLabel;

  /// No description provided for @proteinGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein goal'**
  String get proteinGoalLabel;

  /// No description provided for @carbGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Carb goal'**
  String get carbGoalLabel;

  /// No description provided for @fatGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat goal'**
  String get fatGoalLabel;

  /// No description provided for @sugarLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Sugar limit'**
  String get sugarLimitLabel;

  /// No description provided for @fiberGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Fiber goal'**
  String get fiberGoalLabel;

  /// No description provided for @sodiumLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Sodium limit'**
  String get sodiumLimitLabel;

  /// No description provided for @hideMicronutrientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide micronutrients'**
  String get hideMicronutrientsLabel;

  /// No description provided for @viewMicronutrientsLabel.
  ///
  /// In en, this message translates to:
  /// **'View micronutrients'**
  String get viewMicronutrientsLabel;

  /// No description provided for @autoGenerateGoalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto Generate Goals'**
  String get autoGenerateGoalsLabel;

  /// No description provided for @failedToGenerateGoals.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate goals: {error}'**
  String failedToGenerateGoals(Object error);

  /// No description provided for @calculatingCustomGoals.
  ///
  /// In en, this message translates to:
  /// **'Calculating your custom goals...'**
  String get calculatingCustomGoals;

  /// No description provided for @logExerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Log Exercise'**
  String get logExerciseLabel;

  /// No description provided for @savedFoodsLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved Foods'**
  String get savedFoodsLabel;

  /// No description provided for @foodDatabaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Database'**
  String get foodDatabaseLabel;

  /// No description provided for @scanFoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan Food'**
  String get scanFoodLabel;

  /// No description provided for @exerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseTitle;

  /// No description provided for @runTitle.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get runTitle;

  /// No description provided for @weightLiftingTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Lifting'**
  String get weightLiftingTitle;

  /// No description provided for @describeTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe'**
  String get describeTitle;

  /// No description provided for @runDescription.
  ///
  /// In en, this message translates to:
  /// **'Running, jogging, sprinting, etc.'**
  String get runDescription;

  /// No description provided for @weightLiftingDescription.
  ///
  /// In en, this message translates to:
  /// **'Machines, free weights, etc.'**
  String get weightLiftingDescription;

  /// No description provided for @describeWorkoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Write your workout in text'**
  String get describeWorkoutDescription;

  /// No description provided for @setIntensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Set Intensity'**
  String get setIntensityLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @minutesShortLabel.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get minutesShortLabel;

  /// No description provided for @minutesAbbrevSuffix.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesAbbrevSuffix;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

  /// No description provided for @intensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensityLabel;

  /// No description provided for @intensityHighLabel.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get intensityHighLabel;

  /// No description provided for @intensityMediumLabel.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get intensityMediumLabel;

  /// No description provided for @intensityLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get intensityLowLabel;

  /// No description provided for @runIntensityHighDescription.
  ///
  /// In en, this message translates to:
  /// **'Sprinting - 14 mph (4 minutes miles)'**
  String get runIntensityHighDescription;

  /// No description provided for @runIntensityMediumDescription.
  ///
  /// In en, this message translates to:
  /// **'Jogging - 6 mph (10 minutes miles)'**
  String get runIntensityMediumDescription;

  /// No description provided for @runIntensityLowDescription.
  ///
  /// In en, this message translates to:
  /// **'Chill walk - 3 mph (20 minutes miles)'**
  String get runIntensityLowDescription;

  /// No description provided for @weightIntensityHighDescription.
  ///
  /// In en, this message translates to:
  /// **'Training to failure, breathing heavily'**
  String get weightIntensityHighDescription;

  /// No description provided for @weightIntensityMediumDescription.
  ///
  /// In en, this message translates to:
  /// **'Breaking a sweat, many reps'**
  String get weightIntensityMediumDescription;

  /// No description provided for @weightIntensityLowDescription.
  ///
  /// In en, this message translates to:
  /// **'Not breaking a sweat, giving little effort'**
  String get weightIntensityLowDescription;

  /// No description provided for @exerciseLoggedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Exercise logged successfully!'**
  String get exerciseLoggedSuccessfully;

  /// No description provided for @exerciseParsedAndLogged.
  ///
  /// In en, this message translates to:
  /// **'Exercise parsed and logged!'**
  String get exerciseParsedAndLogged;

  /// No description provided for @describeExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe Exercise'**
  String get describeExerciseTitle;

  /// No description provided for @whatDidYouDoHint.
  ///
  /// In en, this message translates to:
  /// **'What did you do?'**
  String get whatDidYouDoHint;

  /// No description provided for @describeExerciseExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Outdoor hiking for 5 hours, felt exhausted'**
  String get describeExerciseExample;

  /// No description provided for @servingLabel.
  ///
  /// In en, this message translates to:
  /// **'Serving'**
  String get servingLabel;

  /// No description provided for @productNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFoundMessage;

  /// No description provided for @couldNotIdentify.
  ///
  /// In en, this message translates to:
  /// **'Could not identify \"{text}\".'**
  String couldNotIdentify(Object text);

  /// No description provided for @identifyingFoodMessage.
  ///
  /// In en, this message translates to:
  /// **'Identifying food...'**
  String get identifyingFoodMessage;

  /// No description provided for @loggedSuccessfullyMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged successfully!'**
  String get loggedSuccessfullyMessage;

  /// No description provided for @barcodeScannerLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get barcodeScannerLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeLabel;

  /// No description provided for @foodLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Label'**
  String get foodLabel;

  /// No description provided for @galleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryLabel;

  /// No description provided for @bestScanningPracticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Best scanning practices'**
  String get bestScanningPracticesTitle;

  /// No description provided for @generalTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'General tips:'**
  String get generalTipsTitle;

  /// No description provided for @scanTipKeepFoodInside.
  ///
  /// In en, this message translates to:
  /// **'Keep the food inside the scan lines'**
  String get scanTipKeepFoodInside;

  /// No description provided for @scanTipHoldPhoneStill.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone still so the image is not blurry'**
  String get scanTipHoldPhoneStill;

  /// No description provided for @scanTipAvoidObscureAngles.
  ///
  /// In en, this message translates to:
  /// **'Don\'t take the picture at obscure angles'**
  String get scanTipAvoidObscureAngles;

  /// No description provided for @scanNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan now'**
  String get scanNowLabel;

  /// No description provided for @allTabLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTabLabel;

  /// No description provided for @myMealsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'My meals'**
  String get myMealsTabLabel;

  /// No description provided for @myFoodsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'My foods'**
  String get myFoodsTabLabel;

  /// No description provided for @savedScansTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved scans'**
  String get savedScansTabLabel;

  /// No description provided for @logEmptyFoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Log empty food'**
  String get logEmptyFoodLabel;

  /// No description provided for @searchResultsLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResultsLabel;

  /// No description provided for @suggestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsLabel;

  /// No description provided for @noItemsFoundLabel.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get noItemsFoundLabel;

  /// No description provided for @noSuggestionsAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available'**
  String get noSuggestionsAvailableLabel;

  /// No description provided for @noSavedScansYetLabel.
  ///
  /// In en, this message translates to:
  /// **'No saved scans yet'**
  String get noSavedScansYetLabel;

  /// No description provided for @describeWhatYouAteHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you ate'**
  String get describeWhatYouAteHint;

  /// No description provided for @foodAddedToDate.
  ///
  /// In en, this message translates to:
  /// **'Added {foodName} to {dateId}'**
  String foodAddedToDate(Object dateId, Object foodName);

  /// No description provided for @failedToAddFood.
  ///
  /// In en, this message translates to:
  /// **'Failed to add food. Try again.'**
  String get failedToAddFood;

  /// No description provided for @invalidFoodIdMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid Food ID'**
  String get invalidFoodIdMessage;

  /// No description provided for @foodNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Food not found'**
  String get foodNotFoundMessage;

  /// No description provided for @couldNotLoadFoodDetails.
  ///
  /// In en, this message translates to:
  /// **'Could not load food details'**
  String get couldNotLoadFoodDetails;

  /// No description provided for @gramsShortLabel.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get gramsShortLabel;

  /// No description provided for @standardLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardLabel;

  /// No description provided for @selectedFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected food'**
  String get selectedFoodTitle;

  /// No description provided for @measurementLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurementLabel;

  /// No description provided for @otherNutritionFactsLabel.
  ///
  /// In en, this message translates to:
  /// **'Other nutrition facts'**
  String get otherNutritionFactsLabel;

  /// No description provided for @numberOfServingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of servings'**
  String get numberOfServingsLabel;

  /// No description provided for @logLabel.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logLabel;

  /// No description provided for @nutrientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get nutrientsTitle;

  /// No description provided for @totalNutritionLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Nutrition'**
  String get totalNutritionLabel;

  /// No description provided for @enterFoodNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter food name'**
  String get enterFoodNameHint;

  /// No description provided for @kcalLabel.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcalLabel;

  /// No description provided for @statsLabel.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsLabel;

  /// No description provided for @intensityModerateLabel.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get intensityModerateLabel;

  /// No description provided for @thisWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeekLabel;

  /// No description provided for @lastWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeekLabel;

  /// No description provided for @twoWeeksAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'2 wks ago'**
  String get twoWeeksAgoLabel;

  /// No description provided for @threeWeeksAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'3 wks ago'**
  String get threeWeeksAgoLabel;

  /// No description provided for @totalCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get totalCaloriesLabel;

  /// No description provided for @calsLabel.
  ///
  /// In en, this message translates to:
  /// **'cals'**
  String get calsLabel;

  /// No description provided for @dayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get dayShortSun;

  /// No description provided for @dayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayShortMon;

  /// No description provided for @dayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayShortTue;

  /// No description provided for @dayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayShortWed;

  /// No description provided for @dayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayShortThu;

  /// No description provided for @dayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayShortFri;

  /// No description provided for @dayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get dayShortSat;

  /// No description provided for @ninetyDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'90 Days'**
  String get ninetyDaysLabel;

  /// No description provided for @sixMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get sixMonthsLabel;

  /// No description provided for @oneYearLabel.
  ///
  /// In en, this message translates to:
  /// **'1 Year'**
  String get oneYearLabel;

  /// No description provided for @allTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTimeLabel;

  /// No description provided for @waitingForFirstLogLabel.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your first log...'**
  String get waitingForFirstLogLabel;

  /// No description provided for @editGoalPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal Picker'**
  String get editGoalPickerTitle;

  /// No description provided for @bmiDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get bmiDisclaimerTitle;

  /// No description provided for @bmiDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'As with most measures of health, BMI is not a perfect test. For example, results can be thrown off by pregnancy or high muscle mass, and it may not be a good measure of health for child or the elderly.'**
  String get bmiDisclaimerBody;

  /// No description provided for @bmiWhyItMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'So then, why does BMI matter?'**
  String get bmiWhyItMattersTitle;

  /// No description provided for @bmiWhyItMattersBody.
  ///
  /// In en, this message translates to:
  /// **'In general, the higher your BMI, the higher the risk of developing a range of conditions linked with excess weight, including:\\n� diabetes\\n� arthritis\\n� liver disease\\n� several types of cancer (such as those of the breast, colon, and prostate)\\n� high blood pressure (hypertension)\\n� high cholesterol\\n� sleep apnea'**
  String get bmiWhyItMattersBody;

  /// No description provided for @noWeightHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No weight history recorded yet.'**
  String get noWeightHistoryYet;

  /// No description provided for @overLabel.
  ///
  /// In en, this message translates to:
  /// **'over'**
  String get overLabel;

  /// No description provided for @dailyBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Breakdown'**
  String get dailyBreakdownTitle;

  /// No description provided for @editDailyGoalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Daily Goals'**
  String get editDailyGoalsLabel;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @gramsLabel.
  ///
  /// In en, this message translates to:
  /// **'grams'**
  String get gramsLabel;

  /// No description provided for @healthStatusNotEvaluated.
  ///
  /// In en, this message translates to:
  /// **'Not evaluated'**
  String get healthStatusNotEvaluated;

  /// No description provided for @healthStatusCriticallyLow.
  ///
  /// In en, this message translates to:
  /// **'Critically low'**
  String get healthStatusCriticallyLow;

  /// No description provided for @healthStatusNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get healthStatusNeedsImprovement;

  /// No description provided for @healthStatusFairProgress.
  ///
  /// In en, this message translates to:
  /// **'Fair progress'**
  String get healthStatusFairProgress;

  /// No description provided for @healthStatusGoodHealth.
  ///
  /// In en, this message translates to:
  /// **'Good health'**
  String get healthStatusGoodHealth;

  /// No description provided for @healthStatusExcellentHealth.
  ///
  /// In en, this message translates to:
  /// **'Excellent health'**
  String get healthStatusExcellentHealth;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @failedLoadReminderSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reminder settings.'**
  String get failedLoadReminderSettings;

  /// No description provided for @smartNutritionRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart nutrition reminders'**
  String get smartNutritionRemindersTitle;

  /// No description provided for @dailyReminderAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder at'**
  String get dailyReminderAtLabel;

  /// No description provided for @setSmartNutritionTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Set smart nutrition time'**
  String get setSmartNutritionTimeLabel;

  /// No description provided for @waterRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Water reminders'**
  String get waterRemindersTitle;

  /// No description provided for @everyLabel.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get everyLabel;

  /// No description provided for @hourUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'hour(s)'**
  String get hourUnitLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get fromLabel;

  /// No description provided for @setWaterStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Set water start time'**
  String get setWaterStartTimeLabel;

  /// No description provided for @breakfastReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Breakfast reminder'**
  String get breakfastReminderTitle;

  /// No description provided for @lunchReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Lunch reminder'**
  String get lunchReminderTitle;

  /// No description provided for @dinnerReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Dinner reminder'**
  String get dinnerReminderTitle;

  /// No description provided for @snackReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Snack reminder'**
  String get snackReminderTitle;

  /// No description provided for @goalTrackingAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal tracking alerts'**
  String get goalTrackingAlertsTitle;

  /// No description provided for @goalTrackingAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Near/exceed calorie and macro goal alerts'**
  String get goalTrackingAlertsSubtitle;

  /// No description provided for @stepsExerciseReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps / exercise reminder'**
  String get stepsExerciseReminderTitle;

  /// No description provided for @dailyAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily at'**
  String get dailyAtLabel;

  /// No description provided for @setActivityReminderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Set activity reminder time'**
  String get setActivityReminderTimeLabel;

  /// No description provided for @intervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval:'**
  String get intervalLabel;

  /// No description provided for @setTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get setTimeLabel;

  /// No description provided for @languageNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEnglish;

  /// No description provided for @languageNameSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageNameSpanish;

  /// No description provided for @languageNamePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languageNamePortuguese;

  /// No description provided for @languageNameFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageNameFrench;

  /// No description provided for @languageNameGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageNameGerman;

  /// No description provided for @languageNameItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageNameItalian;

  /// No description provided for @languageNameHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageNameHindi;

  /// No description provided for @progressMessageStart.
  ///
  /// In en, this message translates to:
  /// **'Getting started is the hardest part. You\'re ready for this!'**
  String get progressMessageStart;

  /// No description provided for @progressMessageKeepPushing.
  ///
  /// In en, this message translates to:
  /// **'You\'re making progress. Now\'s the time to keep pushing!'**
  String get progressMessageKeepPushing;

  /// No description provided for @progressMessagePayingOff.
  ///
  /// In en, this message translates to:
  /// **'Your dedication is paying off. Keep going!'**
  String get progressMessagePayingOff;

  /// No description provided for @progressMessageFinalStretch.
  ///
  /// In en, this message translates to:
  /// **'It\'s the final stretch. Push yourself!'**
  String get progressMessageFinalStretch;

  /// No description provided for @progressMessageCongrats.
  ///
  /// In en, this message translates to:
  /// **'You did it! Congratulations!'**
  String get progressMessageCongrats;

  /// No description provided for @dayStreakWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Day Streak'**
  String dayStreakWithCount(Object count);

  /// No description provided for @streakLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Lost'**
  String get streakLostTitle;

  /// No description provided for @streakActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re on fire! Keep logging to maintain your momentum.'**
  String get streakActiveSubtitle;

  /// No description provided for @streakLostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t give up. Log your meals today to get back on track.'**
  String get streakLostSubtitle;

  /// No description provided for @dayInitialSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayInitialSun;

  /// No description provided for @dayInitialMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayInitialMon;

  /// No description provided for @dayInitialTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayInitialTue;

  /// No description provided for @dayInitialWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayInitialWed;

  /// No description provided for @dayInitialThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayInitialThu;

  /// No description provided for @dayInitialFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayInitialFri;

  /// No description provided for @dayInitialSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayInitialSat;

  /// No description provided for @alertCalorieGoalExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal exceeded'**
  String get alertCalorieGoalExceededTitle;

  /// No description provided for @alertCalorieGoalExceededBody.
  ///
  /// In en, this message translates to:
  /// **'You are {over} kcal over your daily target.'**
  String alertCalorieGoalExceededBody(Object over);

  /// No description provided for @alertNearCalorieLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'You are near your calorie limit'**
  String get alertNearCalorieLimitTitle;

  /// No description provided for @alertNearCalorieLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} kcal left today. Plan your next meal carefully.'**
  String alertNearCalorieLimitBody(Object remaining);

  /// No description provided for @alertProteinBehindTitle.
  ///
  /// In en, this message translates to:
  /// **'Protein target is behind'**
  String get alertProteinBehindTitle;

  /// No description provided for @alertProteinBehindBody.
  ///
  /// In en, this message translates to:
  /// **'You still need about {missing} g protein to hit today\'s target.'**
  String alertProteinBehindBody(Object missing);

  /// No description provided for @alertCarbTargetExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Carb target exceeded'**
  String get alertCarbTargetExceededTitle;

  /// No description provided for @alertCarbTargetExceededBody.
  ///
  /// In en, this message translates to:
  /// **'Carbs are {over} g over target.'**
  String alertCarbTargetExceededBody(Object over);

  /// No description provided for @alertFatTargetExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Fat target exceeded'**
  String get alertFatTargetExceededTitle;

  /// No description provided for @alertFatTargetExceededBody.
  ///
  /// In en, this message translates to:
  /// **'Fat is {over} g over target.'**
  String alertFatTargetExceededBody(Object over);

  /// No description provided for @smartNutritionTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart nutrition tip'**
  String get smartNutritionTipTitle;

  /// No description provided for @smartNutritionKcalLeft.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal left'**
  String smartNutritionKcalLeft(Object calories);

  /// No description provided for @smartNutritionKcalOver.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal over'**
  String smartNutritionKcalOver(Object calories);

  /// No description provided for @smartNutritionProteinRemaining.
  ///
  /// In en, this message translates to:
  /// **'{protein} g protein remaining'**
  String smartNutritionProteinRemaining(Object protein);

  /// No description provided for @smartNutritionProteinGoalReached.
  ///
  /// In en, this message translates to:
  /// **'protein goal reached'**
  String get smartNutritionProteinGoalReached;

  /// No description provided for @smartNutritionCombinedMessage.
  ///
  /// In en, this message translates to:
  /// **'{calorieMessage} and {proteinMessage}. Log your next meal to stay on track.'**
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  );

  /// No description provided for @notificationStepsExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps and exercise reminder'**
  String get notificationStepsExerciseTitle;

  /// No description provided for @notificationStepsExerciseBody.
  ///
  /// In en, this message translates to:
  /// **'Log your steps or workout to complete today\'s activity target.'**
  String get notificationStepsExerciseBody;

  /// No description provided for @notificationBreakfastTitle.
  ///
  /// In en, this message translates to:
  /// **'Breakfast reminder'**
  String get notificationBreakfastTitle;

  /// No description provided for @notificationBreakfastBody.
  ///
  /// In en, this message translates to:
  /// **'Log breakfast to start your calorie and macro tracking early.'**
  String get notificationBreakfastBody;

  /// No description provided for @notificationLunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Lunch reminder'**
  String get notificationLunchTitle;

  /// No description provided for @notificationLunchBody.
  ///
  /// In en, this message translates to:
  /// **'Lunch time. Add your meal to keep your daily progress accurate.'**
  String get notificationLunchBody;

  /// No description provided for @notificationDinnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Dinner reminder'**
  String get notificationDinnerTitle;

  /// No description provided for @notificationDinnerBody.
  ///
  /// In en, this message translates to:
  /// **'Log dinner and close your day with complete nutrition data.'**
  String get notificationDinnerBody;

  /// No description provided for @notificationSnackTitle.
  ///
  /// In en, this message translates to:
  /// **'Snack reminder'**
  String get notificationSnackTitle;

  /// No description provided for @notificationSnackBody.
  ///
  /// In en, this message translates to:
  /// **'Add your snack so calories and macros stay aligned with your goals.'**
  String get notificationSnackBody;

  /// No description provided for @smartNutritionDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart nutrition check-in'**
  String get smartNutritionDailyTitle;

  /// No description provided for @smartNutritionDailyBody.
  ///
  /// In en, this message translates to:
  /// **'Target {calories} kcal, {protein}g protein, {carbs}g carbs, {fats}g fat. Log your latest meal to keep your plan accurate.'**
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  );

  /// No description provided for @notificationWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Water reminder'**
  String get notificationWaterTitle;

  /// No description provided for @notificationWaterBody.
  ///
  /// In en, this message translates to:
  /// **'Hydration check. Log a glass of water in Cal AI.'**
  String get notificationWaterBody;

  /// No description provided for @homeWidgetLogFoodCta.
  ///
  /// In en, this message translates to:
  /// **'Log your food'**
  String get homeWidgetLogFoodCta;

  /// No description provided for @homeWidgetCaloriesTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Calories today'**
  String get homeWidgetCaloriesTodayTitle;

  /// No description provided for @homeWidgetCaloriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{calories} / {goal} kcal'**
  String homeWidgetCaloriesSubtitle(Object calories, Object goal);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
