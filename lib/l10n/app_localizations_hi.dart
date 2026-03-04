// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'होम';

  @override
  String get progressTab => 'प्रगति';

  @override
  String get settingsTab => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get welcomeMessage => 'कैल एआई में आपका स्वागत है';

  @override
  String get trackMessage => 'होशियारी से ट्रैक करें. बेहतर खाओ।';

  @override
  String get getStarted => 'शुरू हो जाओ';

  @override
  String get alreadyAccount => 'क्या आपके पास पहले से एक खाता मौजूद है?';

  @override
  String get signIn => 'दाखिल करना';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get adjustMacronutrients => 'मैक्रोन्यूट्रिएंट्स को समायोजित करें';

  @override
  String get weightHistory => 'वज़न इतिहास';

  @override
  String get homeWidget => 'होम विजेट';

  @override
  String get chooseHomeWidgets => 'होम विजेट चुनें';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'विजेट जोड़ने या हटाने के लिए विकल्प टैप करें।';

  @override
  String get updatingWidgetSelection => 'विजेट चयन अपडेट किया जा रहा है...';

  @override
  String get requestingWidgetPermission =>
      'विजेट अनुमति का अनुरोध किया जा रहा है...';

  @override
  String get widget1 => 'विजेट 1';

  @override
  String get widget2 => 'विजेट 2';

  @override
  String get widget3 => 'विजेट 3';

  @override
  String get calorieTrackerWidget => 'कैलोरी ट्रैकर';

  @override
  String get nutritionTrackerWidget => 'पोषण ट्रैकर';

  @override
  String get streakTrackerWidget => 'स्ट्रीक ट्रैकर';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName को चयन से हटा दिया गया।';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return '$widgetName को हटाने के लिए, इसे अपनी होम स्क्रीन से हटा दें। चयन स्वचालित रूप से सिंक हो जाता है.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return '$widgetName जोड़ने के लिए, होम स्क्रीन को देर तक दबाएँ, + टैप करें, फिर Cal AI चुनें।';
  }

  @override
  String widgetAdded(Object widgetName) {
    return '$widgetName विजेट जोड़ा गया।';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return '$widgetName जोड़ने के लिए अनुमति की आवश्यकता है। हमने आपके लिए सेटिंग खोली हैं.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'अनुमति सेटिंग्स नहीं खोली जा सकीं. कृपया $widgetName जोड़ने के लिए अनुमतियाँ मैन्युअल रूप से सक्षम करें।';
  }

  @override
  String get noWidgetsOnHomeScreen => 'होम स्क्रीन पर कोई विजेट नहीं';

  @override
  String selectedWidgets(Object widgets) {
    return 'चयनित: $widgets';
  }

  @override
  String get backupData => 'अपने डेटा का बैकअप लें';

  @override
  String get signInToSync =>
      'अपनी प्रगति और लक्ष्यों को समन्वयित करने के लिए साइन इन करें';

  @override
  String get accountSuccessfullyBackedUp => 'खाते का सफलतापूर्वक बैकअप हो गया!';

  @override
  String get failedToLinkAccount => 'खाता लिंक करने में विफल.';

  @override
  String get googleAccountAlreadyLinked =>
      'यह Google खाता पहले से ही किसी अन्य Cal AI प्रोफ़ाइल से लिंक है।';

  @override
  String get caloriesLabel => 'कैलोरी';

  @override
  String get eatenLabel => 'खाया';

  @override
  String get leftLabel => 'शेष';

  @override
  String get proteinLabel => 'प्रोटीन';

  @override
  String get carbsLabel => 'कार्बोहाइड्रेट';

  @override
  String get fatsLabel => 'वसा';

  @override
  String get fiberLabel => 'रेशा';

  @override
  String get sugarLabel => 'चीनी';

  @override
  String get sodiumLabel => 'सोडियम';

  @override
  String get stepsLabel => 'कदम';

  @override
  String get stepsTodayLabel => 'आज के कदम';

  @override
  String get caloriesBurnedLabel => 'कैलोरी जला दिया';

  @override
  String get stepTrackingActive => 'चरण ट्रैकिंग सक्रिय!';

  @override
  String get waterLabel => 'पानी';

  @override
  String get servingSizeLabel => 'सेवारत आकार';

  @override
  String get waterSettingsTitle => 'जल सेटिंग';

  @override
  String get hydrationQuestion =>
      'हाइड्रेटेड रहने के लिए आपको कितना पानी चाहिए?';

  @override
  String get hydrationInfo =>
      'हर किसी की ज़रूरतें थोड़ी अलग होती हैं, लेकिन हम हर दिन कम से कम 64 फ़्लूड आउंस (8 कप) पानी पीने का लक्ष्य रखने की सलाह देते हैं।';

  @override
  String get healthScoreTitle => 'स्वास्थ्य स्कोर';

  @override
  String get healthSummaryNoData =>
      'आज के लिए कोई डेटा लॉग नहीं किया गया. अपने स्वास्थ्य संबंधी जानकारी देखने के लिए अपने भोजन पर नज़र रखना शुरू करें!';

  @override
  String get healthSummaryLowIntake =>
      'आपका सेवन काफी कम है. ऊर्जा और मांसपेशियों को बनाए रखने के लिए अपने कैलोरी और प्रोटीन लक्ष्य को हासिल करने पर ध्यान दें।';

  @override
  String get healthSummaryLowProtein =>
      'कार्ब्स और वसा सही रास्ते पर हैं, लेकिन आपमें प्रोटीन कम है। प्रोटीन बढ़ाने से मांसपेशियों को बनाए रखने में मदद मिल सकती है।';

  @override
  String get healthSummaryGreat => 'अच्छा काम! आज आपका पोषण संतुलित है।';

  @override
  String get recentlyLoggedTitle => 'हाल ही में लॉग किया गया';

  @override
  String errorLoadingLogs(Object error) {
    return 'लॉग लोड करने में त्रुटि: $error';
  }

  @override
  String get deleteLabel => 'मिटाना';

  @override
  String get tapToAddFirstEntry =>
      'अपनी पहली प्रविष्टि जोड़ने के लिए + टैप करें';

  @override
  String unableToLoadProgress(Object error) {
    return 'प्रगति लोड करने में असमर्थ: $error';
  }

  @override
  String get myWeightTitle => 'मेरा वज़न';

  @override
  String goalWithValue(Object value) {
    return 'लक्ष्य $value';
  }

  @override
  String get noGoalSet => 'कोई लक्ष्य निर्धारित नहीं';

  @override
  String get logWeightCta => 'वजन लॉग करें';

  @override
  String get dayStreakTitle => 'दिन का सिलसिला';

  @override
  String get progressPhotosTitle => 'प्रगति तस्वीरें';

  @override
  String get progressPhotoPrompt =>
      'क्या आप अपनी प्रगति को ट्रैक करने के लिए कोई फ़ोटो जोड़ना चाहते हैं?';

  @override
  String get uploadPhotoCta => 'फोटो अपलोड करें';

  @override
  String get goalProgressTitle => 'लक्ष्य प्रगति';

  @override
  String get ofGoalLabel => 'लक्ष्य का';

  @override
  String get logoutLabel => 'लॉग आउट';

  @override
  String get logoutTitle => 'लॉग आउट';

  @override
  String get logoutConfirmMessage => 'क्या आप लॉग आउट करना चाहते हैं?';

  @override
  String get cancelLabel => 'रद्द करना';

  @override
  String get preferencesLabel => 'प्राथमिकताएँ';

  @override
  String get appearanceLabel => 'उपस्थिति';

  @override
  String get appearanceDescription => 'हल्का, गहरा या सिस्टम स्वरूप चुनें';

  @override
  String get lightLabel => 'रोशनी';

  @override
  String get darkLabel => 'अँधेरा';

  @override
  String get automaticLabel => 'स्वचालित';

  @override
  String get addBurnedCaloriesLabel => 'जली हुई कैलोरी जोड़ें';

  @override
  String get addBurnedCaloriesDescription =>
      'दैनिक लक्ष्य में जली हुई कैलोरी जोड़ें';

  @override
  String get rolloverCaloriesLabel => 'रोलओवर कैलोरी';

  @override
  String get rolloverCaloriesDescription =>
      'आज के लक्ष्य में 200 तक बची हुई कैलोरी जोड़ें';

  @override
  String get measurementUnitLabel => 'मापन इकाई';

  @override
  String get measurementUnitDescription =>
      'सभी मानों को इंपीरियल में बदल दिया जाएगा (वर्तमान में मेट्रिक्स पर)';

  @override
  String get inviteFriendsLabel => 'मित्रों को आमंत्रित करें';

  @override
  String get defaultUserName => 'उपयोगकर्ता';

  @override
  String get enterYourNameLabel => 'अपना नाम दर्ज करें';

  @override
  String yearsOldLabel(Object years) {
    return '$years वर्ष पुराना';
  }

  @override
  String get termsAndConditionsLabel => 'नियम और शर्तें';

  @override
  String get privacyPolicyLabel => 'गोपनीयता नीति';

  @override
  String get supportEmailLabel => 'समर्थन ईमेल';

  @override
  String get featureRequestLabel => 'सुविधा का अनुरोध';

  @override
  String get deleteAccountQuestion => 'खाता हटा दो?';

  @override
  String get deleteAccountTitle => 'खाता हटा दो';

  @override
  String get deleteAccountMessage =>
      'क्या आप पूर्णतः आश्वस्त हैं? यह आपके Cal AI इतिहास, वज़न लॉग और कस्टम लक्ष्यों को स्थायी रूप से हटा देगा। इस एक्शन को वापस नहीं किया जा सकता।';

  @override
  String get deletePermanentlyLabel => 'स्थायी रूप से हटाएँ';

  @override
  String get onboardingChooseGenderTitle => 'अपना लिंग चुनें';

  @override
  String get onboardingChooseGenderSubtitle =>
      'इसका उपयोग आपके कस्टम प्लान को कैलिब्रेट करने के लिए किया जाएगा।';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderOther => 'अन्य';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'आप प्रति सप्ताह कितने वर्कआउट करते हैं?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'इसका उपयोग आपके कस्टम प्लान को कैलिब्रेट करने के लिए किया जाएगा।';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'समय-समय पर वर्कआउट करें';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle => 'प्रति सप्ताह कुछ वर्कआउट';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'समर्पित एथलीट';

  @override
  String get onboardingHearAboutUsTitle => 'आपने हमारे बारे में कहां सुना?';

  @override
  String get sourceTikTok => 'टिक टोक';

  @override
  String get sourceYouTube => 'यूट्यूब';

  @override
  String get sourceGoogle => 'गूगल';

  @override
  String get sourcePlayStore => 'खेल स्टोर';

  @override
  String get sourceFacebook => 'फेसबुक';

  @override
  String get sourceFriendFamily => 'दोस्त या परिवार';

  @override
  String get sourceTv => 'टीवी';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'एक्स';

  @override
  String get sourceOther => 'अन्य';

  @override
  String get yourBmiTitle => 'अपना बीएमआई';

  @override
  String get yourWeightIsLabel => 'आपका वजन है';

  @override
  String get bmiUnderweightLabel => 'वजन';

  @override
  String get bmiHealthyLabel => 'स्वस्थ';

  @override
  String get bmiOverweightLabel => 'अधिक वजन';

  @override
  String get bmiObeseLabel => 'मोटा';

  @override
  String get calorieTrackingMadeEasy => 'कैलोरी ट्रैकिंग आसान हो गई';

  @override
  String get onboardingStep1Title => 'अपने भोजन पर नज़र रखें';

  @override
  String get onboardingStep1Description =>
      'अपने भोजन को आसानी से लॉग करें और अपने पोषण को ट्रैक करें।';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get signInWithEmail => 'ईमेल से साइन इन करें';

  @override
  String signInFailed(Object error) {
    return 'साइन इन विफल: $error';
  }

  @override
  String get continueLabel => 'जारी रखना';

  @override
  String get skipLabel => 'छोडना';

  @override
  String get noLabel => 'नहीं';

  @override
  String get yesLabel => 'हाँ';

  @override
  String get submitLabel => 'जमा करना';

  @override
  String get referralCodeLabel => 'रेफरल कोड';

  @override
  String get heightLabel => 'ऊंचाई';

  @override
  String get weightLabel => 'वज़न';

  @override
  String get imperialLabel => 'इम्पीरियल';

  @override
  String get metricLabel => 'मीट्रिक';

  @override
  String get month1Label => 'महीना 1';

  @override
  String get month6Label => 'महीना 6';

  @override
  String get traditionalDietLabel => 'पारंपरिक आहार';

  @override
  String get weightChartSummary =>
      'Cal AI के 80% उपयोगकर्ता 6 महीने बाद भी अपना वजन कम रखते हैं';

  @override
  String get comparisonWithoutCalAi => 'बिना\\nकैल एआई';

  @override
  String get comparisonWithCalAi => 'कैल एआई के साथ';

  @override
  String get comparisonLeftValue => '60 पाउंड';

  @override
  String get comparisonRightValue => '50 पाउंड';

  @override
  String get comparisonBottomLine1 => 'Cal AI इसे आसान और धारणीय बनाता है';

  @override
  String get comparisonBottomLine2 => 'आप जवाबदेह हैं';

  @override
  String get speedSlowSteady => 'धीमी और स्थिर';

  @override
  String get speedRecommended => 'अनुशंसित';

  @override
  String get speedAggressiveWarning =>
      'आप बहुत थका हुआ महसूस कर सकते हैं और त्वचा ढीली हो सकती है';

  @override
  String get subscriptionHeadline =>
      'अपने लक्ष्यों तक तेजी से पहुंचने के लिए CalAI को अनलॉक करें।';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'केवल PHP $yearlyPrice प्रति वर्ष (PHP $monthlyPrice/महीना)';
  }

  @override
  String get goalGainWeight => 'वजन बढ़ना';

  @override
  String get goalLoseWeight => 'वजन कम करें';

  @override
  String get goalMaintainWeight => 'वज़न बनाए रखें';

  @override
  String editGoalTitle(Object title) {
    return '$title लक्ष्य संपादित करें';
  }

  @override
  String get revertLabel => 'फिर लौट आना';

  @override
  String get doneLabel => 'हो गया';

  @override
  String get dashboardShouldGainWeight => 'पाना';

  @override
  String get dashboardShouldLoseWeight => 'खोना';

  @override
  String get dashboardShouldMaintainWeight => 'बनाए रखना';

  @override
  String get dashboardCongratsPlanReady =>
      'बधाई हो\\nआपका कस्टम प्लान तैयार है!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'आपको $action करना चाहिए:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit $date द्वारा';
  }

  @override
  String get dashboardDailyRecommendation => 'दैनिक सिफ़ारिश';

  @override
  String get dashboardEditAnytime => 'आप इसे किसी भी समय संपादित कर सकते हैं';

  @override
  String get dashboardHowToReachGoals => 'अपने लक्ष्य तक कैसे पहुँचें:';

  @override
  String get dashboardReachGoalLifeScore =>
      'अपना साप्ताहिक जीवन स्कोर प्राप्त करें और अपनी दिनचर्या में सुधार करें।';

  @override
  String get dashboardReachGoalTrackFood => 'अपने भोजन पर नज़र रखें';

  @override
  String get dashboardReachGoalFollowCalories =>
      'अपनी दैनिक कैलोरी अनुशंसा का पालन करें';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'अपने कार्ब्स, प्रोटीन, वसा को संतुलित करें';

  @override
  String get dashboardPlanSourcesTitle =>
      'अन्य सहकर्मी-समीक्षित चिकित्सा अध्ययनों के बीच, निम्नलिखित स्रोतों के आधार पर योजना बनाएं:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'आधारीय चयापचयी दर';

  @override
  String get dashboardSourceCalorieCountingHarvard => 'कैलोरी गिनती - हार्वर्ड';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'खेल पोषण की अंतर्राष्ट्रीय सोसायटी';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'नेशनल इंस्टीट्यूट ऑफ हेल्थ';

  @override
  String get factorsNetCarbsMass => 'शुद्ध कार्ब्स / द्रव्यमान';

  @override
  String get factorsNetCarbDensity => 'शुद्ध कार्ब घनत्व';

  @override
  String get factorsSodiumMass => 'सोडियम/द्रव्यमान';

  @override
  String get factorsSodiumDensity => 'सोडियम घनत्व';

  @override
  String get factorsSugarMass => 'चीनी/द्रव्यमान';

  @override
  String get factorsSugarDensity => 'चीनी का घनत्व';

  @override
  String get factorsProcessedScore => 'संसाधित स्कोर';

  @override
  String get factorsIngredientQuality => 'संघटक गुणवत्ता';

  @override
  String get factorsProcessedScoreDescription =>
      'संसाधित स्कोर रंगों, नाइट्रेट्स, बीज तेल, कृत्रिम स्वाद/मिठास और अन्य कारकों को ध्यान में रखता है।';

  @override
  String get healthScoreExplanationIntro =>
      'हमारा स्वास्थ्य स्कोर एक जटिल सूत्र है जो कई सामान्य खाद्य पदार्थों को देखते हुए कई कारकों को ध्यान में रखता है।';

  @override
  String get healthScoreExplanationFactorsLead =>
      'स्वास्थ्य स्कोर की गणना करते समय हम निम्नलिखित कारकों को ध्यान में रखते हैं:';

  @override
  String get netCarbsLabel => 'नेट कार्ब्स';

  @override
  String get howDoesItWork => 'यह कैसे काम करता है?';

  @override
  String get goodLabel => 'अच्छा';

  @override
  String get badLabel => 'खराब';

  @override
  String get dailyRecommendationFor => 'के लिए दैनिक अनुशंसा';

  @override
  String get loadingCustomizingHealthPlan =>
      'स्वास्थ्य योजना को अनुकूलित किया जा रहा है...';

  @override
  String get loadingApplyingBmrFormula => 'बीएमआर फॉर्मूला लागू करना...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'आपकी चयापचय आयु का अनुमान लगाया जा रहा है...';

  @override
  String get loadingFinalizingResults =>
      'परिणामों को अंतिम रूप दिया जा रहा है...';

  @override
  String get loadingSetupForYou => 'हम आपके लिए सब कुछ व्यवस्थित कर रहे हैं';

  @override
  String get step4TriedOtherCalorieApps =>
      'क्या आपने अन्य कैलोरी ट्रैकिंग ऐप्स आज़माए हैं?';

  @override
  String get step5CalAiLongTermResults => 'कैल एआई दीर्घकालिक परिणाम बनाता है';

  @override
  String get step6HeightWeightTitle => 'ऊंचाई और वजन';

  @override
  String get step6HeightWeightSubtitle =>
      'आपके दैनिक पोषण लक्ष्यों की गणना करते समय इसे ध्यान में रखा जाएगा।';

  @override
  String get step7WhenWereYouBorn => 'आपका जन्म कब हुआ था?';

  @override
  String get step8GoalQuestionTitle => 'आपका लक्ष्य क्या है?';

  @override
  String get step8GoalQuestionSubtitle =>
      'इससे हमें आपके कैलोरी सेवन के लिए एक योजना तैयार करने में मदद मिलती है।';

  @override
  String get step9SpecificDietQuestion =>
      'क्या आप किसी विशिष्ट आहार का पालन करते हैं?';

  @override
  String get step9DietClassic => 'क्लासिक';

  @override
  String get step9DietPescatarian => 'पेस्केटेरियन';

  @override
  String get step9DietVegetarian => 'शाकाहारी';

  @override
  String get step9DietVegan => 'शाकाहारी';

  @override
  String get step91DesiredWeightQuestion => 'आपका वांछित वजन क्या है?';

  @override
  String get step92GoalActionGaining => 'प्राप्त';

  @override
  String get step92GoalActionLosing => 'हार';

  @override
  String get step92RealisticTargetSuffix =>
      'एक यथार्थवादी लक्ष्य है. यह बिल्कुल भी कठिन नहीं है!';

  @override
  String get step92SocialProof =>
      '90% उपयोगकर्ताओं का कहना है कि Cal AI का उपयोग करने के बाद परिवर्तन स्पष्ट है, और इसे वापस लाना आसान नहीं है।';

  @override
  String get step93GoalVerbGain => 'पाना';

  @override
  String get step93GoalVerbLose => 'खोना';

  @override
  String get step93SpeedQuestionTitle =>
      'आप कितनी तेजी से अपने लक्ष्य तक पहुंचना चाहते हैं?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return '$action वजन गति प्रति सप्ताह';
  }

  @override
  String get step94ComparisonTitle =>
      'कैल एआई की तुलना में अपने दम पर दोगुना वजन कम करें';

  @override
  String get step95ObstaclesTitle =>
      'आपको अपने लक्ष्य तक पहुँचने से कौन रोक रहा है?';

  @override
  String get step10AccomplishTitle => 'आप क्या हासिल करना चाहेंगे?';

  @override
  String get step10OptionHealthier => 'खाओ और स्वस्थ रहो';

  @override
  String get step10OptionEnergyMood => 'मेरी ऊर्जा और मनोदशा बढ़ाएँ';

  @override
  String get step10OptionConsistency => 'प्रेरित और सुसंगत रहें';

  @override
  String get step10OptionBodyConfidence =>
      'अपने शरीर के बारे में बेहतर महसूस करें';

  @override
  String get step11PotentialTitle =>
      'आपमें अपने लक्ष्य को कुचलने की काफी क्षमता है';

  @override
  String get step12ThankYouTitle => 'हम पर भरोसा करने के लिए धन्यवाद!';

  @override
  String get step12PersonalizeSubtitle =>
      'आइए अब आपके लिए Cal AI को वैयक्तिकृत करें...';

  @override
  String get step12PrivacyCardTitle =>
      'आपकी गोपनीयता और सुरक्षा हमारे लिए मायने रखती है।';

  @override
  String get step12PrivacyCardBody =>
      'हम आपकी व्यक्तिगत जानकारी को हमेशा निजी और सुरक्षित रखने का वादा करते हैं।';

  @override
  String get step13ReachGoalsWithNotifications =>
      'सूचनाओं के साथ अपने लक्ष्य तक पहुँचें';

  @override
  String get step13NotificationPrompt => 'कैल एआई आपको सूचनाएं भेजना चाहता है';

  @override
  String get allowLabel => 'अनुमति दें';

  @override
  String get dontAllowLabel => 'अनुमति न दें';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'क्या आप जली हुई कैलोरी को अपने दैनिक लक्ष्य में वापस जोड़ते हैं?';

  @override
  String get step15RolloverQuestion =>
      'अतिरिक्त कैलोरी को अगले दिन में स्थानांतरित करें?';

  @override
  String get step15RolloverUpTo => 'तक रोलओवर करें';

  @override
  String get step15RolloverCap => '200 कैल्स';

  @override
  String get step16ReferralTitle => 'रेफरल कोड दर्ज करें (वैकल्पिक)';

  @override
  String get step16ReferralSubtitle => 'आप इस चरण को छोड़ सकते हैं';

  @override
  String get step17AllDone => 'सब कुछ कर दिया!';

  @override
  String get step17GeneratePlanTitle => 'अपनी कस्टम योजना तैयार करने का समय!';

  @override
  String get step18CalculationError =>
      'योजना की गणना नहीं की जा सकी. कृपया अपना कनेक्शन जांचें.';

  @override
  String get step18TryAgain => 'पुनः प्रयास करें';

  @override
  String get step19CreateAccountTitle => 'खाता बनाएं';

  @override
  String get authInvalidEmailMessage => 'कृपया एक मान्य ईमेल पता प्रविष्ट करें';

  @override
  String get authCheckYourEmailTitle => 'अपने ईमेल की जाँच करें';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'हमने $email को एक साइन-इन लिंक भेजा';
  }

  @override
  String get okLabel => 'ठीक है';

  @override
  String genericErrorMessage(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String get authWhatsYourEmail => 'आपका ईमेल क्या है?';

  @override
  String get authPasswordlessHint =>
      'हम आपको बिना पासवर्ड के साइन इन करने के लिए एक लिंक भेजेंगे।';

  @override
  String get emailExampleHint => 'नाम@उदाहरण.com';

  @override
  String get notSetLabel => 'सेट नहीं';

  @override
  String get goalWeightLabel => 'भार मकसद';

  @override
  String get changeGoalLabel => 'लक्ष्य बदलें';

  @override
  String get currentWeightLabel => 'वर्तमान वजन';

  @override
  String get dateOfBirthLabel => 'जन्मतिथि';

  @override
  String get genderLabel => 'लिंग';

  @override
  String get dailyStepGoalLabel => 'दैनिक कदम लक्ष्य';

  @override
  String get stepGoalLabel => 'कदम लक्ष्य';

  @override
  String get setHeightTitle => 'ऊंचाई निर्धारित करें';

  @override
  String get setGenderTitle => 'लिंग निर्धारित करें';

  @override
  String get setBirthdayTitle => 'जन्मदिन निर्धारित करें';

  @override
  String get setWeightTitle => 'वजन निर्धारित करें';

  @override
  String get editNameTitle => 'नाम संपादित करें';

  @override
  String get calorieGoalLabel => 'कैलोरी लक्ष्य';

  @override
  String get proteinGoalLabel => 'प्रोटीन लक्ष्य';

  @override
  String get carbGoalLabel => 'कार्ब लक्ष्य';

  @override
  String get fatGoalLabel => 'मोटा लक्ष्य';

  @override
  String get sugarLimitLabel => 'चीनी सीमा';

  @override
  String get fiberGoalLabel => 'फाइबर लक्ष्य';

  @override
  String get sodiumLimitLabel => 'सोडियम सीमा';

  @override
  String get hideMicronutrientsLabel => 'सूक्ष्म पोषक तत्व छुपाएं';

  @override
  String get viewMicronutrientsLabel => 'सूक्ष्म पोषक तत्व देखें';

  @override
  String get autoGenerateGoalsLabel => 'ऑटो लक्ष्य बनाएं';

  @override
  String failedToGenerateGoals(Object error) {
    return 'लक्ष्य उत्पन्न करने में विफल: $error';
  }

  @override
  String get calculatingCustomGoals => 'अपने कस्टम लक्ष्यों की गणना करें...';

  @override
  String get logExerciseLabel => 'लॉग व्यायाम';

  @override
  String get savedFoodsLabel => 'सहेजे गए भोजन';

  @override
  String get foodDatabaseLabel => 'खाद्य डेटाबेस';

  @override
  String get scanFoodLabel => 'भोजन को स्कैन करें';

  @override
  String get exerciseTitle => 'व्यायाम';

  @override
  String get runTitle => 'दौड़';

  @override
  String get weightLiftingTitle => 'वजन उठाना';

  @override
  String get describeTitle => 'वर्णन';

  @override
  String get runDescription => 'दौड़ना, जॉगिंग, दौड़ना, आदि.';

  @override
  String get weightLiftingDescription => 'मशीनें, मुफ्त वजन, आदि.';

  @override
  String get describeWorkoutDescription => 'अपना वर्कआउट लिखें text';

  @override
  String get setIntensityLabel => 'सेट तीव्रता';

  @override
  String get durationLabel => 'अवधि';

  @override
  String get minutesShortLabel => 'मिनट';

  @override
  String get minutesAbbrevSuffix => 'मि.';

  @override
  String get addLabel => 'जोड़ें';

  @override
  String get intensityLabel => 'तीव्रता';

  @override
  String get intensityHighLabel => 'उच्च';

  @override
  String get intensityMediumLabel => 'मध्यम';

  @override
  String get intensityLowLabel => 'कम';

  @override
  String get runIntensityHighDescription =>
      'स्प्रिंटिंग - 14 मील प्रति घंटे (4 मिनट मील)';

  @override
  String get runIntensityMediumDescription =>
      'जॉगिंग - 6 मील प्रति घंटे (10 मिनट) मील)';

  @override
  String get runIntensityLowDescription =>
      'ठंडी चाल - 3 मील प्रति घंटे (20 मिनट मील)';

  @override
  String get weightIntensityHighDescription =>
      'असफलता की ओर प्रशिक्षण, भारी सांसें';

  @override
  String get weightIntensityMediumDescription => 'पसीना तोड़ना, कई प्रतिनिधि';

  @override
  String get weightIntensityLowDescription =>
      'कोई पसीना नहीं बहा रहा, थोड़ा प्रयास कर रहा हूं';

  @override
  String get exerciseLoggedSuccessfully => 'व्यायाम सफलतापूर्वक लॉग किया गया!';

  @override
  String get exerciseParsedAndLogged =>
      'व्यायाम को पार्स किया गया और लॉग किया गया!';

  @override
  String get describeExerciseTitle => 'व्यायाम का वर्णन करें';

  @override
  String get whatDidYouDoHint => 'आपने क्या किया?';

  @override
  String get describeExerciseExample =>
      'उदाहरण: 5 घंटे तक आउटडोर पदयात्रा, थकावट महसूस हुई';

  @override
  String get servingLabel => 'सेवित';

  @override
  String get productNotFoundMessage => 'उत्पाद नहीं मिला।';

  @override
  String couldNotIdentify(Object text) {
    return '\"$text\" की पहचान नहीं हो सकी।';
  }

  @override
  String get identifyingFoodMessage => 'भोजन की पहचान...';

  @override
  String get loggedSuccessfullyMessage => 'सफलतापूर्वक लॉग इन किया गया!';

  @override
  String get barcodeScannerLabel => 'बारकोड स्कैनर';

  @override
  String get barcodeLabel => 'बारकोड';

  @override
  String get foodLabel => 'खाद्य लेबल';

  @override
  String get galleryLabel => 'गैलरी';

  @override
  String get bestScanningPracticesTitle => 'सर्वोत्तम स्कैनिंग प्रथाएँ';

  @override
  String get generalTipsTitle => 'सामान्य युक्तियाँ:';

  @override
  String get scanTipKeepFoodInside => 'भोजन को स्कैन लाइनों के अंदर रखें';

  @override
  String get scanTipHoldPhoneStill =>
      'अपने फ़ोन को स्थिर रखें ताकि छवि धुंधली न हो';

  @override
  String get scanTipAvoidObscureAngles => 'अस्पष्ट कोणों पर चित्र न लें';

  @override
  String get scanNowLabel => 'अब स्कैन करें';

  @override
  String get allTabLabel => 'सभी';

  @override
  String get myMealsTabLabel => 'मेरा भोजन';

  @override
  String get myFoodsTabLabel => 'मेरे भोजन';

  @override
  String get savedScansTabLabel => 'स्कैन सहेजे गए';

  @override
  String get logEmptyFoodLabel => 'खाली भोजन लॉग करें';

  @override
  String get searchResultsLabel => 'खोज के परिणाम';

  @override
  String get suggestionsLabel => 'सुझाव';

  @override
  String get noItemsFoundLabel => 'कोई आइटम नहीं मिला।';

  @override
  String get noSuggestionsAvailableLabel => 'कोई सुझाव उपलब्ध नहीं है';

  @override
  String get noSavedScansYetLabel => 'अभी तक कोई सहेजा गया स्कैन नहीं';

  @override
  String get describeWhatYouAteHint => 'वर्णन करें कि आपने क्या खाया';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return '$foodName को $dateId में जोड़ा गया';
  }

  @override
  String get failedToAddFood => 'भोजन जोड़ने में विफल. पुनः प्रयास करें।';

  @override
  String get invalidFoodIdMessage => 'अमान्य खाद्य आईडी';

  @override
  String get foodNotFoundMessage => 'खाना नहीं मिला';

  @override
  String get couldNotLoadFoodDetails => 'भोजन का विवरण लोड नहीं किया जा सका';

  @override
  String get gramsShortLabel => 'जी';

  @override
  String get standardLabel => 'मानक';

  @override
  String get selectedFoodTitle => 'चयनित भोजन';

  @override
  String get measurementLabel => 'माप';

  @override
  String get otherNutritionFactsLabel => 'अन्य पोषण संबंधी तथ्य';

  @override
  String get numberOfServingsLabel => 'सर्विंग्स की संख्या';

  @override
  String get logLabel => 'लॉग करें';

  @override
  String get nutrientsTitle => 'पोषक तत्व';

  @override
  String get totalNutritionLabel => 'कुल पोषण';

  @override
  String get enterFoodNameHint => 'भोजन का नाम दर्ज करें';

  @override
  String get kcalLabel => 'किलो कैलोरी';

  @override
  String get statsLabel => 'आँकड़े';

  @override
  String get intensityModerateLabel => 'मध्यम';

  @override
  String get thisWeekLabel => 'इस सप्ताह';

  @override
  String get lastWeekLabel => 'पिछले सप्ताह';

  @override
  String get twoWeeksAgoLabel => '2 सप्ताह पहले';

  @override
  String get threeWeeksAgoLabel => '3 सप्ताह पहले';

  @override
  String get totalCaloriesLabel => 'कुल कैलोरी';

  @override
  String get calsLabel => 'कैलोरी';

  @override
  String get dayShortSun => 'रवि';

  @override
  String get dayShortMon => 'सोम';

  @override
  String get dayShortTue => 'मंगल';

  @override
  String get dayShortWed => 'बुध';

  @override
  String get dayShortThu => 'गुरु';

  @override
  String get dayShortFri => 'शुक्र';

  @override
  String get dayShortSat => 'शनि';

  @override
  String get ninetyDaysLabel => '90 दिन';

  @override
  String get sixMonthsLabel => '6 महीने';

  @override
  String get oneYearLabel => '1 वर्ष';

  @override
  String get allTimeLabel => 'पूरे समय';

  @override
  String get waitingForFirstLogLabel => 'आपके पहले लॉग की प्रतीक्षा है...';

  @override
  String get editGoalPickerTitle => 'लक्ष्य चयनकर्ता संपादित करें';

  @override
  String get bmiDisclaimerTitle => 'अस्वीकरण';

  @override
  String get bmiDisclaimerBody =>
      'स्वास्थ्य के अधिकांश मापों की तरह, बीएमआई एक आदर्श परीक्षण नहीं है। उदाहरण के लिए, गर्भावस्था या उच्च मांसपेशी द्रव्यमान के कारण परिणाम ख़राब हो सकते हैं, और यह बच्चे या बुजुर्गों के लिए स्वास्थ्य का अच्छा उपाय नहीं हो सकता है।';

  @override
  String get bmiWhyItMattersTitle => 'तो फिर, बीएमआई क्यों मायने रखता है?';

  @override
  String get bmiWhyItMattersBody =>
      'सामान्य तौर पर, आपका बीएमआई जितना अधिक होगा, अतिरिक्त वजन से जुड़ी कई स्थितियों के विकसित होने का जोखिम उतना अधिक होगा, जिनमें शामिल हैं: मधुमेह\\nगठिया\\nयकृत रोग\\nकई प्रकार के कैंसर (जैसे कि स्तन, बृहदान्त्र और प्रोस्टेट), उच्च रक्तचाप (उच्च रक्तचाप) उच्च कोलेस्ट्रॉल\\nस्लीप एपनिया';

  @override
  String get noWeightHistoryYet =>
      'अभी तक कोई वजन इतिहास दर्ज नहीं किया गया है।';

  @override
  String get overLabel => 'ऊपर';

  @override
  String get dailyBreakdownTitle => 'दैनिक टूटना';

  @override
  String get editDailyGoalsLabel => 'दैनिक लक्ष्य संपादित करें';

  @override
  String get errorLoadingData => 'डेटा लोड करने में त्रुटि';

  @override
  String get gramsLabel => 'ग्राम';

  @override
  String get healthStatusNotEvaluated => 'मूल्यांकन नहीं';

  @override
  String get healthStatusCriticallyLow => 'गंभीर रूप से कम';

  @override
  String get healthStatusNeedsImprovement => 'सुधार की जरूरत';

  @override
  String get healthStatusFairProgress => 'उचित प्रगति';

  @override
  String get healthStatusGoodHealth => 'अच्छा स्वास्थ्य';

  @override
  String get healthStatusExcellentHealth => 'उत्कृष्ट स्वास्थ्य';

  @override
  String get remindersTitle => 'अनुस्मारक';

  @override
  String get failedLoadReminderSettings =>
      'अनुस्मारक सेटिंग लोड करने में विफल.';

  @override
  String get smartNutritionRemindersTitle => 'स्मार्ट पोषण अनुस्मारक';

  @override
  String get dailyReminderAtLabel => 'पर दैनिक अनुस्मारक';

  @override
  String get setSmartNutritionTimeLabel => 'स्मार्ट पोषण समय निर्धारित करें';

  @override
  String get waterRemindersTitle => 'जल अनुस्मारक';

  @override
  String get everyLabel => 'प्रत्येक';

  @override
  String get hourUnitLabel => 'घंटे)';

  @override
  String get fromLabel => 'से';

  @override
  String get setWaterStartTimeLabel => 'पानी शुरू करने का समय निर्धारित करें';

  @override
  String get breakfastReminderTitle => 'नाश्ता अनुस्मारक';

  @override
  String get lunchReminderTitle => 'दोपहर के भोजन का अनुस्मारक';

  @override
  String get dinnerReminderTitle => 'रात्रि भोज अनुस्मारक';

  @override
  String get snackReminderTitle => 'नाश्ते का अनुस्मारक';

  @override
  String get goalTrackingAlertsTitle => 'लक्ष्य ट्रैकिंग अलर्ट';

  @override
  String get goalTrackingAlertsSubtitle =>
      'कैलोरी और मैक्रो लक्ष्य अलर्ट के निकट/अधिक';

  @override
  String get stepsExerciseReminderTitle => 'कदम/व्यायाम अनुस्मारक';

  @override
  String get dailyAtLabel => 'प्रतिदिन पर';

  @override
  String get setActivityReminderTimeLabel =>
      'गतिविधि अनुस्मारक समय निर्धारित करें';

  @override
  String get intervalLabel => 'अंतराल:';

  @override
  String get setTimeLabel => 'निर्धारित समय';

  @override
  String get languageNameEnglish => 'अंग्रेज़ी';

  @override
  String get languageNameSpanish => 'स्पेनिश';

  @override
  String get languageNamePortuguese => 'पुर्तगाली';

  @override
  String get languageNameFrench => 'फ़्रेंच';

  @override
  String get languageNameGerman => 'जर्मन';

  @override
  String get languageNameItalian => 'इतालवी';

  @override
  String get languageNameHindi => 'हिन्दी';

  @override
  String get progressMessageStart =>
      'शुरुआत करना सबसे कठिन हिस्सा है. आप इसके लिए तैयार हैं!';

  @override
  String get progressMessageKeepPushing =>
      'आप प्रगति कर रहे हैं. अब प्रयास जारी रखने का समय है!';

  @override
  String get progressMessagePayingOff =>
      'आपका समर्पण रंग ला रहा है. जाता रहना!';

  @override
  String get progressMessageFinalStretch =>
      'यह अंतिम पड़ाव है. अपने आप को धक्का!';

  @override
  String get progressMessageCongrats => 'तुमने यह किया! बधाई हो!';

  @override
  String dayStreakWithCount(Object count) {
    return '$count दिन की स्ट्रीक';
  }

  @override
  String get streakLostTitle => 'स्ट्रीक टूट गई';

  @override
  String get streakActiveSubtitle =>
      'आपका सब कुछ बहुत बढ़िया चल रहा है! अपनी गति बनाए रखने के लिए लॉगिंग करते रहें।';

  @override
  String get streakLostSubtitle =>
      'हिम्मत मत हारो। पटरी पर वापस आने के लिए आज ही अपना भोजन लॉग करें।';

  @override
  String get dayInitialSun => 'र';

  @override
  String get dayInitialMon => 'सो';

  @override
  String get dayInitialTue => 'मं';

  @override
  String get dayInitialWed => 'बु';

  @override
  String get dayInitialThu => 'गु';

  @override
  String get dayInitialFri => 'शु';

  @override
  String get dayInitialSat => 'श';

  @override
  String get alertCalorieGoalExceededTitle => 'कैलोरी लक्ष्य पार हो गया';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'आप अपने दैनिक लक्ष्य से $over किलो कैलोरी अधिक हैं।';
  }

  @override
  String get alertNearCalorieLimitTitle => 'आप अपनी कैलोरी सीमा के करीब हैं';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'आज केवल $remaining किलो कैलोरी बची है। अपने अगले भोजन की सावधानीपूर्वक योजना बनाएं।';
  }

  @override
  String get alertProteinBehindTitle => 'प्रोटीन लक्ष्य पीछे है';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'आज के लक्ष्य तक पहुँचने के लिए आपको अभी भी लगभग $missing g प्रोटीन की आवश्यकता है।';
  }

  @override
  String get alertCarbTargetExceededTitle => 'कार्ब लक्ष्य पार हो गया';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'कार्ब्स लक्ष्य से $over g अधिक हैं।';
  }

  @override
  String get alertFatTargetExceededTitle => 'मोटा लक्ष्य पार हो गया';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'वसा लक्ष्य से $over ग्राम अधिक है।';
  }

  @override
  String get smartNutritionTipTitle => 'स्मार्ट पोषण टिप';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories किलो कैलोरी शेष';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories किलो कैलोरी खत्म';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein जी प्रोटीन शेष';
  }

  @override
  String get smartNutritionProteinGoalReached => 'प्रोटीन लक्ष्य पूरा हो गया';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage और $proteinMessage। ट्रैक पर बने रहने के लिए अपना अगला भोजन लॉग करें।';
  }

  @override
  String get notificationStepsExerciseTitle => 'कदम और व्यायाम अनुस्मारक';

  @override
  String get notificationStepsExerciseBody =>
      'आज के गतिविधि लक्ष्य को पूरा करने के लिए अपने कदम या कसरत लॉग करें।';

  @override
  String get notificationBreakfastTitle => 'नाश्ता अनुस्मारक';

  @override
  String get notificationBreakfastBody =>
      'अपनी कैलोरी और मैक्रो ट्रैकिंग जल्दी शुरू करने के लिए नाश्ता लॉग करें।';

  @override
  String get notificationLunchTitle => 'दोपहर के भोजन का अनुस्मारक';

  @override
  String get notificationLunchBody =>
      'लंच टाइम। अपनी दैनिक प्रगति को सटीक रखने के लिए अपना भोजन जोड़ें।';

  @override
  String get notificationDinnerTitle => 'रात्रि भोज अनुस्मारक';

  @override
  String get notificationDinnerBody =>
      'रात्रिभोज लॉग करें और संपूर्ण पोषण डेटा के साथ अपना दिन समाप्त करें।';

  @override
  String get notificationSnackTitle => 'नाश्ते का अनुस्मारक';

  @override
  String get notificationSnackBody =>
      'अपना नाश्ता जोड़ें ताकि कैलोरी और मैक्रोज़ आपके लक्ष्यों के अनुरूप रहें।';

  @override
  String get smartNutritionDailyTitle => 'स्मार्ट पोषण चेक-इन';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'लक्ष्य $calories किलो कैलोरी, ${protein}g प्रोटीन, ${carbs}g कार्बोहाइड्रेट, ${fats}g वसा। अपनी योजना को सटीक बनाए रखने के लिए अपना नवीनतम भोजन लॉग करें।';
  }

  @override
  String get notificationWaterTitle => 'जल अनुस्मारक';

  @override
  String get notificationWaterBody =>
      'जलयोजन जांच. Cal AI में एक गिलास पानी लॉग करें।';

  @override
  String get homeWidgetLogFoodCta => 'अपना भोजन लॉग करें';

  @override
  String get homeWidgetCaloriesTodayTitle => 'आज कैलोरी';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories / $goal किलो कैलोरी';
  }
}
