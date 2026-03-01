// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Home';

  @override
  String get progressTab => 'Progress';

  @override
  String get settingsTab => 'Settings';

  @override
  String get language => 'Language';

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
  String get personalDetails => 'Personal Details';

  @override
  String get adjustMacronutrients => 'Adjust Macronutrients';

  @override
  String get weightHistory => 'Weight History';

  @override
  String get homeWidget => 'Home Widget';

  @override
  String get chooseHomeWidgets => 'Choose Home Widgets';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Tap options to add or remove widgets.';

  @override
  String get updatingWidgetSelection => 'Updating widget selection...';

  @override
  String get requestingWidgetPermission => 'Requesting widget permission...';

  @override
  String get widget1 => 'Widget 1';

  @override
  String get widget2 => 'Widget 2';

  @override
  String get widget3 => 'Widget 3';

  @override
  String get calorieTrackerWidget => 'Calorie Tracker';

  @override
  String get nutritionTrackerWidget => 'Nutrition Tracker';

  @override
  String get streakTrackerWidget => 'Streak Tracker';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName removed from selection.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'To remove $widgetName, remove it from your home screen. Selection syncs automatically.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'To add $widgetName, long-press the Home Screen, tap +, then select Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return '$widgetName widget added.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Permission needed to add $widgetName. We opened settings for you.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'Could not open permission settings. Please enable permissions manually to add $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen => 'No widgets on home screen';

  @override
  String selectedWidgets(Object widgets) {
    return 'Selected: $widgets';
  }

  @override
  String get backupData => 'Backup your data';

  @override
  String get signInToSync => 'Sign in to sync your progress & goals';

  @override
  String get accountSuccessfullyBackedUp => 'Account successfully backed up!';

  @override
  String get failedToLinkAccount => 'Failed to link account.';

  @override
  String get googleAccountAlreadyLinked =>
      'This Google account is already linked to another Cal AI profile.';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get eatenLabel => 'eaten';

  @override
  String get leftLabel => 'left';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get carbsLabel => 'Carbs';

  @override
  String get fatsLabel => 'Fats';

  @override
  String get fiberLabel => 'Fiber';

  @override
  String get sugarLabel => 'Sugar';

  @override
  String get sodiumLabel => 'Sodium';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get stepsTodayLabel => 'Steps Today';

  @override
  String get caloriesBurnedLabel => 'Calories Burned';

  @override
  String get stepTrackingActive => 'Step tracking active!';

  @override
  String get waterLabel => 'Water';

  @override
  String get servingSizeLabel => 'Serving Size';

  @override
  String get waterSettingsTitle => 'Water settings';

  @override
  String get hydrationQuestion =>
      'How much water do you need to stay hydrated?';

  @override
  String get hydrationInfo =>
      'Everyone\'s needs are slightly different, but we recommend aiming for at least 64 fl oz (8 cups) of water each day.';

  @override
  String get healthScoreTitle => 'Health score';

  @override
  String get healthSummaryNoData =>
      'No data logged for today. Start tracking your meals to see your health insights!';

  @override
  String get healthSummaryLowIntake =>
      'Your intake is quite low. Focus on hitting your calorie and protein targets to maintain energy and muscle.';

  @override
  String get healthSummaryLowProtein =>
      'Carbs and fat are on track, but you\'re low in protein. Increasing protein can help with muscle retention.';

  @override
  String get healthSummaryGreat =>
      'Great job! Your nutrition is well-balanced today.';

  @override
  String get recentlyLoggedTitle => 'Recently logged';

  @override
  String errorLoadingLogs(Object error) {
    return 'Error loading logs: $error';
  }

  @override
  String get deleteLabel => 'Delete';

  @override
  String get tapToAddFirstEntry => 'Tap + to add your first entry';

  @override
  String unableToLoadProgress(Object error) {
    return 'Unable to load progress: $error';
  }

  @override
  String get myWeightTitle => 'My Weight';

  @override
  String goalWithValue(Object value) {
    return 'Goal $value';
  }

  @override
  String get noGoalSet => 'No Goal Set';

  @override
  String get logWeightCta => 'Log Weight';

  @override
  String get dayStreakTitle => 'Day streak';

  @override
  String get progressPhotosTitle => 'Progress Photos';

  @override
  String get progressPhotoPrompt =>
      'Want to add a photo to track your progress?';

  @override
  String get uploadPhotoCta => 'Upload a Photo';

  @override
  String get goalProgressTitle => 'Goal Progress';

  @override
  String get ofGoalLabel => 'of goal';

  @override
  String get logoutLabel => 'Logout';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get preferencesLabel => 'Preferences';

  @override
  String get appearanceLabel => 'Appearance';

  @override
  String get appearanceDescription =>
      'Choose light, dark, or system appearance';

  @override
  String get lightLabel => 'Light';

  @override
  String get darkLabel => 'Dark';

  @override
  String get automaticLabel => 'Automatic';

  @override
  String get addBurnedCaloriesLabel => 'Add Burned Calories';

  @override
  String get addBurnedCaloriesDescription =>
      'Add burned calories to daily goal';

  @override
  String get rolloverCaloriesLabel => 'Rollover Calories';

  @override
  String get rolloverCaloriesDescription =>
      'Add up to 200 leftover calories into today\'s goal';

  @override
  String get measurementUnitLabel => 'Measurement unit';

  @override
  String get measurementUnitDescription =>
      'All values will be converted to imperial (currently on metrics)';

  @override
  String get inviteFriendsLabel => 'Invite friends';

  @override
  String get defaultUserName => 'user';

  @override
  String get enterYourNameLabel => 'Enter your name';

  @override
  String yearsOldLabel(Object years) {
    return '$years years old';
  }

  @override
  String get termsAndConditionsLabel => 'Terms and Conditions';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get supportEmailLabel => 'Support Email';

  @override
  String get featureRequestLabel => 'Feature Request';

  @override
  String get deleteAccountQuestion => 'Delete Account?';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountMessage =>
      'Are you absolutely sure? This will permanently delete your Cal AI history, weight logs, and custom goals. This action cannot be undone.';

  @override
  String get deletePermanentlyLabel => 'Delete Permanently';

  @override
  String get onboardingChooseGenderTitle => 'Choose your Gender';

  @override
  String get onboardingChooseGenderSubtitle =>
      'This will be used to calibrate your custom plan.';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get genderOther => 'Other';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'How many workouts do you do per week?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'This will be used to calibrate your custom plan.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Workouts now and then';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle => 'A few workouts per week';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Dedicated athlete';

  @override
  String get onboardingHearAboutUsTitle => 'Where did you hear about us?';

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
  String get sourceFriendFamily => 'Friend or family';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Other';

  @override
  String get yourBmiTitle => 'Your BMI';

  @override
  String get yourWeightIsLabel => 'Your weight is';

  @override
  String get bmiUnderweightLabel => 'Underweight';

  @override
  String get bmiHealthyLabel => 'Healthy';

  @override
  String get bmiOverweightLabel => 'Overweight';

  @override
  String get bmiObeseLabel => 'Obese';

  @override
  String get calorieTrackingMadeEasy => 'Calorie tracking made easy';

  @override
  String get onboardingStep1Title => 'Track your meals';

  @override
  String get onboardingStep1Description =>
      'Log your meals easily and track your nutrition.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String signInFailed(Object error) {
    return 'Sign in failed: $error';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get skipLabel => 'Skip';

  @override
  String get noLabel => 'No';

  @override
  String get yesLabel => 'Yes';

  @override
  String get submitLabel => 'Submit';

  @override
  String get referralCodeLabel => 'Referral Code';

  @override
  String get heightLabel => 'Height';

  @override
  String get weightLabel => 'Weight';

  @override
  String get imperialLabel => 'Imperial';

  @override
  String get metricLabel => 'Metric';

  @override
  String get month1Label => 'Month 1';

  @override
  String get month6Label => 'Month 6';

  @override
  String get traditionalDietLabel => 'Traditional Diet';

  @override
  String get weightChartSummary =>
      '80% of Cal AI users maintain their weight loss even 6 months later';

  @override
  String get comparisonWithoutCalAi => 'Without\\nCal AI';

  @override
  String get comparisonWithCalAi => 'With\\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI makes it easy and holds';

  @override
  String get comparisonBottomLine2 => 'you accountable';

  @override
  String get speedSlowSteady => 'Slow and steady';

  @override
  String get speedRecommended => 'Recommended';

  @override
  String get speedAggressiveWarning =>
      'You may feel very tired and develop loose skin';

  @override
  String get subscriptionHeadline =>
      'Unlock CalAI to reach\\nyour goals faster.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Just PHP $yearlyPrice per year (PHP $monthlyPrice/mo)';
  }

  @override
  String get goalGainWeight => 'Gain Weight';

  @override
  String get goalLoseWeight => 'Lose Weight';

  @override
  String get goalMaintainWeight => 'Maintain Weight';

  @override
  String editGoalTitle(Object title) {
    return 'Edit $title Goal';
  }

  @override
  String get revertLabel => 'Revert';

  @override
  String get doneLabel => 'Done';

  @override
  String get dashboardShouldGainWeight => 'gain';

  @override
  String get dashboardShouldLoseWeight => 'lose';

  @override
  String get dashboardShouldMaintainWeight => 'maintain';

  @override
  String get dashboardCongratsPlanReady =>
      'Congratulations\\nyour custom plan is ready!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'You should $action:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit by $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Daily Recommendation';

  @override
  String get dashboardEditAnytime => 'You can edit this any time';

  @override
  String get dashboardHowToReachGoals => 'How to reach your goals:';

  @override
  String get dashboardReachGoalLifeScore =>
      'Get your weekly life score and improve your routine.';

  @override
  String get dashboardReachGoalTrackFood => 'Track your food';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Follow your daily calorie recommendation';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Balance your carbs, protein, fat';

  @override
  String get dashboardPlanSourcesTitle =>
      'Plan based on the following sources, among other peer-reviewed medical studies:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Basal metabolic rate';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Calorie counting - Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'International Society of Sports Nutrition';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'National Institutes of Health';

  @override
  String get factorsNetCarbsMass => 'Net carbs / mass';

  @override
  String get factorsNetCarbDensity => 'Net carb density';

  @override
  String get factorsSodiumMass => 'Sodium / mass';

  @override
  String get factorsSodiumDensity => 'Sodium density';

  @override
  String get factorsSugarMass => 'Sugar / mass';

  @override
  String get factorsSugarDensity => 'Sugar density';

  @override
  String get factorsProcessedScore => 'Processed score';

  @override
  String get factorsIngredientQuality => 'Ingredient quality';

  @override
  String get factorsProcessedScoreDescription =>
      'The processed score takes into account dyes, nitrates, seed oils, artificial flavoring / sweeteners, and other factors.';

  @override
  String get healthScoreExplanationIntro =>
      'Our health score is a complex formula taking into account several factors given a multitude of common foods.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'Below are the factors we take into account when calculating health score:';

  @override
  String get netCarbsLabel => 'Net carbs';

  @override
  String get howDoesItWork => 'How does it work?';

  @override
  String get goodLabel => 'Good';

  @override
  String get badLabel => 'Bad';

  @override
  String get dailyRecommendationFor => 'Daily recommendation for';

  @override
  String get loadingCustomizingHealthPlan => 'Customizing health plan...';

  @override
  String get loadingApplyingBmrFormula => 'Applying BMR formula...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'Estimating your metabolic age...';

  @override
  String get loadingFinalizingResults => 'Finalizing results...';

  @override
  String get loadingSetupForYou => 'We\'re setting everything\\nup for you';

  @override
  String get step4TriedOtherCalorieApps =>
      'Have you tried other calorie tracking apps?';

  @override
  String get step5CalAiLongTermResults => 'Cal AI creates long-term results';

  @override
  String get step6HeightWeightTitle => 'Height & Weight';

  @override
  String get step6HeightWeightSubtitle =>
      'This will be taken into account when calculating your daily nutrition goals.';

  @override
  String get step7WhenWereYouBorn => 'When were you born?';

  @override
  String get step8GoalQuestionTitle => 'What is your goal?';

  @override
  String get step8GoalQuestionSubtitle =>
      'This helps us generate a plan for your calorie intake.';

  @override
  String get step9SpecificDietQuestion => 'Do you follow a specific diet?';

  @override
  String get step9DietClassic => 'Classic';

  @override
  String get step9DietPescatarian => 'Pescatarian';

  @override
  String get step9DietVegetarian => 'Vegetarian';

  @override
  String get step9DietVegan => 'Vegan';

  @override
  String get step91DesiredWeightQuestion => 'What is your desired weight?';

  @override
  String get step92GoalActionGaining => 'Gaining';

  @override
  String get step92GoalActionLosing => 'Losing';

  @override
  String get step92RealisticTargetSuffix =>
      ' is a realistic target. It\'s not hard at all!';

  @override
  String get step92SocialProof =>
      '90% of users say the change is obvious after using Cal AI, and it\'s not easy to rebound.';

  @override
  String get step93GoalVerbGain => 'Gain';

  @override
  String get step93GoalVerbLose => 'Lose';

  @override
  String get step93SpeedQuestionTitle =>
      'How fast do you want to reach your goal?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return '$action weight speed per week';
  }

  @override
  String get step94ComparisonTitle =>
      'Lose twice as much weight with Cal AI vs on your own';

  @override
  String get step95ObstaclesTitle =>
      'What\'s stopping you from reaching your goals?';

  @override
  String get step10AccomplishTitle => 'What would you like to accomplish?';

  @override
  String get step10OptionHealthier => 'Eat and live healthier';

  @override
  String get step10OptionEnergyMood => 'Boost my energy and mood';

  @override
  String get step10OptionConsistency => 'Stay motivated and consistent';

  @override
  String get step10OptionBodyConfidence => 'Feel better about my body';

  @override
  String get step11PotentialTitle =>
      'You have great potential to crush your goal';

  @override
  String get step12ThankYouTitle => 'Thank you for\\ntrusting us!';

  @override
  String get step12PersonalizeSubtitle =>
      'Now let\'s personalize Cal AI for you...';

  @override
  String get step12PrivacyCardTitle =>
      'Your privacy and security matter to us.';

  @override
  String get step12PrivacyCardBody =>
      'We promise to always keep your\\npersonal information private and secure.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Reach your goals with notifications';

  @override
  String get step13NotificationPrompt =>
      'Cal AI would like to send you notifications';

  @override
  String get allowLabel => 'Allow';

  @override
  String get dontAllowLabel => 'Don\'t Allow';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'Add calories burned back to your daily goal?';

  @override
  String get step15RolloverQuestion =>
      'Rollover extra calories to the next day?';

  @override
  String get step15RolloverUpTo => 'Rollover up to ';

  @override
  String get step15RolloverCap => '200 cals';

  @override
  String get step16ReferralTitle => 'Enter referral code (optional)';

  @override
  String get step16ReferralSubtitle => 'You can skip this step';

  @override
  String get step17AllDone => 'All done!';

  @override
  String get step17GeneratePlanTitle => 'Time to generate your custom plan!';

  @override
  String get step18CalculationError =>
      'Could not calculate plan. Please check your connection.';

  @override
  String get step18TryAgain => 'Try Again';

  @override
  String get step19CreateAccountTitle => 'Create an account';

  @override
  String get authInvalidEmailMessage => 'Please enter a valid email address';

  @override
  String get authCheckYourEmailTitle => 'Check your email';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'We sent a sign-in link to $email';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get authWhatsYourEmail => 'What\'s your email?';

  @override
  String get authPasswordlessHint =>
      'We\'ll send you a link to sign in without a password.';

  @override
  String get emailExampleHint => 'name@example.com';

  @override
  String get notSetLabel => 'Not set';

  @override
  String get goalWeightLabel => 'Goal Weight';

  @override
  String get changeGoalLabel => 'Change Goal';

  @override
  String get currentWeightLabel => 'Current Weight';

  @override
  String get dateOfBirthLabel => 'Date of birth';

  @override
  String get genderLabel => 'Gender';

  @override
  String get dailyStepGoalLabel => 'Daily Step Goal';

  @override
  String get stepGoalLabel => 'Step Goal';

  @override
  String get setHeightTitle => 'Set Height';

  @override
  String get setGenderTitle => 'Set Gender';

  @override
  String get setBirthdayTitle => 'Set Birthday';

  @override
  String get setWeightTitle => 'Set Weight';

  @override
  String get editNameTitle => 'Edit name';

  @override
  String get calorieGoalLabel => 'Calorie goal';

  @override
  String get proteinGoalLabel => 'Protein goal';

  @override
  String get carbGoalLabel => 'Carb goal';

  @override
  String get fatGoalLabel => 'Fat goal';

  @override
  String get sugarLimitLabel => 'Sugar limit';

  @override
  String get fiberGoalLabel => 'Fiber goal';

  @override
  String get sodiumLimitLabel => 'Sodium limit';

  @override
  String get hideMicronutrientsLabel => 'Hide micronutrients';

  @override
  String get viewMicronutrientsLabel => 'View micronutrients';

  @override
  String get autoGenerateGoalsLabel => 'Auto Generate Goals';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Failed to generate goals: $error';
  }

  @override
  String get calculatingCustomGoals => 'Calculating your custom goals...';

  @override
  String get logExerciseLabel => 'Log Exercise';

  @override
  String get savedFoodsLabel => 'Saved Foods';

  @override
  String get foodDatabaseLabel => 'Food Database';

  @override
  String get scanFoodLabel => 'Scan Food';

  @override
  String get exerciseTitle => 'Exercise';

  @override
  String get runTitle => 'Run';

  @override
  String get weightLiftingTitle => 'Weight Lifting';

  @override
  String get describeTitle => 'Describe';

  @override
  String get runDescription => 'Running, jogging, sprinting, etc.';

  @override
  String get weightLiftingDescription => 'Machines, free weights, etc.';

  @override
  String get describeWorkoutDescription => 'Write your workout in text';

  @override
  String get setIntensityLabel => 'Set Intensity';

  @override
  String get durationLabel => 'Duration';

  @override
  String get minutesShortLabel => 'mins';

  @override
  String get minutesAbbrevSuffix => 'm';

  @override
  String get addLabel => 'Add';

  @override
  String get intensityLabel => 'Intensity';

  @override
  String get intensityHighLabel => 'High';

  @override
  String get intensityMediumLabel => 'Medium';

  @override
  String get intensityLowLabel => 'Low';

  @override
  String get runIntensityHighDescription =>
      'Sprinting - 14 mph (4 minutes miles)';

  @override
  String get runIntensityMediumDescription =>
      'Jogging - 6 mph (10 minutes miles)';

  @override
  String get runIntensityLowDescription =>
      'Chill walk - 3 mph (20 minutes miles)';

  @override
  String get weightIntensityHighDescription =>
      'Training to failure, breathing heavily';

  @override
  String get weightIntensityMediumDescription => 'Breaking a sweat, many reps';

  @override
  String get weightIntensityLowDescription =>
      'Not breaking a sweat, giving little effort';

  @override
  String get exerciseLoggedSuccessfully => 'Exercise logged successfully!';

  @override
  String get exerciseParsedAndLogged => 'Exercise parsed and logged!';

  @override
  String get describeExerciseTitle => 'Describe Exercise';

  @override
  String get whatDidYouDoHint => 'What did you do?';

  @override
  String get describeExerciseExample =>
      'Example: Outdoor hiking for 5 hours, felt exhausted';

  @override
  String get servingLabel => 'Serving';

  @override
  String get productNotFoundMessage => 'Product not found.';

  @override
  String couldNotIdentify(Object text) {
    return 'Could not identify \"$text\".';
  }

  @override
  String get identifyingFoodMessage => 'Identifying food...';

  @override
  String get loggedSuccessfullyMessage => 'Logged successfully!';

  @override
  String get barcodeScannerLabel => 'Barcode Scanner';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get foodLabel => 'Food Label';

  @override
  String get galleryLabel => 'Gallery';

  @override
  String get bestScanningPracticesTitle => 'Best scanning practices';

  @override
  String get generalTipsTitle => 'General tips:';

  @override
  String get scanTipKeepFoodInside => 'Keep the food inside the scan lines';

  @override
  String get scanTipHoldPhoneStill =>
      'Hold your phone still so the image is not blurry';

  @override
  String get scanTipAvoidObscureAngles =>
      'Don\'t take the picture at obscure angles';

  @override
  String get scanNowLabel => 'Scan now';

  @override
  String get allTabLabel => 'All';

  @override
  String get myMealsTabLabel => 'My meals';

  @override
  String get myFoodsTabLabel => 'My foods';

  @override
  String get savedScansTabLabel => 'Saved scans';

  @override
  String get logEmptyFoodLabel => 'Log empty food';

  @override
  String get searchResultsLabel => 'Search Results';

  @override
  String get suggestionsLabel => 'Suggestions';

  @override
  String get noItemsFoundLabel => 'No items found.';

  @override
  String get noSuggestionsAvailableLabel => 'No suggestions available';

  @override
  String get noSavedScansYetLabel => 'No saved scans yet';

  @override
  String get describeWhatYouAteHint => 'Describe what you ate';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return 'Added $foodName to $dateId';
  }

  @override
  String get failedToAddFood => 'Failed to add food. Try again.';

  @override
  String get invalidFoodIdMessage => 'Invalid Food ID';

  @override
  String get foodNotFoundMessage => 'Food not found';

  @override
  String get couldNotLoadFoodDetails => 'Could not load food details';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Standard';

  @override
  String get selectedFoodTitle => 'Selected food';

  @override
  String get measurementLabel => 'Measurement';

  @override
  String get otherNutritionFactsLabel => 'Other nutrition facts';

  @override
  String get numberOfServingsLabel => 'Number of servings';

  @override
  String get logLabel => 'Log';

  @override
  String get nutrientsTitle => 'Nutrients';

  @override
  String get totalNutritionLabel => 'Total Nutrition';

  @override
  String get enterFoodNameHint => 'Enter food name';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get statsLabel => 'Stats';

  @override
  String get intensityModerateLabel => 'Moderate';

  @override
  String get thisWeekLabel => 'This Week';

  @override
  String get lastWeekLabel => 'Last Week';

  @override
  String get twoWeeksAgoLabel => '2 wks ago';

  @override
  String get threeWeeksAgoLabel => '3 wks ago';

  @override
  String get totalCaloriesLabel => 'Total Calories';

  @override
  String get calsLabel => 'cals';

  @override
  String get dayShortSun => 'Sun';

  @override
  String get dayShortMon => 'Mon';

  @override
  String get dayShortTue => 'Tue';

  @override
  String get dayShortWed => 'Wed';

  @override
  String get dayShortThu => 'Thu';

  @override
  String get dayShortFri => 'Fri';

  @override
  String get dayShortSat => 'Sat';

  @override
  String get ninetyDaysLabel => '90 Days';

  @override
  String get sixMonthsLabel => '6 Months';

  @override
  String get oneYearLabel => '1 Year';

  @override
  String get allTimeLabel => 'All time';

  @override
  String get waitingForFirstLogLabel => 'Waiting for your first log...';

  @override
  String get editGoalPickerTitle => 'Edit Goal Picker';

  @override
  String get bmiDisclaimerTitle => 'Disclaimer';

  @override
  String get bmiDisclaimerBody =>
      'As with most measures of health, BMI is not a perfect test. For example, results can be thrown off by pregnancy or high muscle mass, and it may not be a good measure of health for child or the elderly.';

  @override
  String get bmiWhyItMattersTitle => 'So then, why does BMI matter?';

  @override
  String get bmiWhyItMattersBody =>
      'In general, the higher your BMI, the higher the risk of developing a range of conditions linked with excess weight, including:\\n� diabetes\\n� arthritis\\n� liver disease\\n� several types of cancer (such as those of the breast, colon, and prostate)\\n� high blood pressure (hypertension)\\n� high cholesterol\\n� sleep apnea';

  @override
  String get noWeightHistoryYet => 'No weight history recorded yet.';

  @override
  String get overLabel => 'over';

  @override
  String get dailyBreakdownTitle => 'Daily Breakdown';

  @override
  String get editDailyGoalsLabel => 'Edit Daily Goals';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get gramsLabel => 'grams';

  @override
  String get healthStatusNotEvaluated => 'Not evaluated';

  @override
  String get healthStatusCriticallyLow => 'Critically low';

  @override
  String get healthStatusNeedsImprovement => 'Needs improvement';

  @override
  String get healthStatusFairProgress => 'Fair progress';

  @override
  String get healthStatusGoodHealth => 'Good health';

  @override
  String get healthStatusExcellentHealth => 'Excellent health';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get failedLoadReminderSettings => 'Failed to load reminder settings.';

  @override
  String get smartNutritionRemindersTitle => 'Smart nutrition reminders';

  @override
  String get dailyReminderAtLabel => 'Daily reminder at';

  @override
  String get setSmartNutritionTimeLabel => 'Set smart nutrition time';

  @override
  String get waterRemindersTitle => 'Water reminders';

  @override
  String get everyLabel => 'Every';

  @override
  String get hourUnitLabel => 'hour(s)';

  @override
  String get fromLabel => 'from';

  @override
  String get setWaterStartTimeLabel => 'Set water start time';

  @override
  String get breakfastReminderTitle => 'Breakfast reminder';

  @override
  String get lunchReminderTitle => 'Lunch reminder';

  @override
  String get dinnerReminderTitle => 'Dinner reminder';

  @override
  String get snackReminderTitle => 'Snack reminder';

  @override
  String get goalTrackingAlertsTitle => 'Goal tracking alerts';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Near/exceed calorie and macro goal alerts';

  @override
  String get stepsExerciseReminderTitle => 'Steps / exercise reminder';

  @override
  String get dailyAtLabel => 'Daily at';

  @override
  String get setActivityReminderTimeLabel => 'Set activity reminder time';

  @override
  String get intervalLabel => 'Interval:';

  @override
  String get setTimeLabel => 'Set time';

  @override
  String get languageNameEnglish => 'English';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNamePortuguese => 'Português';

  @override
  String get languageNameFrench => 'Français';

  @override
  String get languageNameGerman => 'Deutsch';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Getting started is the hardest part. You\'re ready for this!';

  @override
  String get progressMessageKeepPushing =>
      'You\'re making progress. Now\'s the time to keep pushing!';

  @override
  String get progressMessagePayingOff =>
      'Your dedication is paying off. Keep going!';

  @override
  String get progressMessageFinalStretch =>
      'It\'s the final stretch. Push yourself!';

  @override
  String get progressMessageCongrats => 'You did it! Congratulations!';

  @override
  String dayStreakWithCount(Object count) {
    return '$count Day Streak';
  }

  @override
  String get streakLostTitle => 'Streak Lost';

  @override
  String get streakActiveSubtitle =>
      'You\'re on fire! Keep logging to maintain your momentum.';

  @override
  String get streakLostSubtitle =>
      'Don\'t give up. Log your meals today to get back on track.';

  @override
  String get dayInitialSun => 'S';

  @override
  String get dayInitialMon => 'M';

  @override
  String get dayInitialTue => 'T';

  @override
  String get dayInitialWed => 'W';

  @override
  String get dayInitialThu => 'T';

  @override
  String get dayInitialFri => 'F';

  @override
  String get dayInitialSat => 'S';

  @override
  String get alertCalorieGoalExceededTitle => 'Calorie goal exceeded';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'You are $over kcal over your daily target.';
  }

  @override
  String get alertNearCalorieLimitTitle => 'You are near your calorie limit';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Only $remaining kcal left today. Plan your next meal carefully.';
  }

  @override
  String get alertProteinBehindTitle => 'Protein target is behind';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'You still need about $missing g protein to hit today\'s target.';
  }

  @override
  String get alertCarbTargetExceededTitle => 'Carb target exceeded';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'Carbs are $over g over target.';
  }

  @override
  String get alertFatTargetExceededTitle => 'Fat target exceeded';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'Fat is $over g over target.';
  }

  @override
  String get smartNutritionTipTitle => 'Smart nutrition tip';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal left';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal over';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g protein remaining';
  }

  @override
  String get smartNutritionProteinGoalReached => 'protein goal reached';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage and $proteinMessage. Log your next meal to stay on track.';
  }

  @override
  String get notificationStepsExerciseTitle => 'Steps and exercise reminder';

  @override
  String get notificationStepsExerciseBody =>
      'Log your steps or workout to complete today\'s activity target.';

  @override
  String get notificationBreakfastTitle => 'Breakfast reminder';

  @override
  String get notificationBreakfastBody =>
      'Log breakfast to start your calorie and macro tracking early.';

  @override
  String get notificationLunchTitle => 'Lunch reminder';

  @override
  String get notificationLunchBody =>
      'Lunch time. Add your meal to keep your daily progress accurate.';

  @override
  String get notificationDinnerTitle => 'Dinner reminder';

  @override
  String get notificationDinnerBody =>
      'Log dinner and close your day with complete nutrition data.';

  @override
  String get notificationSnackTitle => 'Snack reminder';

  @override
  String get notificationSnackBody =>
      'Add your snack so calories and macros stay aligned with your goals.';

  @override
  String get smartNutritionDailyTitle => 'Smart nutrition check-in';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Target $calories kcal, ${protein}g protein, ${carbs}g carbs, ${fats}g fat. Log your latest meal to keep your plan accurate.';
  }

  @override
  String get notificationWaterTitle => 'Water reminder';

  @override
  String get notificationWaterBody =>
      'Hydration check. Log a glass of water in Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Log your food';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Calories today';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories / $goal kcal';
  }
}
