// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Inizio';

  @override
  String get progressTab => 'Progressi';

  @override
  String get settingsTab => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get welcomeMessage => 'Benvenuti a Cal AI';

  @override
  String get trackMessage =>
      'Tieni traccia in modo più intelligente. Mangia meglio.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get alreadyAccount => 'Hai già un account?';

  @override
  String get signIn => 'Registrazione';

  @override
  String get chooseLanguage => 'Scegli la lingua';

  @override
  String get personalDetails => 'Dettagli personali';

  @override
  String get adjustMacronutrients => 'Regola i macronutrienti';

  @override
  String get weightHistory => 'Cronologia del peso';

  @override
  String get homeWidget => 'Widget casa';

  @override
  String get chooseHomeWidgets => 'Scegli Widget domestici';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Tocca le opzioni per aggiungere o rimuovere widget.';

  @override
  String get updatingWidgetSelection =>
      'Aggiornamento della selezione del widget...';

  @override
  String get requestingWidgetPermission => 'Richiesta autorizzazione widget...';

  @override
  String get widget1 => 'Dispositivo 1';

  @override
  String get widget2 => 'Dispositivo 2';

  @override
  String get widget3 => 'Dispositivo 3';

  @override
  String get calorieTrackerWidget => 'Monitoraggio delle calorie';

  @override
  String get nutritionTrackerWidget => 'Monitoraggio della nutrizione';

  @override
  String get streakTrackerWidget => 'Tracciatore di strisce';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName rimosso dalla selezione.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'Per rimuovere $widgetName, rimuovilo dalla schermata iniziale. La selezione si sincronizza automaticamente.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'Per aggiungere $widgetName, premere a lungo la schermata principale, toccare +, quindi selezionare Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return 'Widget $widgetName aggiunto.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Autorizzazione necessaria per aggiungere $widgetName. Abbiamo aperto le impostazioni per te.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'Impossibile aprire le impostazioni delle autorizzazioni. Abilita manualmente le autorizzazioni per aggiungere $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen => 'Nessun widget sulla schermata iniziale';

  @override
  String selectedWidgets(Object widgets) {
    return 'Selezionato: $widgets';
  }

  @override
  String get backupData => 'Effettua il backup dei tuoi dati';

  @override
  String get signInToSync =>
      'Accedi per sincronizzare i tuoi progressi e obiettivi';

  @override
  String get accountSuccessfullyBackedUp =>
      'Backup dell\'account eseguito con successo!';

  @override
  String get failedToLinkAccount => 'Impossibile collegare l\'account.';

  @override
  String get googleAccountAlreadyLinked =>
      'Questo account Google è già collegato a un altro profilo Cal AI.';

  @override
  String get caloriesLabel => 'Calorie';

  @override
  String get eatenLabel => 'mangiato';

  @override
  String get leftLabel => 'rimaste';

  @override
  String get proteinLabel => 'Proteina';

  @override
  String get carbsLabel => 'Carboidrati';

  @override
  String get fatsLabel => 'Grassi';

  @override
  String get fiberLabel => 'Fibra';

  @override
  String get sugarLabel => 'Zucchero';

  @override
  String get sodiumLabel => 'Sodio';

  @override
  String get stepsLabel => 'Passi';

  @override
  String get stepsTodayLabel => 'Passi oggi';

  @override
  String get caloriesBurnedLabel => 'Calorie bruciate';

  @override
  String get stepTrackingActive => 'Monitoraggio dei passi attivo!';

  @override
  String get waterLabel => 'Acqua';

  @override
  String get servingSizeLabel => 'Porzione';

  @override
  String get waterSettingsTitle => 'Impostazioni dell\'acqua';

  @override
  String get hydrationQuestion =>
      'Di quanta acqua hai bisogno per rimanere idratato?';

  @override
  String get hydrationInfo =>
      'Le esigenze di ognuno sono leggermente diverse, ma consigliamo di assumere almeno 8 tazze di acqua ogni giorno.';

  @override
  String get healthScoreTitle => 'Punteggio sulla salute';

  @override
  String get healthSummaryNoData =>
      'Nessun dato registrato per oggi. Inizia a monitorare i tuoi pasti per vedere i tuoi approfondimenti sulla salute!';

  @override
  String get healthSummaryLowIntake =>
      'Il tuo apporto è piuttosto basso. Concentrati sul raggiungimento dei tuoi obiettivi calorici e proteici per mantenere energia e muscoli.';

  @override
  String get healthSummaryLowProtein =>
      'Carboidrati e grassi sono sulla buona strada, ma hai poche proteine. Aumentare le proteine ​​può aiutare con la ritenzione muscolare.';

  @override
  String get healthSummaryGreat =>
      'Ottimo lavoro! La tua alimentazione oggi è ben bilanciata.';

  @override
  String get recentlyLoggedTitle => 'Registrato di recente';

  @override
  String errorLoadingLogs(Object error) {
    return 'Errore durante il caricamento dei registri: $error';
  }

  @override
  String get deleteLabel => 'Eliminare';

  @override
  String get tapToAddFirstEntry => 'Tocca + per aggiungere la tua prima voce';

  @override
  String unableToLoadProgress(Object error) {
    return 'Impossibile caricare i progressi: $error';
  }

  @override
  String get myWeightTitle => 'Il mio peso';

  @override
  String goalWithValue(Object value) {
    return 'Obiettivo $value';
  }

  @override
  String get noGoalSet => 'Nessun obiettivo fissato';

  @override
  String get logWeightCta => 'Peso del registro';

  @override
  String get dayStreakTitle => 'Serie di giorni';

  @override
  String get progressPhotosTitle => 'Foto di progresso';

  @override
  String get progressPhotoPrompt =>
      'Vuoi aggiungere una foto per monitorare i tuoi progressi?';

  @override
  String get uploadPhotoCta => 'Carica una foto';

  @override
  String get goalProgressTitle => 'Progresso dell\'obiettivo';

  @override
  String get ofGoalLabel => 'di obiettivo';

  @override
  String get logoutLabel => 'Esci';

  @override
  String get logoutTitle => 'Esci';

  @override
  String get logoutConfirmMessage => 'Sei sicuro di voler uscire?';

  @override
  String get cancelLabel => 'Cancellare';

  @override
  String get preferencesLabel => 'Preferenze';

  @override
  String get appearanceLabel => 'Aspetto';

  @override
  String get appearanceDescription =>
      'Scegli l\'aspetto chiaro, scuro o di sistema';

  @override
  String get lightLabel => 'Leggero';

  @override
  String get darkLabel => 'Buio';

  @override
  String get automaticLabel => 'Automatico';

  @override
  String get addBurnedCaloriesLabel => 'Aggiungi calorie bruciate';

  @override
  String get addBurnedCaloriesDescription =>
      'Aggiungi le calorie bruciate all\'obiettivo giornaliero';

  @override
  String get rolloverCaloriesLabel => 'Calorie aggiuntive';

  @override
  String get rolloverCaloriesDescription =>
      'Aggiungi fino a 200 calorie rimanenti all\'obiettivo di oggi';

  @override
  String get measurementUnitLabel => 'Unità di misura';

  @override
  String get measurementUnitDescription =>
      'Tutti i valori verranno convertiti in imperiali (attualmente in metriche)';

  @override
  String get inviteFriendsLabel => 'Invita amici';

  @override
  String get defaultUserName => 'utente';

  @override
  String get enterYourNameLabel => 'Inserisci il tuo nome';

  @override
  String yearsOldLabel(Object years) {
    return '$years anni';
  }

  @override
  String get termsAndConditionsLabel => 'Termini e Condizioni';

  @override
  String get privacyPolicyLabel => 'politica sulla riservatezza';

  @override
  String get supportEmailLabel => 'E-mail di supporto';

  @override
  String get featureRequestLabel => 'Richiesta di funzionalità';

  @override
  String get deleteAccountQuestion => 'Eliminare l\'account?';

  @override
  String get deleteAccountTitle => 'Elimina account';

  @override
  String get deleteAccountMessage =>
      'Ne sei assolutamente sicuro? Ciò eliminerà definitivamente la cronologia Cal AI, i registri del peso e gli obiettivi personalizzati. Questa azione non può essere annullata.';

  @override
  String get deletePermanentlyLabel => 'Elimina definitivamente';

  @override
  String get onboardingChooseGenderTitle => 'Scegli il tuo sesso';

  @override
  String get onboardingChooseGenderSubtitle =>
      'Questo verrà utilizzato per calibrare il tuo piano personalizzato.';

  @override
  String get genderFemale => 'Femmina';

  @override
  String get genderMale => 'Maschio';

  @override
  String get genderOther => 'Altro';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'Quanti allenamenti fai alla settimana?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'Questo verrà utilizzato per calibrare il tuo piano personalizzato.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Allenamenti di tanto in tanto';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle => 'Alcuni allenamenti a settimana';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Atleta dedicato';

  @override
  String get onboardingHearAboutUsTitle => 'Dove hai sentito parlare di noi?';

  @override
  String get sourceTikTok => 'Tik Tok';

  @override
  String get sourceYouTube => 'YouTube';

  @override
  String get sourceGoogle => 'Google';

  @override
  String get sourcePlayStore => 'Gioca al negozio';

  @override
  String get sourceFacebook => 'Facebook';

  @override
  String get sourceFriendFamily => 'Amico o famiglia';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Altro';

  @override
  String get yourBmiTitle => 'Il tuo indice di massa corporea';

  @override
  String get yourWeightIsLabel => 'Il tuo peso è';

  @override
  String get bmiUnderweightLabel => 'Sottopeso';

  @override
  String get bmiHealthyLabel => 'Salutare';

  @override
  String get bmiOverweightLabel => 'Sovrappeso';

  @override
  String get bmiObeseLabel => 'Obeso';

  @override
  String get calorieTrackingMadeEasy =>
      'Il monitoraggio delle calorie diventa semplice';

  @override
  String get onboardingStep1Title => 'Tieni traccia dei tuoi pasti';

  @override
  String get onboardingStep1Description =>
      'Registra facilmente i tuoi pasti e monitora la tua alimentazione.';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get signInWithEmail => 'Accedi con l\'e-mail';

  @override
  String signInFailed(Object error) {
    return 'Accesso non riuscito: $error';
  }

  @override
  String get continueLabel => 'Continuare';

  @override
  String get skipLabel => 'Saltare';

  @override
  String get noLabel => 'NO';

  @override
  String get yesLabel => 'SÌ';

  @override
  String get submitLabel => 'Invia';

  @override
  String get referralCodeLabel => 'Codice di riferimento';

  @override
  String get heightLabel => 'Altezza';

  @override
  String get weightLabel => 'Peso';

  @override
  String get imperialLabel => 'Imperiale';

  @override
  String get metricLabel => 'Metrico';

  @override
  String get month1Label => 'Mese 1';

  @override
  String get month6Label => 'Mese 6';

  @override
  String get traditionalDietLabel => 'Dieta tradizionale';

  @override
  String get weightChartSummary =>
      'L\'80% degli utenti di Cal AI mantiene la perdita di peso anche 6 mesi dopo';

  @override
  String get comparisonWithoutCalAi => 'Senza\\nCal AI';

  @override
  String get comparisonWithCalAi => 'Con\\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI lo rende facile e tiene';

  @override
  String get comparisonBottomLine2 => 'tu responsabile';

  @override
  String get speedSlowSteady => 'Lento e costante';

  @override
  String get speedRecommended => 'Raccomandato';

  @override
  String get speedAggressiveWarning =>
      'Potresti sentirti molto stanco e sviluppare la pelle flaccida';

  @override
  String get subscriptionHeadline =>
      'Sblocca CalAI per raggiungere\\ni tuoi obiettivi più velocemente.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Solo PHP $yearlyPrice all\'anno (PHP $monthlyPrice/mese)';
  }

  @override
  String get goalGainWeight => 'Aumentare peso';

  @override
  String get goalLoseWeight => 'Perdere peso';

  @override
  String get goalMaintainWeight => 'Mantenere il peso';

  @override
  String editGoalTitle(Object title) {
    return 'Modifica obiettivo $title';
  }

  @override
  String get revertLabel => 'Ripristina';

  @override
  String get doneLabel => 'Fatto';

  @override
  String get dashboardShouldGainWeight => 'guadagno';

  @override
  String get dashboardShouldLoseWeight => 'perdere';

  @override
  String get dashboardShouldMaintainWeight => 'mantenere';

  @override
  String get dashboardCongratsPlanReady =>
      'Congratulazioni\\nil tuo piano personalizzato è pronto!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'Dovresti $action:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit di $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Raccomandazione quotidiana';

  @override
  String get dashboardEditAnytime => 'Puoi modificarlo in qualsiasi momento';

  @override
  String get dashboardHowToReachGoals => 'Come raggiungere i tuoi obiettivi:';

  @override
  String get dashboardReachGoalLifeScore =>
      'Ottieni il tuo punteggio di vita settimanale e migliora la tua routine.';

  @override
  String get dashboardReachGoalTrackFood => 'Tieni traccia del tuo cibo';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Segui la tua raccomandazione calorica giornaliera';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Bilancia i tuoi carboidrati, proteine, grassi';

  @override
  String get dashboardPlanSourcesTitle =>
      'Piano basato sulle seguenti fonti, oltre ad altri studi medici sottoposti a revisione paritaria:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Tasso metabolico basale';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Conteggio delle calorie - Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'Società Internazionale di Nutrizione Sportiva';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'Istituti Nazionali di Sanità';

  @override
  String get factorsNetCarbsMass => 'Carboidrati netti/massa';

  @override
  String get factorsNetCarbDensity => 'Densità netta di carboidrati';

  @override
  String get factorsSodiumMass => 'Sodio/massa';

  @override
  String get factorsSodiumDensity => 'Densità del sodio';

  @override
  String get factorsSugarMass => 'Zucchero/massa';

  @override
  String get factorsSugarDensity => 'Densità dello zucchero';

  @override
  String get factorsProcessedScore => 'Punteggio elaborato';

  @override
  String get factorsIngredientQuality => 'Qualità degli ingredienti';

  @override
  String get factorsProcessedScoreDescription =>
      'Il punteggio elaborato tiene conto di coloranti, nitrati, oli di semi, aromi/dolcificanti artificiali e altri fattori.';

  @override
  String get healthScoreExplanationIntro =>
      'Il nostro punteggio sulla salute è una formula complessa che tiene conto di diversi fattori data una moltitudine di alimenti comuni.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'Di seguito sono riportati i fattori che prendiamo in considerazione nel calcolo del punteggio di salute:';

  @override
  String get netCarbsLabel => 'Carboidrati netti';

  @override
  String get howDoesItWork => 'Come funziona?';

  @override
  String get goodLabel => 'Bene';

  @override
  String get badLabel => 'Cattivo';

  @override
  String get dailyRecommendationFor => 'Raccomandazione quotidiana per';

  @override
  String get loadingCustomizingHealthPlan =>
      'Personalizzazione del piano sanitario...';

  @override
  String get loadingApplyingBmrFormula => 'Applicazione della formula BMR...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'Stima della tua età metabolica...';

  @override
  String get loadingFinalizingResults => 'Finalizzazione dei risultati...';

  @override
  String get loadingSetupForYou => 'Stiamo impostando tutto\\nper te';

  @override
  String get step4TriedOtherCalorieApps =>
      'Hai provato altre app per il monitoraggio delle calorie?';

  @override
  String get step5CalAiLongTermResults =>
      'Cal AI crea risultati a lungo termine';

  @override
  String get step6HeightWeightTitle => 'Altezza e peso';

  @override
  String get step6HeightWeightSubtitle =>
      'Questo verrà preso in considerazione nel calcolo dei tuoi obiettivi nutrizionali giornalieri.';

  @override
  String get step7WhenWereYouBorn => 'Quando sei nato?';

  @override
  String get step8GoalQuestionTitle => 'Qual è il tuo obiettivo?';

  @override
  String get step8GoalQuestionSubtitle =>
      'Questo ci aiuta a generare un piano per il tuo apporto calorico.';

  @override
  String get step9SpecificDietQuestion => 'Segui una dieta specifica?';

  @override
  String get step9DietClassic => 'Classico';

  @override
  String get step9DietPescatarian => 'Pescatario';

  @override
  String get step9DietVegetarian => 'Vegetariano';

  @override
  String get step9DietVegan => 'Vegano';

  @override
  String get step91DesiredWeightQuestion => 'Qual è il tuo peso desiderato?';

  @override
  String get step92GoalActionGaining => 'Guadagnare';

  @override
  String get step92GoalActionLosing => 'Perdere';

  @override
  String get step92RealisticTargetSuffix =>
      'è un obiettivo realistico. Non è affatto difficile!';

  @override
  String get step92SocialProof =>
      'Il 90% degli utenti afferma che il cambiamento è evidente dopo aver utilizzato Cal AI e non è facile riprendersi.';

  @override
  String get step93GoalVerbGain => 'Guadagno';

  @override
  String get step93GoalVerbLose => 'Perdere';

  @override
  String get step93SpeedQuestionTitle =>
      'Quanto velocemente vuoi raggiungere il tuo obiettivo?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return 'Velocità di peso $action a settimana';
  }

  @override
  String get step94ComparisonTitle =>
      'Perdi il doppio del peso con Cal AI rispetto a te stesso';

  @override
  String get step95ObstaclesTitle =>
      'Cosa ti impedisce di raggiungere i tuoi obiettivi?';

  @override
  String get step10AccomplishTitle => 'Cosa vorresti realizzare?';

  @override
  String get step10OptionHealthier => 'Mangia e vivi più sano';

  @override
  String get step10OptionEnergyMood => 'Migliora la mia energia e il mio umore';

  @override
  String get step10OptionConsistency => 'Rimani motivato e coerente';

  @override
  String get step10OptionBodyConfidence => 'Mi sento meglio con il mio corpo';

  @override
  String get step11PotentialTitle =>
      'Hai un grande potenziale per raggiungere il tuo obiettivo';

  @override
  String get step12ThankYouTitle => 'Grazie per\\nfiducia in noi!';

  @override
  String get step12PersonalizeSubtitle =>
      'Ora personalizziamo Cal AI per te...';

  @override
  String get step12PrivacyCardTitle =>
      'La tua privacy e la tua sicurezza sono importanti per noi.';

  @override
  String get step12PrivacyCardBody =>
      'Promettiamo di mantenere sempre le tue\\ninformazioni personali private e sicure.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Raggiungi i tuoi obiettivi con le notifiche';

  @override
  String get step13NotificationPrompt => 'Cal AI vorrebbe inviarti notifiche';

  @override
  String get allowLabel => 'Permettere';

  @override
  String get dontAllowLabel => 'Non consentire';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'Aggiungere le calorie bruciate al tuo obiettivo quotidiano?';

  @override
  String get step15RolloverQuestion =>
      'Trasferire le calorie extra al giorno successivo?';

  @override
  String get step15RolloverUpTo => 'Rollover fino a';

  @override
  String get step15RolloverCap => '200 calorie';

  @override
  String get step16ReferralTitle =>
      'Inserisci il codice di riferimento (facoltativo)';

  @override
  String get step16ReferralSubtitle => 'Puoi saltare questo passaggio';

  @override
  String get step17AllDone => 'Tutto fatto!';

  @override
  String get step17GeneratePlanTitle =>
      'È ora di generare il tuo piano personalizzato!';

  @override
  String get step18CalculationError =>
      'Impossibile calcolare il piano. Per favore controlla la tua connessione.';

  @override
  String get step18TryAgain => 'Riprova';

  @override
  String get step19CreateAccountTitle => 'Creare un account';

  @override
  String get authInvalidEmailMessage =>
      'Si prega di inserire un indirizzo email valido';

  @override
  String get authCheckYourEmailTitle => 'Controlla la tua email';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'Abbiamo inviato un collegamento di accesso a $email';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Errore: $error';
  }

  @override
  String get authWhatsYourEmail => 'Qual è la tua email?';

  @override
  String get authPasswordlessHint =>
      'Ti invieremo un link per accedere senza password.';

  @override
  String get emailExampleHint => 'nome@esempio.com';

  @override
  String get notSetLabel => 'Non impostato';

  @override
  String get goalWeightLabel => 'Peso obiettivo';

  @override
  String get changeGoalLabel => 'Cambia obiettivo';

  @override
  String get currentWeightLabel => 'Peso attuale';

  @override
  String get dateOfBirthLabel => 'Data di nascita';

  @override
  String get genderLabel => 'Genere';

  @override
  String get dailyStepGoalLabel => 'Obiettivo di passi giornaliero';

  @override
  String get stepGoalLabel => 'Obiettivo del passo';

  @override
  String get setHeightTitle => 'Imposta altezza';

  @override
  String get setGenderTitle => 'Imposta il sesso';

  @override
  String get setBirthdayTitle => 'Imposta compleanno';

  @override
  String get setWeightTitle => 'Imposta peso';

  @override
  String get editNameTitle => 'Modifica nome';

  @override
  String get calorieGoalLabel => 'Obiettivo calorico';

  @override
  String get proteinGoalLabel => 'Obiettivo proteico';

  @override
  String get carbGoalLabel => 'Obiettivo carboidrati';

  @override
  String get fatGoalLabel => 'Obiettivo grasso';

  @override
  String get sugarLimitLabel => 'Limite di zucchero';

  @override
  String get fiberGoalLabel => 'Obiettivo fibra';

  @override
  String get sodiumLimitLabel => 'Limite di sodio';

  @override
  String get hideMicronutrientsLabel => 'Nascondi i micronutrienti';

  @override
  String get viewMicronutrientsLabel => 'Visualizza i micronutrienti';

  @override
  String get autoGenerateGoalsLabel => 'Genera automaticamente obiettivi';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Impossibile generare obiettivi: $error';
  }

  @override
  String get calculatingCustomGoals =>
      'Calcolo degli obiettivi personalizzati in corso...';

  @override
  String get logExerciseLabel => 'Registra l\'esercizio';

  @override
  String get savedFoodsLabel => 'Cibi salvati';

  @override
  String get foodDatabaseLabel => 'Banca dati alimentare';

  @override
  String get scanFoodLabel => 'Scansiona il cibo';

  @override
  String get exerciseTitle => 'Esercizio';

  @override
  String get runTitle => 'Corsa';

  @override
  String get weightLiftingTitle => 'Sollevamento pesi';

  @override
  String get describeTitle => 'Descrivere';

  @override
  String get runDescription => 'Correre, fare jogging, correre, ecc.';

  @override
  String get weightLiftingDescription => 'Macchine, pesi liberi, ecc.';

  @override
  String get describeWorkoutDescription =>
      'Scrivi il tuo allenamento nel testo';

  @override
  String get setIntensityLabel => 'Imposta l\'intensità';

  @override
  String get durationLabel => 'Durata';

  @override
  String get minutesShortLabel => 'min';

  @override
  String get minutesAbbrevSuffix => 'min';

  @override
  String get addLabel => 'Aggiungere';

  @override
  String get intensityLabel => 'Intensità';

  @override
  String get intensityHighLabel => 'Alto';

  @override
  String get intensityMediumLabel => 'Medio';

  @override
  String get intensityLowLabel => 'Basso';

  @override
  String get runIntensityHighDescription => 'Sprint - 14 mph (4 minuti miglia)';

  @override
  String get runIntensityMediumDescription =>
      'Jogging - 6 mph (10 minuti miglia)';

  @override
  String get runIntensityLowDescription =>
      'Camminata rilassante - 3 mph (20 minuti miglia)';

  @override
  String get weightIntensityHighDescription =>
      'Allenamento fino al cedimento, respiro affannoso';

  @override
  String get weightIntensityMediumDescription => 'Sudare, molte ripetizioni';

  @override
  String get weightIntensityLowDescription => 'Senza sudare, con poco sforzo';

  @override
  String get exerciseLoggedSuccessfully => 'Esercizio registrato con successo!';

  @override
  String get exerciseParsedAndLogged => 'Esercizio analizzato e registrato!';

  @override
  String get describeExerciseTitle => 'Descrivi l\'esercizio';

  @override
  String get whatDidYouDoHint => 'Che cosa hai fatto?';

  @override
  String get describeExerciseExample =>
      'Esempio: escursione all\'aria aperta per 5 ore, mi sentivo esausto';

  @override
  String get servingLabel => 'Servire';

  @override
  String get productNotFoundMessage => 'Prodotto non trovato.';

  @override
  String couldNotIdentify(Object text) {
    return 'Impossibile identificare \"$text\".';
  }

  @override
  String get identifyingFoodMessage => 'Identificare il cibo...';

  @override
  String get loggedSuccessfullyMessage => 'Registrato con successo!';

  @override
  String get barcodeScannerLabel => 'Lettore di codici a barre';

  @override
  String get barcodeLabel => 'Codice a barre';

  @override
  String get foodLabel => 'Etichetta alimentare';

  @override
  String get galleryLabel => 'Galleria';

  @override
  String get bestScanningPracticesTitle => 'Migliori pratiche di scansione';

  @override
  String get generalTipsTitle => 'Consigli generali:';

  @override
  String get scanTipKeepFoodInside =>
      'Mantenere il cibo all\'interno delle linee di scansione';

  @override
  String get scanTipHoldPhoneStill =>
      'Tieni fermo il telefono in modo che l\'immagine non sia sfocata';

  @override
  String get scanTipAvoidObscureAngles =>
      'Non scattare la foto da angolazioni oscure';

  @override
  String get scanNowLabel => 'Scansiona ora';

  @override
  String get allTabLabel => 'Tutto';

  @override
  String get myMealsTabLabel => 'I miei pasti';

  @override
  String get myFoodsTabLabel => 'I miei cibi';

  @override
  String get savedScansTabLabel => 'Scansioni salvate';

  @override
  String get logEmptyFoodLabel => 'Registra il cibo vuoto';

  @override
  String get searchResultsLabel => 'Risultati della ricerca';

  @override
  String get suggestionsLabel => 'Suggerimenti';

  @override
  String get noItemsFoundLabel => 'Nessun articolo trovato.';

  @override
  String get noSuggestionsAvailableLabel => 'Nessun suggerimento disponibile';

  @override
  String get noSavedScansYetLabel => 'Nessuna scansione ancora salvata';

  @override
  String get describeWhatYouAteHint => 'Descrivi cosa hai mangiato';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return 'Aggiunto $foodName a $dateId';
  }

  @override
  String get failedToAddFood => 'Impossibile aggiungere il cibo. Riprova.';

  @override
  String get invalidFoodIdMessage => 'ID cibo non valido';

  @override
  String get foodNotFoundMessage => 'Cibo non trovato';

  @override
  String get couldNotLoadFoodDetails =>
      'Impossibile caricare i dettagli del cibo';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Standard';

  @override
  String get selectedFoodTitle => 'Cibo selezionato';

  @override
  String get measurementLabel => 'Misurazione';

  @override
  String get otherNutritionFactsLabel => 'Altri dati nutrizionali';

  @override
  String get numberOfServingsLabel => 'Numero di porzioni';

  @override
  String get logLabel => 'Registra';

  @override
  String get nutrientsTitle => 'Nutrienti';

  @override
  String get totalNutritionLabel => 'Nutrizione totale';

  @override
  String get enterFoodNameHint => 'Inserisci il nome del cibo';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get statsLabel => 'Statistiche';

  @override
  String get intensityModerateLabel => 'Moderare';

  @override
  String get thisWeekLabel => 'Questa settimana';

  @override
  String get lastWeekLabel => 'La settimana scorsa';

  @override
  String get twoWeeksAgoLabel => '2 settimane fa';

  @override
  String get threeWeeksAgoLabel => '3 settimane fa';

  @override
  String get totalCaloriesLabel => 'Calorie totali';

  @override
  String get calsLabel => 'cal';

  @override
  String get dayShortSun => 'Dom';

  @override
  String get dayShortMon => 'Lun';

  @override
  String get dayShortTue => 'Mar';

  @override
  String get dayShortWed => 'Mer';

  @override
  String get dayShortThu => 'Gio';

  @override
  String get dayShortFri => 'Ven';

  @override
  String get dayShortSat => 'Sab';

  @override
  String get ninetyDaysLabel => '90 giorni';

  @override
  String get sixMonthsLabel => '6 mesi';

  @override
  String get oneYearLabel => '1 anno';

  @override
  String get allTimeLabel => 'Tutto il tempo';

  @override
  String get waitingForFirstLogLabel =>
      'In attesa della tua prima registrazione...';

  @override
  String get editGoalPickerTitle => 'Modifica il selettore degli obiettivi';

  @override
  String get bmiDisclaimerTitle => 'Avvertenza';

  @override
  String get bmiDisclaimerBody =>
      'Come con la maggior parte delle misure di salute, il BMI non è un test perfetto. Ad esempio, i risultati possono essere annullati dalla gravidanza o da un’elevata massa muscolare e potrebbero non essere un buon indicatore della salute di un bambino o di un anziano.';

  @override
  String get bmiWhyItMattersTitle => 'Allora, perché il BMI è importante?';

  @override
  String get bmiWhyItMattersBody =>
      'In generale, più alto è il tuo indice di massa corporea, maggiore è il rischio di sviluppare una serie di condizioni legate all\'eccesso di peso, tra cui:\\n� diabete\\n� artrite\\n� malattie del fegato\\n� diversi tipi di cancro (come quelli del seno, del colon e della prostata)\\n� pressione alta (ipertensione)\\n� colesterolo alto\\n� apnea notturna';

  @override
  String get noWeightHistoryYet =>
      'Nessuna cronologia del peso ancora registrata.';

  @override
  String get overLabel => 'Sopra';

  @override
  String get dailyBreakdownTitle => 'Ripartizione giornaliera';

  @override
  String get editDailyGoalsLabel => 'Modifica obiettivi giornalieri';

  @override
  String get errorLoadingData => 'Errore durante il caricamento dei dati';

  @override
  String get gramsLabel => 'grammi';

  @override
  String get healthStatusNotEvaluated => 'Non valutato';

  @override
  String get healthStatusCriticallyLow => 'Criticamente basso';

  @override
  String get healthStatusNeedsImprovement => 'Ha bisogno di miglioramenti';

  @override
  String get healthStatusFairProgress => 'Discreto progresso';

  @override
  String get healthStatusGoodHealth => 'Buona salute';

  @override
  String get healthStatusExcellentHealth => 'Ottima salute';

  @override
  String get remindersTitle => 'Promemoria';

  @override
  String get failedLoadReminderSettings =>
      'Impossibile caricare le impostazioni del promemoria.';

  @override
  String get smartNutritionRemindersTitle =>
      'Promemoria nutrizionali intelligenti';

  @override
  String get dailyReminderAtLabel => 'Promemoria quotidiano a';

  @override
  String get setSmartNutritionTimeLabel =>
      'Imposta un orario di alimentazione intelligente';

  @override
  String get waterRemindersTitle => 'Promemoria dell\'acqua';

  @override
  String get everyLabel => 'Ogni';

  @override
  String get hourUnitLabel => 'ore)';

  @override
  String get fromLabel => 'da';

  @override
  String get setWaterStartTimeLabel => 'Imposta l\'ora di inizio dell\'acqua';

  @override
  String get breakfastReminderTitle => 'Promemoria per la colazione';

  @override
  String get lunchReminderTitle => 'Promemoria del pranzo';

  @override
  String get dinnerReminderTitle => 'Promemoria per la cena';

  @override
  String get snackReminderTitle => 'Promemoria spuntino';

  @override
  String get goalTrackingAlertsTitle =>
      'Avvisi di monitoraggio degli obiettivi';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Avvisi di calorie vicine/superate e obiettivi macro';

  @override
  String get stepsExerciseReminderTitle => 'Promemoria passaggi/esercizi';

  @override
  String get dailyAtLabel => 'Tutti i giorni alle';

  @override
  String get setActivityReminderTimeLabel =>
      'Imposta l\'ora del promemoria dell\'attività';

  @override
  String get intervalLabel => 'Intervallo:';

  @override
  String get setTimeLabel => 'Imposta l\'ora';

  @override
  String get languageNameEnglish => 'Inglese';

  @override
  String get languageNameSpanish => 'Spagnolo';

  @override
  String get languageNamePortuguese => 'Portoghese';

  @override
  String get languageNameFrench => 'Francese';

  @override
  String get languageNameGerman => 'Tedesco';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Iniziare è la parte più difficile. Sei pronto per questo!';

  @override
  String get progressMessageKeepPushing =>
      'Stai facendo progressi. Ora è il momento di continuare a spingere!';

  @override
  String get progressMessagePayingOff =>
      'La tua dedizione sta dando i suoi frutti. Continuare!';

  @override
  String get progressMessageFinalStretch => 'È il tratto finale. Spingiti!';

  @override
  String get progressMessageCongrats => 'Ce l\'hai fatta! Congratulazioni!';

  @override
  String dayStreakWithCount(Object count) {
    return 'Serie di $count giorni';
  }

  @override
  String get streakLostTitle => 'Serie interrotta';

  @override
  String get streakActiveSubtitle =>
      'Sei in fiamme! Continua a registrare per mantenere lo slancio.';

  @override
  String get streakLostSubtitle =>
      'Non arrenderti. Registra i tuoi pasti oggi per rimetterti in carreggiata.';

  @override
  String get dayInitialSun => 'D';

  @override
  String get dayInitialMon => 'L';

  @override
  String get dayInitialTue => 'M';

  @override
  String get dayInitialWed => 'M';

  @override
  String get dayInitialThu => 'G';

  @override
  String get dayInitialFri => 'V';

  @override
  String get dayInitialSat => 'S';

  @override
  String get alertCalorieGoalExceededTitle => 'Obiettivo calorie superato';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'Hai $over kcal sopra il tuo obiettivo giornaliero.';
  }

  @override
  String get alertNearCalorieLimitTitle => 'Sei vicino al limite calorico';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Oggi restano solo $remaining kcal. Pianifica attentamente il tuo prossimo pasto.';
  }

  @override
  String get alertProteinBehindTitle => 'Il target proteico è indietro';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'Hai ancora bisogno di circa $missing g di proteine ​​per raggiungere l\'obiettivo di oggi.';
  }

  @override
  String get alertCarbTargetExceededTitle => 'Obiettivo carboidrati superato';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'I carboidrati sono $over g superiori al target.';
  }

  @override
  String get alertFatTargetExceededTitle => 'Obiettivo grasso superato';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'Il grasso è $over g superiore al target.';
  }

  @override
  String get smartNutritionTipTitle => 'Suggerimento nutrizionale intelligente';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal rimaste';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal oltre';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g di proteine ​​rimanenti';
  }

  @override
  String get smartNutritionProteinGoalReached => 'obiettivo proteico raggiunto';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage e $proteinMessage. Registra il tuo prossimo pasto per rimanere aggiornato.';
  }

  @override
  String get notificationStepsExerciseTitle =>
      'Passaggi e promemoria degli esercizi';

  @override
  String get notificationStepsExerciseBody =>
      'Registra i tuoi passi o il tuo allenamento per completare l\'obiettivo di attività di oggi.';

  @override
  String get notificationBreakfastTitle => 'Promemoria per la colazione';

  @override
  String get notificationBreakfastBody =>
      'Registra la colazione per iniziare presto il monitoraggio delle calorie e dei macronutrienti.';

  @override
  String get notificationLunchTitle => 'Promemoria del pranzo';

  @override
  String get notificationLunchBody =>
      'Ora di pranzo. Aggiungi il tuo pasto per mantenere precisi i tuoi progressi giornalieri.';

  @override
  String get notificationDinnerTitle => 'Promemoria per la cena';

  @override
  String get notificationDinnerBody =>
      'Registra la cena e chiudi la giornata con i dati nutrizionali completi.';

  @override
  String get notificationSnackTitle => 'Promemoria spuntino';

  @override
  String get notificationSnackBody =>
      'Aggiungi il tuo spuntino in modo che calorie e macronutrienti rimangano in linea con i tuoi obiettivi.';

  @override
  String get smartNutritionDailyTitle => 'Controllo nutrizionale intelligente';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Obiettivo $calories kcal, proteine ​​${protein}g, carboidrati ${carbs}g, grassi ${fats}g. Registra il tuo ultimo pasto per mantenere il tuo piano accurato.';
  }

  @override
  String get notificationWaterTitle => 'Promemoria dell\'acqua';

  @override
  String get notificationWaterBody =>
      'Controllo dell\'idratazione. Registra un bicchiere d\'acqua in Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Registra il tuo cibo';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Calorie oggi';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories / $goal kcal';
  }
}
