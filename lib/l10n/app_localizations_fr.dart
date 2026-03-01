// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Accueil';

  @override
  String get progressTab => 'Progrès';

  @override
  String get settingsTab => 'Paramètres';

  @override
  String get language => 'Langue';

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
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get personalDetails => 'Détails personnels';

  @override
  String get adjustMacronutrients => 'Ajuster les macronutriments';

  @override
  String get weightHistory => 'Historique du poids';

  @override
  String get homeWidget => 'Widget Accueil';

  @override
  String get chooseHomeWidgets => 'Choisissez les widgets d\'accueil';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Appuyez sur les options pour ajouter ou supprimer des widgets.';

  @override
  String get updatingWidgetSelection =>
      'Mise à jour de la sélection de widgets...';

  @override
  String get requestingWidgetPermission =>
      'Demande d\'autorisation pour le widget...';

  @override
  String get widget1 => 'Widget n° 1';

  @override
  String get widget2 => 'Widget n° 2';

  @override
  String get widget3 => 'Widget n° 3';

  @override
  String get calorieTrackerWidget => 'Suivi des calories';

  @override
  String get nutritionTrackerWidget => 'Suivi nutritionnel';

  @override
  String get streakTrackerWidget => 'Suivi des séquences';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName supprimé de la sélection.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'Pour supprimer $widgetName, supprimez-le de votre écran d\'accueil. La sélection se synchronise automatiquement.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'Pour ajouter $widgetName, appuyez longuement sur l\'écran d\'accueil, appuyez sur +, puis sélectionnez Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return 'Widget $widgetName ajouté.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Autorisation requise pour ajouter $widgetName. Nous avons ouvert les paramètres pour vous.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'Impossible d\'ouvrir les paramètres d\'autorisation. Veuillez activer les autorisations manuellement pour ajouter $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen => 'Aucun widget sur l\'écran d\'accueil';

  @override
  String selectedWidgets(Object widgets) {
    return 'Sélectionné: $widgets';
  }

  @override
  String get backupData => 'Sauvegardez vos données';

  @override
  String get signInToSync =>
      'Connectez-vous pour synchroniser vos progrès et vos objectifs';

  @override
  String get accountSuccessfullyBackedUp => 'Compte sauvegardé avec succès !';

  @override
  String get failedToLinkAccount => 'Échec de l\'association du compte.';

  @override
  String get googleAccountAlreadyLinked =>
      'Ce compte Google est déjà lié à un autre profil Cal AI.';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get eatenLabel => 'mangé';

  @override
  String get leftLabel => 'restant';

  @override
  String get proteinLabel => 'Protéine';

  @override
  String get carbsLabel => 'Glucides';

  @override
  String get fatsLabel => 'Graisses';

  @override
  String get fiberLabel => 'Fibre';

  @override
  String get sugarLabel => 'Sucre';

  @override
  String get sodiumLabel => 'Sodium';

  @override
  String get stepsLabel => 'Pas';

  @override
  String get stepsTodayLabel => 'Étapes aujourd\'hui';

  @override
  String get caloriesBurnedLabel => 'Calories brûlées';

  @override
  String get stepTrackingActive => 'Suivi des pas actif !';

  @override
  String get waterLabel => 'Eau';

  @override
  String get servingSizeLabel => 'Portion';

  @override
  String get waterSettingsTitle => 'Paramètres de l\'eau';

  @override
  String get hydrationQuestion =>
      'De quelle quantité d’eau avez-vous besoin pour rester hydraté ?';

  @override
  String get hydrationInfo =>
      'Les besoins de chacun sont légèrement différents, mais nous vous recommandons de viser au moins 64 fl oz (8 tasses) d\'eau chaque jour.';

  @override
  String get healthScoreTitle => 'Bilan de santé';

  @override
  String get healthSummaryNoData =>
      'Aucune donnée enregistrée pour aujourd\'hui. Commencez à suivre vos repas pour voir vos informations sur la santé !';

  @override
  String get healthSummaryLowIntake =>
      'Votre consommation est assez faible. Concentrez-vous sur l’atteinte de vos objectifs caloriques et protéiques pour maintenir votre énergie et vos muscles.';

  @override
  String get healthSummaryLowProtein =>
      'Les glucides et les graisses sont sur la bonne voie, mais vous êtes pauvre en protéines. L\'augmentation des protéines peut aider à la rétention musculaire.';

  @override
  String get healthSummaryGreat =>
      'Super travail ! Votre alimentation est aujourd’hui bien équilibrée.';

  @override
  String get recentlyLoggedTitle => 'Enregistrés récemment';

  @override
  String errorLoadingLogs(Object error) {
    return 'Erreur de chargement des journaux : $error';
  }

  @override
  String get deleteLabel => 'Supprimer';

  @override
  String get tapToAddFirstEntry =>
      'Appuyez sur + pour ajouter votre première entrée';

  @override
  String unableToLoadProgress(Object error) {
    return 'Impossible de charger la progression : $error';
  }

  @override
  String get myWeightTitle => 'Mon poids';

  @override
  String goalWithValue(Object value) {
    return 'Objectif $value';
  }

  @override
  String get noGoalSet => 'Aucun objectif fixé';

  @override
  String get logWeightCta => 'Poids du journal';

  @override
  String get dayStreakTitle => 'Séquence d\'une journée';

  @override
  String get progressPhotosTitle => 'Photos de Progrès';

  @override
  String get progressPhotoPrompt =>
      'Vous souhaitez ajouter une photo pour suivre vos progrès ?';

  @override
  String get uploadPhotoCta => 'Télécharger une photo';

  @override
  String get goalProgressTitle => 'Progression des objectifs';

  @override
  String get ofGoalLabel => 'de but';

  @override
  String get logoutLabel => 'Déconnexion';

  @override
  String get logoutTitle => 'Déconnexion';

  @override
  String get logoutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancelLabel => 'Annuler';

  @override
  String get preferencesLabel => 'Préférences';

  @override
  String get appearanceLabel => 'Apparence';

  @override
  String get appearanceDescription =>
      'Choisissez l\'apparence claire, sombre ou système';

  @override
  String get lightLabel => 'Lumière';

  @override
  String get darkLabel => 'Sombre';

  @override
  String get automaticLabel => 'Automatique';

  @override
  String get addBurnedCaloriesLabel => 'Ajouter des calories brûlées';

  @override
  String get addBurnedCaloriesDescription =>
      'Ajouter les calories brûlées à l\'objectif quotidien';

  @override
  String get rolloverCaloriesLabel => 'Calories de roulement';

  @override
  String get rolloverCaloriesDescription =>
      'Ajoutez jusqu\'à 200 calories restantes à l\'objectif d\'aujourd\'hui';

  @override
  String get measurementUnitLabel => 'Unité de mesure';

  @override
  String get measurementUnitDescription =>
      'Toutes les valeurs seront converties en impérial (actuellement sur les métriques)';

  @override
  String get inviteFriendsLabel => 'Inviter des amis';

  @override
  String get defaultUserName => 'utilisateur';

  @override
  String get enterYourNameLabel => 'Entrez votre nom';

  @override
  String yearsOldLabel(Object years) {
    return '$years ans';
  }

  @override
  String get termsAndConditionsLabel => 'Termes et conditions';

  @override
  String get privacyPolicyLabel => 'politique de confidentialité';

  @override
  String get supportEmailLabel => 'E-mail d\'assistance';

  @override
  String get featureRequestLabel => 'Demande de fonctionnalité';

  @override
  String get deleteAccountQuestion => 'Supprimer le compte ?';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountMessage =>
      'Etes-vous absolument sûr ? Cela supprimera définitivement votre historique Cal AI, vos journaux de poids et vos objectifs personnalisés. Cette action ne peut pas être annulée.';

  @override
  String get deletePermanentlyLabel => 'Supprimer définitivement';

  @override
  String get onboardingChooseGenderTitle => 'Choisissez votre sexe';

  @override
  String get onboardingChooseGenderSubtitle =>
      'Cela sera utilisé pour calibrer votre plan personnalisé.';

  @override
  String get genderFemale => 'Femelle';

  @override
  String get genderMale => 'Mâle';

  @override
  String get genderOther => 'Autre';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'Combien d\'entraînements faites-vous par semaine ?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'Cela sera utilisé pour calibrer votre plan personnalisé.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Des entraînements de temps en temps';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle =>
      'Quelques entraînements par semaine';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Athlète dévoué';

  @override
  String get onboardingHearAboutUsTitle =>
      'Où avez-vous entendu parler de nous ?';

  @override
  String get sourceTikTok => 'Tik Tok';

  @override
  String get sourceYouTube => 'YouTube';

  @override
  String get sourceGoogle => 'Google';

  @override
  String get sourcePlayStore => 'Jouer au magasin';

  @override
  String get sourceFacebook => 'Facebook';

  @override
  String get sourceFriendFamily => 'Ami ou famille';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Autre';

  @override
  String get yourBmiTitle => 'Votre IMC';

  @override
  String get yourWeightIsLabel => 'Votre poids est';

  @override
  String get bmiUnderweightLabel => 'Insuffisance pondérale';

  @override
  String get bmiHealthyLabel => 'En bonne santé';

  @override
  String get bmiOverweightLabel => 'Embonpoint';

  @override
  String get bmiObeseLabel => 'Obèse';

  @override
  String get calorieTrackingMadeEasy => 'Le suivi des calories simplifié';

  @override
  String get onboardingStep1Title => 'Suivez vos repas';

  @override
  String get onboardingStep1Description =>
      'Enregistrez facilement vos repas et suivez votre nutrition.';

  @override
  String get signInWithGoogle => 'Connectez-vous avec Google';

  @override
  String get signInWithEmail => 'Connectez-vous avec e-mail';

  @override
  String signInFailed(Object error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get continueLabel => 'Continuer';

  @override
  String get skipLabel => 'Sauter';

  @override
  String get noLabel => 'Non';

  @override
  String get yesLabel => 'Oui';

  @override
  String get submitLabel => 'Soumettre';

  @override
  String get referralCodeLabel => 'Code de référence';

  @override
  String get heightLabel => 'Hauteur';

  @override
  String get weightLabel => 'Poids';

  @override
  String get imperialLabel => 'Impérial';

  @override
  String get metricLabel => 'Métrique';

  @override
  String get month1Label => 'Mois 1';

  @override
  String get month6Label => 'Mois 6';

  @override
  String get traditionalDietLabel => 'Régime traditionnel';

  @override
  String get weightChartSummary =>
      '80 % des utilisateurs de Cal AI maintiennent leur perte de poids même 6 mois plus tard';

  @override
  String get comparisonWithoutCalAi => 'Sans\\nCal AI';

  @override
  String get comparisonWithCalAi => 'Avec\\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI facilite les choses et tient';

  @override
  String get comparisonBottomLine2 => 'tu es responsable';

  @override
  String get speedSlowSteady => 'Lent et régulier';

  @override
  String get speedRecommended => 'Recommandé';

  @override
  String get speedAggressiveWarning =>
      'Vous pouvez vous sentir très fatigué et développer une peau lâche';

  @override
  String get subscriptionHeadline =>
      'Débloquez CalAI pour atteindre\\nvos objectifs plus rapidement.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Juste PHP $yearlyPrice par an (PHP $monthlyPrice/mois)';
  }

  @override
  String get goalGainWeight => 'Prendre du poids';

  @override
  String get goalLoseWeight => 'Perdre du poids';

  @override
  String get goalMaintainWeight => 'Maintenir le poids';

  @override
  String editGoalTitle(Object title) {
    return 'Modifier l\'objectif $title';
  }

  @override
  String get revertLabel => 'Revenir';

  @override
  String get doneLabel => 'Fait';

  @override
  String get dashboardShouldGainWeight => 'gagner';

  @override
  String get dashboardShouldLoseWeight => 'perdre';

  @override
  String get dashboardShouldMaintainWeight => 'maintenir';

  @override
  String get dashboardCongratsPlanReady =>
      'Félicitations\\nvotre plan personnalisé est prêt !';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'Vous devriez $action :';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit par $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Recommandation quotidienne';

  @override
  String get dashboardEditAnytime => 'Vous pouvez modifier ceci à tout moment';

  @override
  String get dashboardHowToReachGoals => 'Comment atteindre vos objectifs :';

  @override
  String get dashboardReachGoalLifeScore =>
      'Obtenez votre score de vie hebdomadaire et améliorez votre routine.';

  @override
  String get dashboardReachGoalTrackFood => 'Suivez votre nourriture';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Suivez votre recommandation quotidienne de calories';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Équilibrez vos glucides, protéines, graisses';

  @override
  String get dashboardPlanSourcesTitle =>
      'Plan basé sur les sources suivantes, entre autres études médicales évaluées par des pairs :';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Taux métabolique basal';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Comptage des calories - Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'Société internationale de nutrition sportive';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'Instituts nationaux de la santé';

  @override
  String get factorsNetCarbsMass => 'Glucides nets / masse';

  @override
  String get factorsNetCarbDensity => 'Densité nette en glucides';

  @override
  String get factorsSodiumMass => 'Sodium / masse';

  @override
  String get factorsSodiumDensity => 'Densité du sodium';

  @override
  String get factorsSugarMass => 'Sucre / masse';

  @override
  String get factorsSugarDensity => 'Densité du sucre';

  @override
  String get factorsProcessedScore => 'Partition traitée';

  @override
  String get factorsIngredientQuality => 'Qualité des ingrédients';

  @override
  String get factorsProcessedScoreDescription =>
      'Le score traité prend en compte les colorants, les nitrates, les huiles de graines, les arômes/édulcorants artificiels et d\'autres facteurs.';

  @override
  String get healthScoreExplanationIntro =>
      'Notre score santé est une formule complexe prenant en compte plusieurs facteurs compte tenu d’une multitude d’aliments courants.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'Voici les facteurs que nous prenons en compte lors du calcul du score de santé :';

  @override
  String get netCarbsLabel => 'Glucides nets';

  @override
  String get howDoesItWork => 'Comment ça marche ?';

  @override
  String get goodLabel => 'Bien';

  @override
  String get badLabel => 'Mauvais';

  @override
  String get dailyRecommendationFor => 'Recommandation quotidienne pour';

  @override
  String get loadingCustomizingHealthPlan =>
      'Personnalisation du plan de santé...';

  @override
  String get loadingApplyingBmrFormula => 'Application de la formule BMR...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'Estimer votre âge métabolique...';

  @override
  String get loadingFinalizingResults => 'Finalisation des résultats...';

  @override
  String get loadingSetupForYou => 'Nous préparons tout\\npour vous';

  @override
  String get step4TriedOtherCalorieApps =>
      'Avez-vous essayé d\'autres applications de suivi des calories ?';

  @override
  String get step5CalAiLongTermResults =>
      'Cal AI crée des résultats à long terme';

  @override
  String get step6HeightWeightTitle => 'Taille et poids';

  @override
  String get step6HeightWeightSubtitle =>
      'Ceci sera pris en compte lors du calcul de vos objectifs nutritionnels quotidiens.';

  @override
  String get step7WhenWereYouBorn => 'Quand êtes-vous né?';

  @override
  String get step8GoalQuestionTitle => 'Quel est votre objectif ?';

  @override
  String get step8GoalQuestionSubtitle =>
      'Cela nous aide à générer un plan pour votre apport calorique.';

  @override
  String get step9SpecificDietQuestion => 'Suivez-vous un régime spécifique ?';

  @override
  String get step9DietClassic => 'Classique';

  @override
  String get step9DietPescatarian => 'Pescatarien';

  @override
  String get step9DietVegetarian => 'Végétarien';

  @override
  String get step9DietVegan => 'Végétalien';

  @override
  String get step91DesiredWeightQuestion => 'Quel est votre poids souhaité ?';

  @override
  String get step92GoalActionGaining => 'Gagner';

  @override
  String get step92GoalActionLosing => 'Perdant';

  @override
  String get step92RealisticTargetSuffix =>
      'est un objectif réaliste. Ce n\'est pas difficile du tout !';

  @override
  String get step92SocialProof =>
      '90 % des utilisateurs déclarent que le changement est évident après avoir utilisé Cal AI, et qu\'il n\'est pas facile de rebondir.';

  @override
  String get step93GoalVerbGain => 'Gagner';

  @override
  String get step93GoalVerbLose => 'Perdre';

  @override
  String get step93SpeedQuestionTitle =>
      'À quelle vitesse souhaitez-vous atteindre votre objectif ?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return 'Vitesse de poids $action par semaine';
  }

  @override
  String get step94ComparisonTitle =>
      'Perdez deux fois plus de poids avec Cal AI qu\'avec vous-même';

  @override
  String get step95ObstaclesTitle =>
      'Qu\'est-ce qui vous empêche d\'atteindre vos objectifs ?';

  @override
  String get step10AccomplishTitle => 'Qu’aimeriez-vous accomplir ?';

  @override
  String get step10OptionHealthier => 'Manger et vivre plus sainement';

  @override
  String get step10OptionEnergyMood => 'Booste mon énergie et mon humeur';

  @override
  String get step10OptionConsistency => 'Restez motivé et cohérent';

  @override
  String get step10OptionBodyConfidence => 'Me sentir mieux dans mon corps';

  @override
  String get step11PotentialTitle =>
      'Vous avez un grand potentiel pour atteindre votre objectif';

  @override
  String get step12ThankYouTitle => 'Merci de\\nnous faire confiance !';

  @override
  String get step12PersonalizeSubtitle =>
      'Personnalisons maintenant Cal AI pour vous...';

  @override
  String get step12PrivacyCardTitle =>
      'Votre confidentialité et votre sécurité nous tiennent à cœur.';

  @override
  String get step12PrivacyCardBody =>
      'Nous nous engageons à toujours garder vos informations personnelles privées et sécurisées.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Atteignez vos objectifs avec les notifications';

  @override
  String get step13NotificationPrompt =>
      'Cal AI souhaite vous envoyer des notifications';

  @override
  String get allowLabel => 'Permettre';

  @override
  String get dontAllowLabel => 'Ne pas autoriser';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'Ajouter les calories brûlées à votre objectif quotidien ?';

  @override
  String get step15RolloverQuestion =>
      'Reporter les calories supplémentaires au lendemain ?';

  @override
  String get step15RolloverUpTo => 'Roulez jusqu\'à';

  @override
  String get step15RolloverCap => '200 calories';

  @override
  String get step16ReferralTitle => 'Entrez le code de parrainage (facultatif)';

  @override
  String get step16ReferralSubtitle => 'Vous pouvez sauter cette étape';

  @override
  String get step17AllDone => 'Tout est fait !';

  @override
  String get step17GeneratePlanTitle =>
      'Il est temps de générer votre plan personnalisé !';

  @override
  String get step18CalculationError =>
      'Impossible de calculer le plan. Veuillez vérifier votre connexion.';

  @override
  String get step18TryAgain => 'Essayer à nouveau';

  @override
  String get step19CreateAccountTitle => 'Créer un compte';

  @override
  String get authInvalidEmailMessage =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get authCheckYourEmailTitle => 'Vérifiez votre courrier électronique';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'Nous avons envoyé un lien de connexion à $email';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get authWhatsYourEmail => 'Quel est votre email ?';

  @override
  String get authPasswordlessHint =>
      'Nous vous enverrons un lien pour vous connecter sans mot de passe.';

  @override
  String get emailExampleHint => 'nom@exemple.com';

  @override
  String get notSetLabel => 'Non défini';

  @override
  String get goalWeightLabel => 'Poids objectif';

  @override
  String get changeGoalLabel => 'Changer l\'objectif';

  @override
  String get currentWeightLabel => 'Poids actuel';

  @override
  String get dateOfBirthLabel => 'Date de naissance';

  @override
  String get genderLabel => 'Genre';

  @override
  String get dailyStepGoalLabel => 'Objectif de pas quotidien';

  @override
  String get stepGoalLabel => 'Objectif d\'étape';

  @override
  String get setHeightTitle => 'Définir la hauteur';

  @override
  String get setGenderTitle => 'Définir le sexe';

  @override
  String get setBirthdayTitle => 'Définir l\'anniversaire';

  @override
  String get setWeightTitle => 'Définir le poids';

  @override
  String get editNameTitle => 'Modifier le nom';

  @override
  String get calorieGoalLabel => 'Objectif calorique';

  @override
  String get proteinGoalLabel => 'Objectif protéines';

  @override
  String get carbGoalLabel => 'Objectif glucides';

  @override
  String get fatGoalLabel => 'Gros objectif';

  @override
  String get sugarLimitLabel => 'Limite de sucre';

  @override
  String get fiberGoalLabel => 'Objectif fibre';

  @override
  String get sodiumLimitLabel => 'Limite de sodium';

  @override
  String get hideMicronutrientsLabel => 'Masquer les micronutriments';

  @override
  String get viewMicronutrientsLabel => 'Voir les micronutriments';

  @override
  String get autoGenerateGoalsLabel => 'Générer automatiquement des objectifs';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Échec de la génération des objectifs : $error';
  }

  @override
  String get calculatingCustomGoals =>
      'Calcul de vos objectifs personnalisés...';

  @override
  String get logExerciseLabel => 'Exercice de journal';

  @override
  String get savedFoodsLabel => 'Aliments conservés';

  @override
  String get foodDatabaseLabel => 'Base de données alimentaire';

  @override
  String get scanFoodLabel => 'Scanner la nourriture';

  @override
  String get exerciseTitle => 'Exercice';

  @override
  String get runTitle => 'Courir';

  @override
  String get weightLiftingTitle => 'Haltérophilie';

  @override
  String get describeTitle => 'Décrire';

  @override
  String get runDescription => 'Course à pied, jogging, sprint, etc.';

  @override
  String get weightLiftingDescription => 'Machines, poids libres, etc.';

  @override
  String get describeWorkoutDescription =>
      'Écrivez votre entraînement dans le texte';

  @override
  String get setIntensityLabel => 'Définir l\'intensité';

  @override
  String get durationLabel => 'Durée';

  @override
  String get minutesShortLabel => 'minutes';

  @override
  String get minutesAbbrevSuffix => 'm';

  @override
  String get addLabel => 'Ajouter';

  @override
  String get intensityLabel => 'Intensité';

  @override
  String get intensityHighLabel => 'Haut';

  @override
  String get intensityMediumLabel => 'Moyen';

  @override
  String get intensityLowLabel => 'Faible';

  @override
  String get runIntensityHighDescription => 'Sprint - 14 mph (4 minutes miles)';

  @override
  String get runIntensityMediumDescription =>
      'Footing - 6 mph (10 minutes par mile)';

  @override
  String get runIntensityLowDescription =>
      'Marche relaxante - 3 mph (20 minutes miles)';

  @override
  String get weightIntensityHighDescription =>
      'S\'entraîner jusqu\'à l\'échec, respirer fort';

  @override
  String get weightIntensityMediumDescription =>
      'Transpirer, beaucoup de répétitions';

  @override
  String get weightIntensityLowDescription =>
      'Ne pas transpirer, faire peu d\'effort';

  @override
  String get exerciseLoggedSuccessfully => 'Exercice enregistré avec succès !';

  @override
  String get exerciseParsedAndLogged => 'Exercice analysé et enregistré !';

  @override
  String get describeExerciseTitle => 'Décrire l\'exercice';

  @override
  String get whatDidYouDoHint => 'Qu\'est-ce que tu as fait?';

  @override
  String get describeExerciseExample =>
      'Exemple : randonnée en plein air pendant 5 heures, je me sens épuisé';

  @override
  String get servingLabel => 'Portion';

  @override
  String get productNotFoundMessage => 'Produit introuvable.';

  @override
  String couldNotIdentify(Object text) {
    return 'Impossible d\'identifier \"$text\".';
  }

  @override
  String get identifyingFoodMessage => 'Identifier les aliments...';

  @override
  String get loggedSuccessfullyMessage => 'Connecté avec succès !';

  @override
  String get barcodeScannerLabel => 'Lecteur de codes à barres';

  @override
  String get barcodeLabel => 'Code à barres';

  @override
  String get foodLabel => 'Étiquette alimentaire';

  @override
  String get galleryLabel => 'Galerie';

  @override
  String get bestScanningPracticesTitle => 'Meilleures pratiques d\'analyse';

  @override
  String get generalTipsTitle => 'Conseils généraux :';

  @override
  String get scanTipKeepFoodInside =>
      'Gardez la nourriture à l\'intérieur des lignes de balayage';

  @override
  String get scanTipHoldPhoneStill =>
      'Tenez votre téléphone immobile pour que l\'image ne soit pas floue';

  @override
  String get scanTipAvoidObscureAngles =>
      'Ne prenez pas la photo sous des angles obscurs';

  @override
  String get scanNowLabel => 'Scannez maintenant';

  @override
  String get allTabLabel => 'Tous';

  @override
  String get myMealsTabLabel => 'Mes repas';

  @override
  String get myFoodsTabLabel => 'Mes aliments';

  @override
  String get savedScansTabLabel => 'Analyses enregistrées';

  @override
  String get logEmptyFoodLabel => 'Enregistrez la nourriture vide';

  @override
  String get searchResultsLabel => 'Résultats de la recherche';

  @override
  String get suggestionsLabel => 'Suggestions proposées';

  @override
  String get noItemsFoundLabel => 'Aucun élément trouvé.';

  @override
  String get noSuggestionsAvailableLabel => 'Aucune suggestion disponible';

  @override
  String get noSavedScansYetLabel =>
      'Aucune analyse enregistrée pour l\'instant';

  @override
  String get describeWhatYouAteHint => 'Décrivez ce que vous avez mangé';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return 'Ajout de $foodName à $dateId';
  }

  @override
  String get failedToAddFood =>
      'Échec de l\'ajout de nourriture. Essayer à nouveau.';

  @override
  String get invalidFoodIdMessage => 'ID d\'aliment invalide';

  @override
  String get foodNotFoundMessage => 'Nourriture introuvable';

  @override
  String get couldNotLoadFoodDetails =>
      'Impossible de charger les détails de la nourriture';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Standard';

  @override
  String get selectedFoodTitle => 'Nourriture sélectionnée';

  @override
  String get measurementLabel => 'Mesures';

  @override
  String get otherNutritionFactsLabel => 'Autres faits nutritionnels';

  @override
  String get numberOfServingsLabel => 'Nombre de portions';

  @override
  String get logLabel => 'Enregistrer';

  @override
  String get nutrientsTitle => 'Nutriments';

  @override
  String get totalNutritionLabel => 'Nutrition totale';

  @override
  String get enterFoodNameHint => 'Entrez le nom de l\'aliment';

  @override
  String get kcalLabel => 'kilocalories';

  @override
  String get statsLabel => 'Statistiques';

  @override
  String get intensityModerateLabel => 'Modéré';

  @override
  String get thisWeekLabel => 'Cette semaine';

  @override
  String get lastWeekLabel => 'La semaine dernière';

  @override
  String get twoWeeksAgoLabel => 'il y a 2 semaines';

  @override
  String get threeWeeksAgoLabel => 'il y a 3 semaines';

  @override
  String get totalCaloriesLabel => 'Calories totales';

  @override
  String get calsLabel => 'calories';

  @override
  String get dayShortSun => 'Dim';

  @override
  String get dayShortMon => 'Lun';

  @override
  String get dayShortTue => 'Mar';

  @override
  String get dayShortWed => 'Mer';

  @override
  String get dayShortThu => 'Jeu';

  @override
  String get dayShortFri => 'Ven';

  @override
  String get dayShortSat => 'Sam';

  @override
  String get ninetyDaysLabel => '90 jours';

  @override
  String get sixMonthsLabel => '6 mois';

  @override
  String get oneYearLabel => '1 an';

  @override
  String get allTimeLabel => 'Tout le temps';

  @override
  String get waitingForFirstLogLabel => 'En attendant votre premier journal...';

  @override
  String get editGoalPickerTitle => 'Modifier le sélecteur d\'objectifs';

  @override
  String get bmiDisclaimerTitle => 'Clause de non-responsabilité';

  @override
  String get bmiDisclaimerBody =>
      'Comme pour la plupart des mesures de santé, l’IMC n’est pas un test parfait. Par exemple, les résultats peuvent être altérés par une grossesse ou une masse musculaire élevée, et cela peut ne pas constituer une bonne mesure de la santé des enfants ou des personnes âgées.';

  @override
  String get bmiWhyItMattersTitle => 'Alors, pourquoi l’IMC est-il important ?';

  @override
  String get bmiWhyItMattersBody =>
      'En général, plus votre IMC est élevé, plus le risque de développer diverses affections liées à l\'excès de poids est élevé, notamment :\\n� le diabète\\n� l\'arthrite\\n� les maladies du foie\\n� plusieurs types de cancer (comme ceux du sein, du côlon et de la prostate)\\n� l\'hypertension artérielle (hypertension)\\n� l\'hypercholestérolémie\\n� l\'apnée du sommeil';

  @override
  String get noWeightHistoryYet =>
      'Aucun historique de poids n\'a encore été enregistré.';

  @override
  String get overLabel => 'sur';

  @override
  String get dailyBreakdownTitle => 'Répartition quotidienne';

  @override
  String get editDailyGoalsLabel => 'Modifier les objectifs quotidiens';

  @override
  String get errorLoadingData => 'Erreur de chargement des données';

  @override
  String get gramsLabel => 'grammes';

  @override
  String get healthStatusNotEvaluated => 'Non évalué';

  @override
  String get healthStatusCriticallyLow => 'Critiquement bas';

  @override
  String get healthStatusNeedsImprovement => 'Besoin d\'amélioration';

  @override
  String get healthStatusFairProgress => 'Des progrès équitables';

  @override
  String get healthStatusGoodHealth => 'Bonne santé';

  @override
  String get healthStatusExcellentHealth => 'Excellente santé';

  @override
  String get remindersTitle => 'Rappels';

  @override
  String get failedLoadReminderSettings =>
      'Échec du chargement des paramètres de rappel.';

  @override
  String get smartNutritionRemindersTitle =>
      'Rappels nutritionnels intelligents';

  @override
  String get dailyReminderAtLabel => 'Rappel quotidien à';

  @override
  String get setSmartNutritionTimeLabel =>
      'Définir un moment de nutrition intelligent';

  @override
  String get waterRemindersTitle => 'Rappels d\'eau';

  @override
  String get everyLabel => 'Chaque';

  @override
  String get hourUnitLabel => 'heures)';

  @override
  String get fromLabel => 'depuis';

  @override
  String get setWaterStartTimeLabel => 'Régler l\'heure de début de l\'eau';

  @override
  String get breakfastReminderTitle => 'Rappel du petit-déjeuner';

  @override
  String get lunchReminderTitle => 'Rappel du déjeuner';

  @override
  String get dinnerReminderTitle => 'Rappel du dîner';

  @override
  String get snackReminderTitle => 'Rappel de collation';

  @override
  String get goalTrackingAlertsTitle => 'Alertes de suivi des objectifs';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Alertes proches/dépassées des calories et des objectifs macro';

  @override
  String get stepsExerciseReminderTitle => 'Rappel des étapes/exercices';

  @override
  String get dailyAtLabel => 'Quotidiennement à';

  @override
  String get setActivityReminderTimeLabel =>
      'Définir l\'heure de rappel d\'activité';

  @override
  String get intervalLabel => 'Intervalle:';

  @override
  String get setTimeLabel => 'Régler l\'heure';

  @override
  String get languageNameEnglish => 'Anglais';

  @override
  String get languageNameSpanish => 'Espagnol';

  @override
  String get languageNamePortuguese => 'Portugais';

  @override
  String get languageNameFrench => 'Français';

  @override
  String get languageNameGerman => 'Allemand';

  @override
  String get languageNameItalian => 'Italien';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Le démarrage est la partie la plus difficile. Vous êtes prêt pour ça !';

  @override
  String get progressMessageKeepPushing =>
      'Vous faites des progrès. Il est maintenant temps de continuer à pousser !';

  @override
  String get progressMessagePayingOff =>
      'Ta motivation porte ses fruits. Continue !';

  @override
  String get progressMessageFinalStretch =>
      'C\'est la dernière ligne droite. Poussez-vous !';

  @override
  String get progressMessageCongrats => 'Vous l\'avez fait ! Félicitations!';

  @override
  String dayStreakWithCount(Object count) {
    return 'Série de jours $count';
  }

  @override
  String get streakLostTitle => 'Série perdue';

  @override
  String get streakActiveSubtitle =>
      'Tu es en feu ! Continue à enregistrer pour garder ton élan.';

  @override
  String get streakLostSubtitle =>
      'N\'abandonnez pas. Enregistrez vos repas aujourd\'hui pour vous remettre sur la bonne voie.';

  @override
  String get dayInitialSun => 'D';

  @override
  String get dayInitialMon => 'L';

  @override
  String get dayInitialTue => 'M';

  @override
  String get dayInitialWed => 'M';

  @override
  String get dayInitialThu => 'J';

  @override
  String get dayInitialFri => 'V';

  @override
  String get dayInitialSat => 'S';

  @override
  String get alertCalorieGoalExceededTitle => 'Objectif calorique dépassé';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'Vous avez $over kcal au-dessus de votre objectif quotidien.';
  }

  @override
  String get alertNearCalorieLimitTitle =>
      'Vous êtes proche de votre limite calorique';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Il ne reste aujourd’hui que $remaining kcal. Planifiez soigneusement votre prochain repas.';
  }

  @override
  String get alertProteinBehindTitle => 'La cible protéique est en retard';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'Vous avez encore besoin d\'environ $missing g de protéine pour atteindre l\'objectif d\'aujourd\'hui.';
  }

  @override
  String get alertCarbTargetExceededTitle => 'Objectif de glucides dépassé';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'Les glucides sont $over g au-dessus de la cible.';
  }

  @override
  String get alertFatTargetExceededTitle => 'Objectif de graisse dépassé';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'La graisse est $over g au-dessus de la cible.';
  }

  @override
  String get smartNutritionTipTitle => 'Conseil nutritionnel intelligent';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal restant';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal supérieur';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g de protéines restantes';
  }

  @override
  String get smartNutritionProteinGoalReached => 'objectif protéique atteint';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage et $proteinMessage. Enregistrez votre prochain repas pour rester sur la bonne voie.';
  }

  @override
  String get notificationStepsExerciseTitle =>
      'Rappel des étapes et des exercices';

  @override
  String get notificationStepsExerciseBody =>
      'Enregistrez vos pas ou votre entraînement pour atteindre l\'objectif d\'activité du jour.';

  @override
  String get notificationBreakfastTitle => 'Rappel du petit-déjeuner';

  @override
  String get notificationBreakfastBody =>
      'Enregistrez le petit-déjeuner pour commencer tôt votre suivi des calories et des macros.';

  @override
  String get notificationLunchTitle => 'Rappel du déjeuner';

  @override
  String get notificationLunchBody =>
      'L\'heure du déjeuner. Ajoutez votre repas pour que vos progrès quotidiens restent précis.';

  @override
  String get notificationDinnerTitle => 'Rappel du dîner';

  @override
  String get notificationDinnerBody =>
      'Connectez-vous au dîner et terminez votre journée avec des données nutritionnelles complètes.';

  @override
  String get notificationSnackTitle => 'Rappel de collation';

  @override
  String get notificationSnackBody =>
      'Ajoutez votre collation pour que les calories et les macros restent alignées sur vos objectifs.';

  @override
  String get smartNutritionDailyTitle =>
      'Enregistrement nutritionnel intelligent';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Ciblez les kcal $calories, les protéines ${protein}g, les glucides ${carbs}g, les graisses ${fats}g. Enregistrez votre dernier repas pour que votre plan reste précis.';
  }

  @override
  String get notificationWaterTitle => 'Rappel d\'eau';

  @override
  String get notificationWaterBody =>
      'Contrôle d\'hydratation. Enregistrez un verre d’eau dans Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Enregistrez votre nourriture';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Calories aujourd\'hui';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories sur $goal kcal';
  }
}
