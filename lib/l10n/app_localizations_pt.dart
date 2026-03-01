// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Início';

  @override
  String get progressTab => 'Progresso';

  @override
  String get settingsTab => 'Configurações';

  @override
  String get language => 'Linguagem';

  @override
  String get welcomeMessage => 'Bem-vindo ao Cal AI';

  @override
  String get trackMessage =>
      'Acompanhe de forma mais inteligente. Coma melhor.';

  @override
  String get getStarted => 'Comece';

  @override
  String get alreadyAccount => 'Já tem uma conta?';

  @override
  String get signIn => 'Entrar';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get personalDetails => 'Detalhes pessoais';

  @override
  String get adjustMacronutrients => 'Ajustar Macronutrientes';

  @override
  String get weightHistory => 'Histórico de peso';

  @override
  String get homeWidget => 'Widget inicial';

  @override
  String get chooseHomeWidgets => 'Escolha os widgets iniciais';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Toque nas opções para adicionar ou remover widgets.';

  @override
  String get updatingWidgetSelection => 'Atualizando a seleção de widgets...';

  @override
  String get requestingWidgetPermission => 'Solicitando permissão do widget...';

  @override
  String get widget1 => 'Widget nº 1';

  @override
  String get widget2 => 'Widget nº 2';

  @override
  String get widget3 => 'Widget nº 3';

  @override
  String get calorieTrackerWidget => 'Rastreador de calorias';

  @override
  String get nutritionTrackerWidget => 'Rastreador de Nutrição';

  @override
  String get streakTrackerWidget => 'Rastreador de sequências';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName removido da seleção.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'Para remover $widgetName, remova-o da tela inicial. A seleção é sincronizada automaticamente.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'Para adicionar $widgetName, mantenha pressionada a tela inicial, toque em + e selecione Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return 'Widget $widgetName adicionado.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Permissão necessária para adicionar $widgetName. Abrimos as configurações para você.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'Não foi possível abrir as configurações de permissão. Ative as permissões manualmente para adicionar $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen => 'Nenhum widget na tela inicial';

  @override
  String selectedWidgets(Object widgets) {
    return 'Selecionado: $widgets';
  }

  @override
  String get backupData => 'Faça backup dos seus dados';

  @override
  String get signInToSync =>
      'Faça login para sincronizar seu progresso e metas';

  @override
  String get accountSuccessfullyBackedUp => 'Backup da conta com sucesso!';

  @override
  String get failedToLinkAccount => 'Falha ao vincular a conta.';

  @override
  String get googleAccountAlreadyLinked =>
      'Esta conta do Google já está vinculada a outro perfil do Cal AI.';

  @override
  String get caloriesLabel => 'Calorias';

  @override
  String get eatenLabel => 'comido';

  @override
  String get leftLabel => 'esquerda';

  @override
  String get proteinLabel => 'Proteína';

  @override
  String get carbsLabel => 'Carboidratos';

  @override
  String get fatsLabel => 'Gorduras';

  @override
  String get fiberLabel => 'Fibra';

  @override
  String get sugarLabel => 'Açúcar';

  @override
  String get sodiumLabel => 'Sódio';

  @override
  String get stepsLabel => 'Passos';

  @override
  String get stepsTodayLabel => 'Passos hoje';

  @override
  String get caloriesBurnedLabel => 'Calorias queimadas';

  @override
  String get stepTrackingActive => 'Acompanhamento de passos ativo!';

  @override
  String get waterLabel => 'Água';

  @override
  String get servingSizeLabel => 'Tamanho da porção';

  @override
  String get waterSettingsTitle => 'Configurações de água';

  @override
  String get hydrationQuestion =>
      'Quanta água você precisa para se manter hidratado?';

  @override
  String get hydrationInfo =>
      'As necessidades de cada pessoa são um pouco diferentes, mas recomendamos consumir pelo menos 8 xícaras de água por dia.';

  @override
  String get healthScoreTitle => 'Pontuação de saúde';

  @override
  String get healthSummaryNoData =>
      'Nenhum dado registrado para hoje. Comece a monitorar suas refeições para ver suas percepções de saúde!';

  @override
  String get healthSummaryLowIntake =>
      'Sua ingestão é bastante baixa. Concentre-se em atingir suas metas de calorias e proteínas para manter a energia e os músculos.';

  @override
  String get healthSummaryLowProtein =>
      'Carboidratos e gordura estão no caminho certo, mas você tem pouca proteína. Aumentar a proteína pode ajudar na retenção muscular.';

  @override
  String get healthSummaryGreat =>
      'Ótimo trabalho! Sua nutrição está bem balanceada hoje.';

  @override
  String get recentlyLoggedTitle => 'Registrado recentemente';

  @override
  String errorLoadingLogs(Object error) {
    return 'Erro ao carregar registros: $error';
  }

  @override
  String get deleteLabel => 'Excluir';

  @override
  String get tapToAddFirstEntry =>
      'Toque em + para adicionar sua primeira entrada';

  @override
  String unableToLoadProgress(Object error) {
    return 'Não foi possível carregar o progresso: $error';
  }

  @override
  String get myWeightTitle => 'Meu peso';

  @override
  String goalWithValue(Object value) {
    return 'Meta $value';
  }

  @override
  String get noGoalSet => 'Nenhuma meta definida';

  @override
  String get logWeightCta => 'Peso do registro';

  @override
  String get dayStreakTitle => 'Sequência do dia';

  @override
  String get progressPhotosTitle => 'Fotos de progresso';

  @override
  String get progressPhotoPrompt =>
      'Quer adicionar uma foto para acompanhar seu progresso?';

  @override
  String get uploadPhotoCta => 'Carregar uma foto';

  @override
  String get goalProgressTitle => 'Progresso da meta';

  @override
  String get ofGoalLabel => 'do gol';

  @override
  String get logoutLabel => 'Sair';

  @override
  String get logoutTitle => 'Sair';

  @override
  String get logoutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get preferencesLabel => 'Preferências';

  @override
  String get appearanceLabel => 'Aparência';

  @override
  String get appearanceDescription =>
      'Escolha a aparência clara, escura ou do sistema';

  @override
  String get lightLabel => 'Luz';

  @override
  String get darkLabel => 'Escuro';

  @override
  String get automaticLabel => 'Automático';

  @override
  String get addBurnedCaloriesLabel => 'Adicione calorias queimadas';

  @override
  String get addBurnedCaloriesDescription =>
      'Adicione calorias queimadas à meta diária';

  @override
  String get rolloverCaloriesLabel => 'Calorias acumuladas';

  @override
  String get rolloverCaloriesDescription =>
      'Adicione até 200 calorias restantes à meta de hoje';

  @override
  String get measurementUnitLabel => 'Unidade de medida';

  @override
  String get measurementUnitDescription =>
      'Todos os valores serão convertidos para imperial (atualmente em métricas)';

  @override
  String get inviteFriendsLabel => 'Convide amigos';

  @override
  String get defaultUserName => 'usuário';

  @override
  String get enterYourNameLabel => 'Digite seu nome';

  @override
  String yearsOldLabel(Object years) {
    return '$years anos';
  }

  @override
  String get termsAndConditionsLabel => 'Termos e Condições';

  @override
  String get privacyPolicyLabel => 'política de Privacidade';

  @override
  String get supportEmailLabel => 'E-mail de suporte';

  @override
  String get featureRequestLabel => 'Solicitação de recurso';

  @override
  String get deleteAccountQuestion => 'Excluir conta?';

  @override
  String get deleteAccountTitle => 'Excluir conta';

  @override
  String get deleteAccountMessage =>
      'Você tem certeza absoluta? Isso excluirá permanentemente seu histórico do Cal AI, registros de peso e metas personalizadas. Esta ação não pode ser desfeita.';

  @override
  String get deletePermanentlyLabel => 'Excluir permanentemente';

  @override
  String get onboardingChooseGenderTitle => 'Escolha seu gênero';

  @override
  String get onboardingChooseGenderSubtitle =>
      'Isso será usado para calibrar seu plano personalizado.';

  @override
  String get genderFemale => 'Fêmea';

  @override
  String get genderMale => 'Macho';

  @override
  String get genderOther => 'Outro';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      'Quantos treinos você faz por semana?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'Isso será usado para calibrar seu plano personalizado.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Treinos de vez em quando';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle => 'Alguns treinos por semana';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Atleta dedicado';

  @override
  String get onboardingHearAboutUsTitle => 'Onde você ouviu falar de nós?';

  @override
  String get sourceTikTok => 'Tik Tok';

  @override
  String get sourceYouTube => 'YouTube';

  @override
  String get sourceGoogle => 'Google';

  @override
  String get sourcePlayStore => 'Loja de jogos';

  @override
  String get sourceFacebook => 'Facebook';

  @override
  String get sourceFriendFamily => 'Amigo ou família';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Outro';

  @override
  String get yourBmiTitle => 'Seu IMC';

  @override
  String get yourWeightIsLabel => 'Seu peso é';

  @override
  String get bmiUnderweightLabel => 'Abaixo do peso';

  @override
  String get bmiHealthyLabel => 'Saudável';

  @override
  String get bmiOverweightLabel => 'Sobrepeso';

  @override
  String get bmiObeseLabel => 'Obeso';

  @override
  String get calorieTrackingMadeEasy => 'Rastreamento de calorias facilitado';

  @override
  String get onboardingStep1Title => 'Acompanhe suas refeições';

  @override
  String get onboardingStep1Description =>
      'Registre suas refeições facilmente e acompanhe sua nutrição.';

  @override
  String get signInWithGoogle => 'Faça login com o Google';

  @override
  String get signInWithEmail => 'Faça login com e-mail';

  @override
  String signInFailed(Object error) {
    return 'Falha no login: $error';
  }

  @override
  String get continueLabel => 'Continuar';

  @override
  String get skipLabel => 'Pular';

  @override
  String get noLabel => 'Não';

  @override
  String get yesLabel => 'Sim';

  @override
  String get submitLabel => 'Enviar';

  @override
  String get referralCodeLabel => 'Código de referência';

  @override
  String get heightLabel => 'Altura';

  @override
  String get weightLabel => 'Peso';

  @override
  String get imperialLabel => 'Imperial';

  @override
  String get metricLabel => 'Métrica';

  @override
  String get month1Label => 'Mês 1';

  @override
  String get month6Label => 'Mês 6';

  @override
  String get traditionalDietLabel => 'Dieta Tradicional';

  @override
  String get weightChartSummary =>
      '80% dos usuários do Cal AI mantêm a perda de peso mesmo 6 meses depois';

  @override
  String get comparisonWithoutCalAi => 'Sem\\nCal AI';

  @override
  String get comparisonWithCalAi => 'Com\\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI torna tudo mais fácil e seguro';

  @override
  String get comparisonBottomLine2 => 'você é responsável';

  @override
  String get speedSlowSteady => 'Lento e constante';

  @override
  String get speedRecommended => 'Recomendado';

  @override
  String get speedAggressiveWarning =>
      'Você pode se sentir muito cansado e desenvolver pele flácida';

  @override
  String get subscriptionHeadline =>
      'Desbloqueie o CalAI para alcançar\\nseus objetivos com mais rapidez.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Apenas PHP $yearlyPrice por ano (PHP $monthlyPrice/mês)';
  }

  @override
  String get goalGainWeight => 'Ganhar peso';

  @override
  String get goalLoseWeight => 'Perder peso';

  @override
  String get goalMaintainWeight => 'Manter o peso';

  @override
  String editGoalTitle(Object title) {
    return 'Editar meta $title';
  }

  @override
  String get revertLabel => 'Reverter';

  @override
  String get doneLabel => 'Feito';

  @override
  String get dashboardShouldGainWeight => 'ganho';

  @override
  String get dashboardShouldLoseWeight => 'perder';

  @override
  String get dashboardShouldMaintainWeight => 'manter';

  @override
  String get dashboardCongratsPlanReady =>
      'Parabéns\\nseu plano personalizado está pronto!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'Você deve $action:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit por $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Recomendação diária';

  @override
  String get dashboardEditAnytime => 'Você pode editar isso a qualquer momento';

  @override
  String get dashboardHowToReachGoals => 'Como alcançar seus objetivos:';

  @override
  String get dashboardReachGoalLifeScore =>
      'Obtenha sua pontuação de vida semanal e melhore sua rotina.';

  @override
  String get dashboardReachGoalTrackFood => 'Rastreie sua comida';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Siga sua recomendação diária de calorias';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Equilibre seus carboidratos, proteínas e gorduras';

  @override
  String get dashboardPlanSourcesTitle =>
      'Planeje com base nas seguintes fontes, entre outros estudos médicos revisados ​​por pares:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Taxa metabólica basal';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Contagem de calorias - Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'Sociedade Internacional de Nutrição Esportiva';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'Institutos Nacionais de Saúde';

  @override
  String get factorsNetCarbsMass => 'Carboidratos líquidos / massa';

  @override
  String get factorsNetCarbDensity => 'Densidade líquida de carboidratos';

  @override
  String get factorsSodiumMass => 'Sódio/massa';

  @override
  String get factorsSodiumDensity => 'Densidade de sódio';

  @override
  String get factorsSugarMass => 'Açúcar/massa';

  @override
  String get factorsSugarDensity => 'Densidade de açúcar';

  @override
  String get factorsProcessedScore => 'Pontuação processada';

  @override
  String get factorsIngredientQuality => 'Qualidade dos ingredientes';

  @override
  String get factorsProcessedScoreDescription =>
      'A pontuação processada leva em consideração corantes, nitratos, óleos de sementes, aromatizantes/adoçantes artificiais e outros fatores.';

  @override
  String get healthScoreExplanationIntro =>
      'Nossa pontuação de saúde é uma fórmula complexa que leva em consideração vários fatores, considerando uma infinidade de alimentos comuns.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'Abaixo estão os fatores que levamos em consideração ao calcular a pontuação de saúde:';

  @override
  String get netCarbsLabel => 'Carboidratos líquidos';

  @override
  String get howDoesItWork => 'Como funciona?';

  @override
  String get goodLabel => 'Bom';

  @override
  String get badLabel => 'Ruim';

  @override
  String get dailyRecommendationFor => 'Recomendação diária para';

  @override
  String get loadingCustomizingHealthPlan => 'Personalizando plano de saúde...';

  @override
  String get loadingApplyingBmrFormula => 'Aplicando a fórmula BMR...';

  @override
  String get loadingEstimatingMetabolicAge =>
      'Estimando sua idade metabólica...';

  @override
  String get loadingFinalizingResults => 'Finalizando resultados...';

  @override
  String get loadingSetupForYou => 'Estamos configurando tudo\\npara você';

  @override
  String get step4TriedOtherCalorieApps =>
      'Você já experimentou outros aplicativos de rastreamento de calorias?';

  @override
  String get step5CalAiLongTermResults =>
      'Cal AI cria resultados de longo prazo';

  @override
  String get step6HeightWeightTitle => 'Altura e Peso';

  @override
  String get step6HeightWeightSubtitle =>
      'Isso será levado em consideração no cálculo de suas metas nutricionais diárias.';

  @override
  String get step7WhenWereYouBorn => 'Quando você nasceu?';

  @override
  String get step8GoalQuestionTitle => 'Qual é o seu objetivo?';

  @override
  String get step8GoalQuestionSubtitle =>
      'Isso nos ajuda a gerar um plano para sua ingestão de calorias.';

  @override
  String get step9SpecificDietQuestion => 'Você segue uma dieta específica?';

  @override
  String get step9DietClassic => 'Clássico';

  @override
  String get step9DietPescatarian => 'Pescatariano';

  @override
  String get step9DietVegetarian => 'Vegetariano';

  @override
  String get step9DietVegan => 'Vegano';

  @override
  String get step91DesiredWeightQuestion => 'Qual é o seu peso desejado?';

  @override
  String get step92GoalActionGaining => 'Ganhando';

  @override
  String get step92GoalActionLosing => 'Perdendo';

  @override
  String get step92RealisticTargetSuffix =>
      'é uma meta realista. Não é nada difícil!';

  @override
  String get step92SocialProof =>
      '90% dos usuários dizem que a mudança é óbvia após usar Cal AI e não é fácil de se recuperar.';

  @override
  String get step93GoalVerbGain => 'Ganho';

  @override
  String get step93GoalVerbLose => 'Perder';

  @override
  String get step93SpeedQuestionTitle =>
      'Com que rapidez você deseja alcançar seu objetivo?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return 'Velocidade de peso $action por semana';
  }

  @override
  String get step94ComparisonTitle =>
      'Perca o dobro de peso com Cal AI do que sozinho';

  @override
  String get step95ObstaclesTitle =>
      'O que está impedindo você de alcançar seus objetivos?';

  @override
  String get step10AccomplishTitle => 'O que você gostaria de realizar?';

  @override
  String get step10OptionHealthier => 'Coma e viva de forma mais saudável';

  @override
  String get step10OptionEnergyMood => 'Aumente minha energia e humor';

  @override
  String get step10OptionConsistency => 'Mantenha-se motivado e consistente';

  @override
  String get step10OptionBodyConfidence => 'Sinta-se melhor com meu corpo';

  @override
  String get step11PotentialTitle =>
      'Você tem um grande potencial para esmagar seu objetivo';

  @override
  String get step12ThankYouTitle => 'Obrigado por\\nconfiar em nós!';

  @override
  String get step12PersonalizeSubtitle =>
      'Agora vamos personalizar o Cal AI para você...';

  @override
  String get step12PrivacyCardTitle =>
      'Sua privacidade e segurança são importantes para nós.';

  @override
  String get step12PrivacyCardBody =>
      'Prometemos sempre manter suas\\ninformações pessoais privadas e seguras.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Alcance seus objetivos com notificações';

  @override
  String get step13NotificationPrompt =>
      'Cal AI gostaria de enviar notificações para você';

  @override
  String get allowLabel => 'Permitir';

  @override
  String get dontAllowLabel => 'Não permita';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      'Adicionar calorias queimadas à sua meta diária?';

  @override
  String get step15RolloverQuestion =>
      'Acumular calorias extras para o dia seguinte?';

  @override
  String get step15RolloverUpTo => 'Rolar até';

  @override
  String get step15RolloverCap => '200 calorias';

  @override
  String get step16ReferralTitle => 'Insira o código de referência (opcional)';

  @override
  String get step16ReferralSubtitle => 'Você pode pular esta etapa';

  @override
  String get step17AllDone => 'Tudo pronto!';

  @override
  String get step17GeneratePlanTitle =>
      'É hora de gerar seu plano personalizado!';

  @override
  String get step18CalculationError =>
      'Não foi possível calcular o plano. Por favor, verifique sua conexão.';

  @override
  String get step18TryAgain => 'Tente novamente';

  @override
  String get step19CreateAccountTitle => 'Crie uma conta';

  @override
  String get authInvalidEmailMessage =>
      'Por favor insira um endereço de e-mail válido';

  @override
  String get authCheckYourEmailTitle => 'Verifique seu e-mail';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'Enviamos um link de login para $email';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Erro: $error';
  }

  @override
  String get authWhatsYourEmail => 'Qual é o seu e-mail?';

  @override
  String get authPasswordlessHint =>
      'Enviaremos um link para você fazer login sem senha.';

  @override
  String get emailExampleHint => 'nome@exemplo.com';

  @override
  String get notSetLabel => 'Não definido';

  @override
  String get goalWeightLabel => 'Meta de peso';

  @override
  String get changeGoalLabel => 'Alterar meta';

  @override
  String get currentWeightLabel => 'Peso atual';

  @override
  String get dateOfBirthLabel => 'Data de nascimento';

  @override
  String get genderLabel => 'Gênero';

  @override
  String get dailyStepGoalLabel => 'Meta diária de passos';

  @override
  String get stepGoalLabel => 'Meta de passos';

  @override
  String get setHeightTitle => 'Definir altura';

  @override
  String get setGenderTitle => 'Definir gênero';

  @override
  String get setBirthdayTitle => 'Definir aniversário';

  @override
  String get setWeightTitle => 'Definir peso';

  @override
  String get editNameTitle => 'Editar nome';

  @override
  String get calorieGoalLabel => 'Meta de calorias';

  @override
  String get proteinGoalLabel => 'Meta de proteína';

  @override
  String get carbGoalLabel => 'Meta de carboidratos';

  @override
  String get fatGoalLabel => 'Gol gordo';

  @override
  String get sugarLimitLabel => 'Limite de açúcar';

  @override
  String get fiberGoalLabel => 'Meta de fibra';

  @override
  String get sodiumLimitLabel => 'Limite de sódio';

  @override
  String get hideMicronutrientsLabel => 'Ocultar micronutrientes';

  @override
  String get viewMicronutrientsLabel => 'Ver micronutrientes';

  @override
  String get autoGenerateGoalsLabel => 'Gerar metas automaticamente';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Falha ao gerar metas: $error';
  }

  @override
  String get calculatingCustomGoals =>
      'Calculando suas metas personalizadas...';

  @override
  String get logExerciseLabel => 'Exercício de registro';

  @override
  String get savedFoodsLabel => 'Alimentos salvos';

  @override
  String get foodDatabaseLabel => 'Banco de dados de alimentos';

  @override
  String get scanFoodLabel => 'Digitalizar alimentos';

  @override
  String get exerciseTitle => 'Exercício';

  @override
  String get runTitle => 'Correr';

  @override
  String get weightLiftingTitle => 'Levantamento de peso';

  @override
  String get describeTitle => 'Descrever';

  @override
  String get runDescription => 'Correr, correr, correr, etc.';

  @override
  String get weightLiftingDescription => 'Máquinas, pesos livres, etc.';

  @override
  String get describeWorkoutDescription => 'Escreva seu treino em texto';

  @override
  String get setIntensityLabel => 'Definir intensidade';

  @override
  String get durationLabel => 'Duração';

  @override
  String get minutesShortLabel => 'minutos';

  @override
  String get minutesAbbrevSuffix => 'eu';

  @override
  String get addLabel => 'Adicionar';

  @override
  String get intensityLabel => 'Intensidade';

  @override
  String get intensityHighLabel => 'Alto';

  @override
  String get intensityMediumLabel => 'Médio';

  @override
  String get intensityLowLabel => 'Baixo';

  @override
  String get runIntensityHighDescription =>
      'Corrida - 14 mph (4 minutos milhas)';

  @override
  String get runIntensityMediumDescription =>
      'Corrida - 6 mph (10 minutos milhas)';

  @override
  String get runIntensityLowDescription =>
      'Caminhada relaxante - 3 mph (20 minutos milhas)';

  @override
  String get weightIntensityHighDescription =>
      'Treinando até o fracasso, respirando pesadamente';

  @override
  String get weightIntensityMediumDescription =>
      'Suando muito, muitas repetições';

  @override
  String get weightIntensityLowDescription =>
      'Sem suar a camisa, dando pouco esforço';

  @override
  String get exerciseLoggedSuccessfully => 'Exercício registrado com sucesso!';

  @override
  String get exerciseParsedAndLogged => 'Exercício analisado e registrado!';

  @override
  String get describeExerciseTitle => 'Descrever o exercício';

  @override
  String get whatDidYouDoHint => 'O que você fez?';

  @override
  String get describeExerciseExample =>
      'Exemplo: Caminhada ao ar livre por 5 horas, senti-me exausto';

  @override
  String get servingLabel => 'Servindo';

  @override
  String get productNotFoundMessage => 'Produto não encontrado.';

  @override
  String couldNotIdentify(Object text) {
    return 'Não foi possível identificar \"$text\".';
  }

  @override
  String get identifyingFoodMessage => 'Identificando alimentos...';

  @override
  String get loggedSuccessfullyMessage => 'Registrado com sucesso!';

  @override
  String get barcodeScannerLabel => 'Leitor de código de barras';

  @override
  String get barcodeLabel => 'Código de barras';

  @override
  String get foodLabel => 'Rótulo de alimentos';

  @override
  String get galleryLabel => 'Galeria';

  @override
  String get bestScanningPracticesTitle => 'Melhores práticas de digitalização';

  @override
  String get generalTipsTitle => 'Dicas gerais:';

  @override
  String get scanTipKeepFoodInside =>
      'Mantenha a comida dentro das linhas de varredura';

  @override
  String get scanTipHoldPhoneStill =>
      'Mantenha o telefone imóvel para que a imagem não fique desfocada';

  @override
  String get scanTipAvoidObscureAngles => 'Não tire fotos em ângulos obscuros';

  @override
  String get scanNowLabel => 'Digitalize agora';

  @override
  String get allTabLabel => 'Todos';

  @override
  String get myMealsTabLabel => 'Minhas refeições';

  @override
  String get myFoodsTabLabel => 'Minhas comidas';

  @override
  String get savedScansTabLabel => 'Verificações salvas';

  @override
  String get logEmptyFoodLabel => 'Registrar comida vazia';

  @override
  String get searchResultsLabel => 'Resultados da pesquisa';

  @override
  String get suggestionsLabel => 'Sugestões';

  @override
  String get noItemsFoundLabel => 'Nenhum item encontrado.';

  @override
  String get noSuggestionsAvailableLabel => 'Nenhuma sugestão disponível';

  @override
  String get noSavedScansYetLabel => 'Nenhuma verificação salva ainda';

  @override
  String get describeWhatYouAteHint => 'Descreva o que você comeu';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return 'Adicionado $foodName a $dateId';
  }

  @override
  String get failedToAddFood => 'Falha ao adicionar comida. Tente novamente.';

  @override
  String get invalidFoodIdMessage => 'ID de alimentação inválido';

  @override
  String get foodNotFoundMessage => 'Comida não encontrada';

  @override
  String get couldNotLoadFoodDetails =>
      'Não foi possível carregar os detalhes dos alimentos';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Padrão';

  @override
  String get selectedFoodTitle => 'Comida selecionada';

  @override
  String get measurementLabel => 'Medição';

  @override
  String get otherNutritionFactsLabel => 'Outras informações nutricionais';

  @override
  String get numberOfServingsLabel => 'Número de porções';

  @override
  String get logLabel => 'Registro';

  @override
  String get nutrientsTitle => 'Nutrientes';

  @override
  String get totalNutritionLabel => 'Nutrição total';

  @override
  String get enterFoodNameHint => 'Digite o nome do alimento';

  @override
  String get kcalLabel => 'calorias';

  @override
  String get statsLabel => 'Estatísticas';

  @override
  String get intensityModerateLabel => 'Moderado';

  @override
  String get thisWeekLabel => 'Essa semana';

  @override
  String get lastWeekLabel => 'Semana passada';

  @override
  String get twoWeeksAgoLabel => '2 semanas atrás';

  @override
  String get threeWeeksAgoLabel => '3 semanas atrás';

  @override
  String get totalCaloriesLabel => 'Calorias totais';

  @override
  String get calsLabel => 'chamadas';

  @override
  String get dayShortSun => 'Dom';

  @override
  String get dayShortMon => 'seg';

  @override
  String get dayShortTue => 'ter';

  @override
  String get dayShortWed => 'Qua';

  @override
  String get dayShortThu => 'qui';

  @override
  String get dayShortFri => 'sex';

  @override
  String get dayShortSat => 'Sáb';

  @override
  String get ninetyDaysLabel => '90 dias';

  @override
  String get sixMonthsLabel => '6 meses';

  @override
  String get oneYearLabel => '1 ano';

  @override
  String get allTimeLabel => 'Todo o tempo';

  @override
  String get waitingForFirstLogLabel => 'Aguardando seu primeiro registro...';

  @override
  String get editGoalPickerTitle => 'Editar seletor de metas';

  @override
  String get bmiDisclaimerTitle => 'Isenção de responsabilidade';

  @override
  String get bmiDisclaimerBody =>
      'Tal como acontece com a maioria das medidas de saúde, o IMC não é um teste perfeito. Por exemplo, os resultados podem ser prejudicados pela gravidez ou pelo aumento da massa muscular, e pode não ser uma boa medida de saúde para crianças ou idosos.';

  @override
  String get bmiWhyItMattersTitle => 'Então, por que o IMC é importante?';

  @override
  String get bmiWhyItMattersBody =>
      'Em geral, quanto maior o seu IMC, maior o risco de desenvolver uma série de doenças relacionadas ao excesso de peso, incluindo:\\n� diabetes\\n� artrite\\n� doença hepática\\n� vários tipos de câncer (como os de mama, cólon e próstata)\\n� pressão alta (hipertensão)\\n� colesterol alto\\n� apneia do sono';

  @override
  String get noWeightHistoryYet => 'Nenhum histórico de peso registrado ainda.';

  @override
  String get overLabel => 'sobre';

  @override
  String get dailyBreakdownTitle => 'Repartição Diária';

  @override
  String get editDailyGoalsLabel => 'Editar metas diárias';

  @override
  String get errorLoadingData => 'Erro ao carregar dados';

  @override
  String get gramsLabel => 'gramas';

  @override
  String get healthStatusNotEvaluated => 'Não avaliado';

  @override
  String get healthStatusCriticallyLow => 'Criticamente baixo';

  @override
  String get healthStatusNeedsImprovement => 'Precisa de melhorias';

  @override
  String get healthStatusFairProgress => 'Progresso justo';

  @override
  String get healthStatusGoodHealth => 'Boa saúde';

  @override
  String get healthStatusExcellentHealth => 'Excelente saúde';

  @override
  String get remindersTitle => 'Lembretes';

  @override
  String get failedLoadReminderSettings =>
      'Falha ao carregar as configurações do lembrete.';

  @override
  String get smartNutritionRemindersTitle =>
      'Lembretes nutricionais inteligentes';

  @override
  String get dailyReminderAtLabel => 'Lembrete diário em';

  @override
  String get setSmartNutritionTimeLabel =>
      'Defina um horário de nutrição inteligente';

  @override
  String get waterRemindersTitle => 'Lembretes de água';

  @override
  String get everyLabel => 'Todo';

  @override
  String get hourUnitLabel => 'horas)';

  @override
  String get fromLabel => 'de';

  @override
  String get setWaterStartTimeLabel => 'Definir hora de início da água';

  @override
  String get breakfastReminderTitle => 'Lembrete de café da manhã';

  @override
  String get lunchReminderTitle => 'Lembrete de almoço';

  @override
  String get dinnerReminderTitle => 'Lembrete de jantar';

  @override
  String get snackReminderTitle => 'Lembrete de lanche';

  @override
  String get goalTrackingAlertsTitle => 'Alertas de rastreamento de metas';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Alertas de calorias próximas/excedidas e metas macro';

  @override
  String get stepsExerciseReminderTitle => 'Passos/lembrete de exercício';

  @override
  String get dailyAtLabel => 'Diariamente às';

  @override
  String get setActivityReminderTimeLabel =>
      'Defina o horário do lembrete de atividade';

  @override
  String get intervalLabel => 'Intervalo:';

  @override
  String get setTimeLabel => 'Definir hora';

  @override
  String get languageNameEnglish => 'Inglês';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNamePortuguese => 'Português';

  @override
  String get languageNameFrench => 'Francês';

  @override
  String get languageNameGerman => 'Alemão';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Começar é a parte mais difícil. Você está pronto para isso!';

  @override
  String get progressMessageKeepPushing =>
      'Você está progredindo. Agora é a hora de continuar pressionando!';

  @override
  String get progressMessagePayingOff =>
      'Sua dedicação está dando resultado. Continue!';

  @override
  String get progressMessageFinalStretch => 'É a reta final. Empurre-se!';

  @override
  String get progressMessageCongrats => 'Você conseguiu! Parabéns!';

  @override
  String dayStreakWithCount(Object count) {
    return 'Série de dias $count';
  }

  @override
  String get streakLostTitle => 'Sequência perdida';

  @override
  String get streakActiveSubtitle =>
      'Você está com tudo! Continue registrando para manter o ritmo.';

  @override
  String get streakLostSubtitle =>
      'Não desista. Registre suas refeições hoje para voltar aos trilhos.';

  @override
  String get dayInitialSun => 'S';

  @override
  String get dayInitialMon => 'M';

  @override
  String get dayInitialTue => 'T';

  @override
  String get dayInitialWed => 'C';

  @override
  String get dayInitialThu => 'T';

  @override
  String get dayInitialFri => 'F';

  @override
  String get dayInitialSat => 'S';

  @override
  String get alertCalorieGoalExceededTitle => 'Meta de calorias excedida';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'Você está $over kcal acima de sua meta diária.';
  }

  @override
  String get alertNearCalorieLimitTitle =>
      'Você está perto do seu limite de calorias';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Restam apenas $remaining kcal hoje. Planeje sua próxima refeição com cuidado.';
  }

  @override
  String get alertProteinBehindTitle => 'A meta de proteína está atrasada';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'Você ainda precisa de cerca de $missing g de proteína para atingir a meta de hoje.';
  }

  @override
  String get alertCarbTargetExceededTitle => 'Meta de carboidratos excedida';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'Os carboidratos estão $over g acima da meta.';
  }

  @override
  String get alertFatTargetExceededTitle => 'Meta de gordura excedida';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'A gordura está $over g acima da meta.';
  }

  @override
  String get smartNutritionTipTitle => 'Dica de nutrição inteligente';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal restantes';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal acima';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g de proteína restante';
  }

  @override
  String get smartNutritionProteinGoalReached => 'meta de proteína alcançada';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage e $proteinMessage. Registre sua próxima refeição para se manter no caminho certo.';
  }

  @override
  String get notificationStepsExerciseTitle =>
      'Lembrete de passos e exercícios';

  @override
  String get notificationStepsExerciseBody =>
      'Registre seus passos ou treino para completar a meta de atividade de hoje.';

  @override
  String get notificationBreakfastTitle => 'Lembrete de café da manhã';

  @override
  String get notificationBreakfastBody =>
      'Registre o café da manhã para iniciar o monitoramento de calorias e macro mais cedo.';

  @override
  String get notificationLunchTitle => 'Lembrete de almoço';

  @override
  String get notificationLunchBody =>
      'Hora do almoço. Adicione sua refeição para manter seu progresso diário preciso.';

  @override
  String get notificationDinnerTitle => 'Lembrete de jantar';

  @override
  String get notificationDinnerBody =>
      'Registre o jantar e feche o dia com dados nutricionais completos.';

  @override
  String get notificationSnackTitle => 'Lembrete de lanche';

  @override
  String get notificationSnackBody =>
      'Adicione seu lanche para que calorias e macros fiquem alinhados com seus objetivos.';

  @override
  String get smartNutritionDailyTitle => 'Verificação nutricional inteligente';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Alvo $calories kcal, proteína ${protein}g, carboidratos ${carbs}g, gordura ${fats}g. Registre sua última refeição para manter seu plano preciso.';
  }

  @override
  String get notificationWaterTitle => 'Lembrete de água';

  @override
  String get notificationWaterBody =>
      'Verificação de hidratação. Registre um copo de água no Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Registre sua comida';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Calorias hoje';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories / $goal kcal';
  }
}
