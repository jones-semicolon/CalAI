// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cal AI';

  @override
  String get homeTab => 'Inicio';

  @override
  String get progressTab => 'Progreso';

  @override
  String get settingsTab => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get welcomeMessage => 'Bienvenido a Cal AI';

  @override
  String get trackMessage =>
      'Lleva el control de forma más inteligente. Come mejor.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get alreadyAccount => '¿Ya tienes una cuenta?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get personalDetails => 'Datos personales';

  @override
  String get adjustMacronutrients => 'Ajustar macronutrientes';

  @override
  String get weightHistory => 'Historial de peso';

  @override
  String get homeWidget => 'Widget de inicio';

  @override
  String get chooseHomeWidgets => 'Elige widgets de inicio';

  @override
  String get tapOptionsToAddRemoveWidgets =>
      'Toca las opciones para añadir o quitar widgets.';

  @override
  String get updatingWidgetSelection =>
      'Actualizando la selección de widgets...';

  @override
  String get requestingWidgetPermission =>
      'Solicitando permiso para widgets...';

  @override
  String get widget1 => 'Widget nº 1';

  @override
  String get widget2 => 'Widget nº 2';

  @override
  String get widget3 => 'Widget nº 3';

  @override
  String get calorieTrackerWidget => 'Widget de calorías';

  @override
  String get nutritionTrackerWidget => 'Widget de nutrición';

  @override
  String get streakTrackerWidget => 'Widget de racha';

  @override
  String removedFromSelection(Object widgetName) {
    return '$widgetName se eliminó de la selección.';
  }

  @override
  String removeFromHomeScreenInstruction(Object widgetName) {
    return 'Para quitar $widgetName, elimínalo de tu pantalla de inicio. La selección se sincroniza automáticamente.';
  }

  @override
  String addFromHomeScreenInstruction(Object widgetName) {
    return 'Para añadir $widgetName, mantén pulsada la pantalla de inicio, toca + y luego selecciona Cal AI.';
  }

  @override
  String widgetAdded(Object widgetName) {
    return 'Se añadió el widget $widgetName.';
  }

  @override
  String permissionNeededToAddWidget(Object widgetName) {
    return 'Se necesita permiso para añadir $widgetName. Abrimos Ajustes por ti.';
  }

  @override
  String couldNotOpenPermissionSettings(Object widgetName) {
    return 'No se pudo abrir la configuración de permisos. Activa los permisos manualmente para añadir $widgetName.';
  }

  @override
  String get noWidgetsOnHomeScreen => 'No hay widgets en la pantalla de inicio';

  @override
  String selectedWidgets(Object widgets) {
    return 'Seleccionados: $widgets';
  }

  @override
  String get backupData => 'Haga una copia de seguridad de sus datos';

  @override
  String get signInToSync =>
      'Inicia sesión para sincronizar tu progreso y metas';

  @override
  String get accountSuccessfullyBackedUp =>
      '¡Se realizó una copia de seguridad de la cuenta correctamente!';

  @override
  String get failedToLinkAccount => 'Error al vincular la cuenta.';

  @override
  String get googleAccountAlreadyLinked =>
      'Esta cuenta de Google ya est? vinculada a otro perfil de Cal AI.';

  @override
  String get caloriesLabel => 'Calorías';

  @override
  String get eatenLabel => 'comido';

  @override
  String get leftLabel => 'izquierda';

  @override
  String get proteinLabel => 'Proteína';

  @override
  String get carbsLabel => 'Carbohidratos';

  @override
  String get fatsLabel => 'Grasas';

  @override
  String get fiberLabel => 'Fibra';

  @override
  String get sugarLabel => 'Azúcar';

  @override
  String get sodiumLabel => 'Sodio';

  @override
  String get stepsLabel => 'Pasos';

  @override
  String get stepsTodayLabel => 'Pasos de hoy';

  @override
  String get caloriesBurnedLabel => 'Calorías quemadas';

  @override
  String get stepTrackingActive => '?Seguimiento de pasos activo!';

  @override
  String get waterLabel => 'Agua';

  @override
  String get servingSizeLabel => 'Servicio Tamaño';

  @override
  String get waterSettingsTitle => 'Ajustes de agua';

  @override
  String get hydrationQuestion =>
      '¿Cuánta agua necesita para mantenerse hidratado?';

  @override
  String get hydrationInfo =>
      'Las necesidades de cada persona son ligeramente diferentes, pero recomendamos consumir al menos 64 onzas líquidas (8 tazas) de agua cada día.';

  @override
  String get healthScoreTitle => 'Puntuación de salud';

  @override
  String get healthSummaryNoData =>
      'No se han registrado datos para hoy. ¡Empiece a realizar un seguimiento de sus comidas para ver información sobre su salud! ';

  @override
  String get healthSummaryLowIntake =>
      ' Su ingesta es bastante baja. Concéntrese en alcanzar sus objetivos de calorías y proteínas para mantener la energía y los músculos. ';

  @override
  String get healthSummaryLowProtein =>
      ' Los carbohidratos y las grasas van por buen camino, pero su nivel de proteínas es bajo. Aumentar las proteínas puede ayudar con la retención muscular. ';

  @override
  String get healthSummaryGreat =>
      ' ¡Excelente trabajo! Su nutrición está bien equilibrada hoy.';

  @override
  String get recentlyLoggedTitle => 'Registrado recientemente';

  @override
  String errorLoadingLogs(Object error) {
    return 'Error al cargar registros: $error';
  }

  @override
  String get deleteLabel => 'Eliminar';

  @override
  String get tapToAddFirstEntry => 'Toca + para añadir tu primer registro';

  @override
  String unableToLoadProgress(Object error) {
    return 'No se puede cargar el progreso: $error';
  }

  @override
  String get myWeightTitle => 'Mi peso';

  @override
  String goalWithValue(Object value) {
    return 'Objetivo $value';
  }

  @override
  String get noGoalSet => 'Sin objetivo establecido';

  @override
  String get logWeightCta => 'Registrar peso';

  @override
  String get dayStreakTitle => 'Racha de días';

  @override
  String get progressPhotosTitle => 'Fotos de progreso';

  @override
  String get progressPhotoPrompt =>
      '¿Quieres agregar una foto para seguir tu progreso?';

  @override
  String get uploadPhotoCta => 'Subir foto';

  @override
  String get goalProgressTitle => 'Progreso de la meta';

  @override
  String get ofGoalLabel => 'de objetivo';

  @override
  String get logoutLabel => 'Cerrar sesión';

  @override
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get logoutConfirmMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get preferencesLabel => 'Preferencias';

  @override
  String get appearanceLabel => 'Apariencia';

  @override
  String get appearanceDescription =>
      'Elige apariencia clara, oscura o del sistema';

  @override
  String get lightLabel => 'Claro';

  @override
  String get darkLabel => 'Oscuro';

  @override
  String get automaticLabel => 'Automático';

  @override
  String get addBurnedCaloriesLabel => 'Agregar calorías quemadas';

  @override
  String get addBurnedCaloriesDescription =>
      'Agregar calorías quemadas a la meta diaria';

  @override
  String get rolloverCaloriesLabel => 'Calorías acumuladas';

  @override
  String get rolloverCaloriesDescription =>
      'Agregue hasta 200 calorías sobrantes a la meta diaria objetivo';

  @override
  String get measurementUnitLabel => 'Unidades de medida';

  @override
  String get measurementUnitDescription =>
      'Todos los valores se convertirán al sistema imperial (actualmente métrico).';

  @override
  String get inviteFriendsLabel => 'Invitar amigos';

  @override
  String get defaultUserName => 'usuario';

  @override
  String get enterYourNameLabel => 'Ingrese su nombre';

  @override
  String yearsOldLabel(Object years) {
    return '$years años';
  }

  @override
  String get termsAndConditionsLabel => 'Términos y condiciones';

  @override
  String get privacyPolicyLabel => 'Política de privacidad';

  @override
  String get supportEmailLabel => 'Correo electrónico de soporte';

  @override
  String get featureRequestLabel => 'Solicitud de función';

  @override
  String get deleteAccountQuestion => '?Eliminar cuenta?';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountMessage =>
      '¿Estás totalmente seguro? Esto eliminará permanentemente tu historial de Cal AI, registros de peso y metas personalizadas. Esta acción no se puede deshacer.';

  @override
  String get deletePermanentlyLabel => 'Eliminar permanentemente';

  @override
  String get onboardingChooseGenderTitle => 'Elige tu género';

  @override
  String get onboardingChooseGenderSubtitle =>
      'Esto se usará para calibrar tu plan personalizado.';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderOther => 'Otro';

  @override
  String get onboardingWorkoutsPerWeekTitle =>
      '¿Cuántos entrenamientos haces por semana?';

  @override
  String get onboardingWorkoutsPerWeekSubtitle =>
      'Esto se usará para calibrar tu plan personalizado.';

  @override
  String get workoutRangeLowTitle => '0-2';

  @override
  String get workoutRangeLowSubtitle => 'Entrenamientos de vez en cuando';

  @override
  String get workoutRangeModerateTitle => '3-5';

  @override
  String get workoutRangeModerateSubtitle =>
      'A algunos entrenamientos por semana';

  @override
  String get workoutRangeHighTitle => '6+';

  @override
  String get workoutRangeHighSubtitle => 'Atleta dedicado';

  @override
  String get onboardingHearAboutUsTitle => '¿Dónde se enteró de nosotros?';

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
  String get sourceFriendFamily => 'Amigo o familia';

  @override
  String get sourceTv => 'TV';

  @override
  String get sourceInstagram => 'Instagram';

  @override
  String get sourceX => 'X';

  @override
  String get sourceOther => 'Otro';

  @override
  String get yourBmiTitle => 'Su BMI';

  @override
  String get yourWeightIsLabel => 'Su peso es';

  @override
  String get bmiUnderweightLabel => 'Bajo peso';

  @override
  String get bmiHealthyLabel => 'Saludable';

  @override
  String get bmiOverweightLabel => 'Sobrepeso';

  @override
  String get bmiObeseLabel => 'Obeso';

  @override
  String get calorieTrackingMadeEasy => 'El seguimiento de calorías es fácil';

  @override
  String get onboardingStep1Title => 'Seguimiento de sus comidas';

  @override
  String get onboardingStep1Description =>
      'Registre sus comidas fácilmente y realice un seguimiento de sus nutrición.';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo electrónico';

  @override
  String signInFailed(Object error) {
    return 'Error de inicio de sesión: $error';
  }

  @override
  String get continueLabel => 'Continuar';

  @override
  String get skipLabel => 'Saltar';

  @override
  String get noLabel => 'No';

  @override
  String get yesLabel => 'Sí';

  @override
  String get submitLabel => 'Enviar';

  @override
  String get referralCodeLabel => 'Referencia Código';

  @override
  String get heightLabel => 'Altura';

  @override
  String get weightLabel => 'Peso';

  @override
  String get imperialLabel => 'Imperial';

  @override
  String get metricLabel => 'Métrico';

  @override
  String get month1Label => 'Mes 1';

  @override
  String get month6Label => 'Mes 6';

  @override
  String get traditionalDietLabel => 'Dieta tradicional';

  @override
  String get weightChartSummary =>
      'El 80% de los usuarios de Cal AI mantienen su pérdida de peso incluso 6 meses después';

  @override
  String get comparisonWithoutCalAi => 'Sin\nCal AI';

  @override
  String get comparisonWithCalAi => 'Con\nCal AI';

  @override
  String get comparisonLeftValue => '20%';

  @override
  String get comparisonRightValue => '2X';

  @override
  String get comparisonBottomLine1 => 'Cal AI lo hace fácil y lo mantiene';

  @override
  String get comparisonBottomLine2 => 'usted responsable';

  @override
  String get speedSlowSteady => 'Lento y constante';

  @override
  String get speedRecommended => 'Recomendado';

  @override
  String get speedAggressiveWarning =>
      'Es posible que te sientas muy cansado y desarrolles piel flácida';

  @override
  String get subscriptionHeadline =>
      'Desbloquea CalAI para alcanzar\ntus objetivos más rápido.';

  @override
  String subscriptionPriceHint(Object yearlyPrice, Object monthlyPrice) {
    return 'Solo PHP $yearlyPrice por año (PHP $monthlyPrice/mes)';
  }

  @override
  String get goalGainWeight => 'Ganar peso';

  @override
  String get goalLoseWeight => 'Perder peso';

  @override
  String get goalMaintainWeight => 'Mantener peso';

  @override
  String editGoalTitle(Object title) {
    return 'Editar $title Objetivo';
  }

  @override
  String get revertLabel => 'Revertir';

  @override
  String get doneLabel => 'Listo';

  @override
  String get dashboardShouldGainWeight => 'ganar';

  @override
  String get dashboardShouldLoseWeight => 'perder';

  @override
  String get dashboardShouldMaintainWeight => 'mantener';

  @override
  String get dashboardCongratsPlanReady =>
      'Felicitaciones\nsu plan personalizado es ¡Listo!';

  @override
  String dashboardYouShouldGoal(Object action) {
    return 'Deberías $action:';
  }

  @override
  String dashboardWeightGoalByDate(Object value, Object unit, Object date) {
    return '$value $unit por $date';
  }

  @override
  String get dashboardDailyRecommendation => 'Recomendación diaria';

  @override
  String get dashboardEditAnytime => 'Puedes editar esto en cualquier momento';

  @override
  String get dashboardHowToReachGoals => 'Cómo alcanzar tus objetivos:';

  @override
  String get dashboardReachGoalLifeScore =>
      'Obtén tu puntaje de vida semanal y mejora tu rutina.';

  @override
  String get dashboardReachGoalTrackFood =>
      'Haz un seguimiento de tu alimentación';

  @override
  String get dashboardReachGoalFollowCalories =>
      'Sigue tus calorías diarias recomendación';

  @override
  String get dashboardReachGoalBalanceMacros =>
      'Equilibre sus carbohidratos, proteínas y grasas';

  @override
  String get dashboardPlanSourcesTitle =>
      'Planifique basándose en las siguientes fuentes, entre otros estudios médicos revisados por pares:';

  @override
  String get dashboardSourceBasalMetabolicRate => 'Tasa metabólica basal';

  @override
  String get dashboardSourceCalorieCountingHarvard =>
      'Recuento de calorías - Harvard';

  @override
  String get dashboardSourceInternationalSportsNutrition =>
      'Sociedad Internacional de Nutrición Deportiva';

  @override
  String get dashboardSourceNationalInstitutesHealth =>
      'Institutos Nacionales de Salud';

  @override
  String get factorsNetCarbsMass => 'Carbohidratos netos/masa';

  @override
  String get factorsNetCarbDensity => 'Densidad neta de carbohidratos';

  @override
  String get factorsSodiumMass => 'Sodio/masa';

  @override
  String get factorsSodiumDensity => 'Sodio densidad';

  @override
  String get factorsSugarMass => 'Azúcar / masa';

  @override
  String get factorsSugarDensity => 'Densidad de azúcar';

  @override
  String get factorsProcessedScore => 'Puntuación procesada';

  @override
  String get factorsIngredientQuality => 'Calidad de los ingredientes';

  @override
  String get factorsProcessedScoreDescription =>
      'La puntuación procesada tiene en cuenta colorantes, nitratos, aceites de semillas, saborizantes/edulcorantes artificiales y otros factores.';

  @override
  String get healthScoreExplanationIntro =>
      'Nuestra puntuación de salud es una fórmula compleja que tiene en cuenta varios factores dados una multitud de alimentos comunes.';

  @override
  String get healthScoreExplanationFactorsLead =>
      'A continuación se detallan los factores que tomamos en cuenta al calcular la salud puntuación:';

  @override
  String get netCarbsLabel => 'Carbohidratos netos';

  @override
  String get howDoesItWork => '¿Cómo funciona?';

  @override
  String get goodLabel => 'Bueno';

  @override
  String get badLabel => 'Malo';

  @override
  String get dailyRecommendationFor => 'Recomendación diaria para';

  @override
  String get loadingCustomizingHealthPlan =>
      'Personalizando el plan de salud...';

  @override
  String get loadingApplyingBmrFormula => 'Aplicando la fórmula de TMB...';

  @override
  String get loadingEstimatingMetabolicAge => 'Estimando tu edad metabólica...';

  @override
  String get loadingFinalizingResults => 'Finalizando resultados...';

  @override
  String get loadingSetupForYou => 'Estamos configurando todo\npara ti';

  @override
  String get step4TriedOtherCalorieApps =>
      '¿Has probado otro seguimiento de calorías? apps?';

  @override
  String get step5CalAiLongTermResults =>
      'Cal AI crea resultados a largo plazo';

  @override
  String get step6HeightWeightTitle => 'Altura y peso';

  @override
  String get step6HeightWeightSubtitle =>
      'Esto se tendrá en cuenta al calcular sus objetivos nutricionales diarios.';

  @override
  String get step7WhenWereYouBorn => '¿Cuándo naciste?';

  @override
  String get step8GoalQuestionTitle => '¿Cuál es tu objetivo?';

  @override
  String get step8GoalQuestionSubtitle =>
      'Esto nos ayuda a generar un plan para tu ingesta de calorías.';

  @override
  String get step9SpecificDietQuestion =>
      '¿Sigues un programa específico? dieta?';

  @override
  String get step9DietClassic => 'Clásico';

  @override
  String get step9DietPescatarian => 'Pescatariano';

  @override
  String get step9DietVegetarian => 'Vegetariano';

  @override
  String get step9DietVegan => 'Vegano';

  @override
  String get step91DesiredWeightQuestion => '¿Cuál es su peso deseado?';

  @override
  String get step92GoalActionGaining => 'Ganar';

  @override
  String get step92GoalActionLosing => 'Perder';

  @override
  String get step92RealisticTargetSuffix =>
      ' es un objetivo realista. ¡No es nada difícil!';

  @override
  String get step92SocialProof =>
      'El 90% de los usuarios dice que el cambio es obvio después de usar Cal AI y que no es fácil recuperarse.';

  @override
  String get step93GoalVerbGain => 'Ganar';

  @override
  String get step93GoalVerbLose => 'Perder';

  @override
  String get step93SpeedQuestionTitle =>
      '¿Qué tan rápido quieres alcanzar tu objetivo?';

  @override
  String step93WeightSpeedPerWeek(Object action) {
    return '$action velocidad de peso por semana';
  }

  @override
  String get step94ComparisonTitle =>
      'Pierde el doble de peso con Cal AI que por tu cuenta';

  @override
  String get step95ObstaclesTitle => '¿Qué te impide alcanzar tus objetivos?';

  @override
  String get step10AccomplishTitle => '¿Qué te gustaría lograr?';

  @override
  String get step10OptionHealthier => 'Comer y vivir más saludable';

  @override
  String get step10OptionEnergyMood =>
      'Aumenta mi energía y mi estado de ánimo';

  @override
  String get step10OptionConsistency => 'Mantenerme motivado y consistente';

  @override
  String get step10OptionBodyConfidence => 'Sentirme mejor con mi cuerpo';

  @override
  String get step11PotentialTitle =>
      'Tienes un gran potencial para superar tu objetivo';

  @override
  String get step12ThankYouTitle => '¡Gracias por\nconfiar en nosotros!';

  @override
  String get step12PersonalizeSubtitle =>
      'Ahora personalicemos Cal AI para ti...';

  @override
  String get step12PrivacyCardTitle =>
      'Tu privacidad y seguridad nos importan.';

  @override
  String get step12PrivacyCardBody =>
      'Prometemos mantener siempre tu\ninformación personal privada y segura.';

  @override
  String get step13ReachGoalsWithNotifications =>
      'Alcanza tus objetivos con las notificaciones que';

  @override
  String get step13NotificationPrompt =>
      'Cal AI quisiera enviarte notificaciones';

  @override
  String get allowLabel => 'Permitir';

  @override
  String get dontAllowLabel => 'No permitir';

  @override
  String get step14AddBurnedCaloriesQuestion =>
      '¿Agregar calorías quemadas a su objetivo diario?';

  @override
  String get step15RolloverQuestion =>
      '¿Transferir calorías adicionales al día siguiente?';

  @override
  String get step15RolloverUpTo => 'Transferir hasta ';

  @override
  String get step15RolloverCap => '200 calorías';

  @override
  String get step16ReferralTitle =>
      'Ingrese el código de referencia (opcional)';

  @override
  String get step16ReferralSubtitle => 'Puede omitir este paso';

  @override
  String get step17AllDone => '¡Todo listo!';

  @override
  String get step17GeneratePlanTitle =>
      '¡Es hora de generar su plan personalizado!';

  @override
  String get step18CalculationError =>
      'No se pudo calcular plano. Verifique su conexión.';

  @override
  String get step18TryAgain => 'Inténtelo de nuevo';

  @override
  String get step19CreateAccountTitle => 'Crear una cuenta';

  @override
  String get authInvalidEmailMessage =>
      'Introduce una dirección de correo válida';

  @override
  String get authCheckYourEmailTitle => 'Revisa tu correo';

  @override
  String authSignInLinkSentMessage(Object email) {
    return 'Enviamos un enlace de acceso a $email';
  }

  @override
  String get okLabel => 'OK';

  @override
  String genericErrorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get authWhatsYourEmail => '¿Cuál es tu correo?';

  @override
  String get authPasswordlessHint =>
      'Le enviaremos un enlace para iniciar sesión sin un contraseña.';

  @override
  String get emailExampleHint => 'nombre@ejemplo.com';

  @override
  String get notSetLabel => 'No establecido';

  @override
  String get goalWeightLabel => 'Peso objetivo';

  @override
  String get changeGoalLabel => 'Cambiar objetivo';

  @override
  String get currentWeightLabel => 'Peso actual';

  @override
  String get dateOfBirthLabel => 'Fecha de nacimiento';

  @override
  String get genderLabel => 'Género';

  @override
  String get dailyStepGoalLabel => 'Objetivo de paso diario';

  @override
  String get stepGoalLabel => 'Objetivo de paso';

  @override
  String get setHeightTitle => 'Establecer altura';

  @override
  String get setGenderTitle => 'Establecer género';

  @override
  String get setBirthdayTitle => 'Establecer cumpleaños';

  @override
  String get setWeightTitle => 'Establecer peso';

  @override
  String get editNameTitle => 'Editar nombre';

  @override
  String get calorieGoalLabel => 'Objetivo de calorías';

  @override
  String get proteinGoalLabel => 'Objetivo de proteínas';

  @override
  String get carbGoalLabel => 'Objetivo de carbohidratos';

  @override
  String get fatGoalLabel => 'Objetivo de grasas';

  @override
  String get sugarLimitLabel => 'Límite de azúcar';

  @override
  String get fiberGoalLabel => 'Objetivo de fibra';

  @override
  String get sodiumLimitLabel => 'Límite de sodio';

  @override
  String get hideMicronutrientsLabel => 'Ocultar micronutrientes';

  @override
  String get viewMicronutrientsLabel => 'Ver micronutrientes';

  @override
  String get autoGenerateGoalsLabel => 'Autogenerar objetivos';

  @override
  String failedToGenerateGoals(Object error) {
    return 'Error al generar objetivos: $error';
  }

  @override
  String get calculatingCustomGoals =>
      'Calculando tu objetivo personalizado objetivos...';

  @override
  String get logExerciseLabel => 'Registrar ejercicio';

  @override
  String get savedFoodsLabel => 'Alimentos guardados';

  @override
  String get foodDatabaseLabel => 'Base de datos de alimentos';

  @override
  String get scanFoodLabel => 'Escanear alimentos';

  @override
  String get exerciseTitle => 'Ejercicio';

  @override
  String get runTitle => 'Correr';

  @override
  String get weightLiftingTitle => 'Levantamiento de pesas';

  @override
  String get describeTitle => 'Describir';

  @override
  String get runDescription => 'Correr, trotar, correr, etc.';

  @override
  String get weightLiftingDescription => 'Máquinas, pesas libres, etc.';

  @override
  String get describeWorkoutDescription => 'Escribe tu entrenamiento en texto';

  @override
  String get setIntensityLabel => 'Establecer Intensidad';

  @override
  String get durationLabel => 'Duración';

  @override
  String get minutesShortLabel => 'minutos';

  @override
  String get minutesAbbrevSuffix => 'm';

  @override
  String get addLabel => 'Añadir';

  @override
  String get intensityLabel => 'Intensidad';

  @override
  String get intensityHighLabel => 'Alta';

  @override
  String get intensityMediumLabel => 'Medio';

  @override
  String get intensityLowLabel => 'Bajo';

  @override
  String get runIntensityHighDescription =>
      'Carreras de velocidad: 14 mph (4 minutos por milla)';

  @override
  String get runIntensityMediumDescription =>
      'Trotar: 6 mph (10 minutos por milla)';

  @override
  String get runIntensityLowDescription =>
      'Caminata relajada: 3 mph (20 minutos por milla)';

  @override
  String get weightIntensityHighDescription =>
      'Entrenando hasta el fracaso, respirando pesadamente.';

  @override
  String get weightIntensityMediumDescription => 'Sudando, muchas repeticiones';

  @override
  String get weightIntensityLowDescription =>
      'Sin sudar, haciendo poco esfuerzo';

  @override
  String get exerciseLoggedSuccessfully =>
      '¡Ejercicio registrado exitosamente!';

  @override
  String get exerciseParsedAndLogged => '¡Ejercicio analizado y registrado!';

  @override
  String get describeExerciseTitle => 'Describir el ejercicio';

  @override
  String get whatDidYouDoHint => '?Qu? hiciste?';

  @override
  String get describeExerciseExample =>
      'Ejemplo: Caminata al aire libre durante 5 horas, me sentí agotado';

  @override
  String get servingLabel => 'Servicio';

  @override
  String get productNotFoundMessage => 'Producto no encontrado.';

  @override
  String couldNotIdentify(Object text) {
    return 'No se pudo identificar \"$text\".';
  }

  @override
  String get identifyingFoodMessage => 'Identificando alimentos...';

  @override
  String get loggedSuccessfullyMessage =>
      '¡Se ha iniciado sesión correctamente!';

  @override
  String get barcodeScannerLabel => 'Escáner de código de barras';

  @override
  String get barcodeLabel => 'Código de barras';

  @override
  String get foodLabel => 'Etiqueta de los alimentos';

  @override
  String get galleryLabel => 'Galería';

  @override
  String get bestScanningPracticesTitle => 'Mejores prácticas de escaneo';

  @override
  String get generalTipsTitle => 'Consejos generales:';

  @override
  String get scanTipKeepFoodInside =>
      'Mantenga la comida dentro de las líneas de escaneo.';

  @override
  String get scanTipHoldPhoneStill =>
      'Mantenga su teléfono quieto para que la imagen no esté borrosa';

  @override
  String get scanTipAvoidObscureAngles =>
      'No tomes la fotografía en ángulos oscuros.';

  @override
  String get scanNowLabel => 'Escanear ahora';

  @override
  String get allTabLabel => 'Todo';

  @override
  String get myMealsTabLabel => 'mis comidas';

  @override
  String get myFoodsTabLabel => 'mis comidas';

  @override
  String get savedScansTabLabel => 'Escaneos guardados';

  @override
  String get logEmptyFoodLabel => 'Registrar comida vacía';

  @override
  String get searchResultsLabel => 'Resultados de la búsqueda';

  @override
  String get suggestionsLabel => 'Sugerencias';

  @override
  String get noItemsFoundLabel => 'No se encontraron artículos.';

  @override
  String get noSuggestionsAvailableLabel => 'No hay sugerencias disponibles';

  @override
  String get noSavedScansYetLabel => 'Aún no hay escaneos guardados';

  @override
  String get describeWhatYouAteHint => 'Describe lo que comiste';

  @override
  String foodAddedToDate(Object dateId, Object foodName) {
    return 'Se agregó $foodName a $dateId.';
  }

  @override
  String get failedToAddFood => 'No se pudo agregar comida. Intentar otra vez.';

  @override
  String get invalidFoodIdMessage => 'Identificación de comida no válida';

  @override
  String get foodNotFoundMessage => 'Comida no encontrada';

  @override
  String get couldNotLoadFoodDetails =>
      'No se pudieron cargar los detalles de la comida.';

  @override
  String get gramsShortLabel => 'G';

  @override
  String get standardLabel => 'Estándar';

  @override
  String get selectedFoodTitle => 'comida seleccionada';

  @override
  String get measurementLabel => 'Medición';

  @override
  String get otherNutritionFactsLabel => 'Otros datos nutricionales';

  @override
  String get numberOfServingsLabel => 'Número de porciones';

  @override
  String get logLabel => 'Registrar';

  @override
  String get nutrientsTitle => 'Nutrientes';

  @override
  String get totalNutritionLabel => 'Nutrición total';

  @override
  String get enterFoodNameHint => 'Introduzca el nombre del alimento';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get statsLabel => 'Estadísticas';

  @override
  String get intensityModerateLabel => 'Moderado';

  @override
  String get thisWeekLabel => 'Esta semana';

  @override
  String get lastWeekLabel => 'La semana pasada';

  @override
  String get twoWeeksAgoLabel => 'Hace 2 semanas';

  @override
  String get threeWeeksAgoLabel => 'Hace 3 semanas';

  @override
  String get totalCaloriesLabel => 'Calorías totales';

  @override
  String get calsLabel => 'calorías';

  @override
  String get dayShortSun => 'Sol';

  @override
  String get dayShortMon => 'Lun';

  @override
  String get dayShortTue => 'Mar';

  @override
  String get dayShortWed => 'Mi?';

  @override
  String get dayShortThu => 'Jue';

  @override
  String get dayShortFri => 'Vie';

  @override
  String get dayShortSat => 'Sáb';

  @override
  String get ninetyDaysLabel => '90 días';

  @override
  String get sixMonthsLabel => '6 meses';

  @override
  String get oneYearLabel => '1 año';

  @override
  String get allTimeLabel => 'Todo el tiempo';

  @override
  String get waitingForFirstLogLabel => 'Esperando tu primer registro...';

  @override
  String get editGoalPickerTitle => 'Editar selector de objetivos';

  @override
  String get bmiDisclaimerTitle => 'Descargo de responsabilidad';

  @override
  String get bmiDisclaimerBody =>
      'Como ocurre con la mayoría de las medidas de salud, el IMC no es una prueba perfecta. Por ejemplo, los resultados pueden verse alterados por el embarazo o una masa muscular elevada, y puede que no sea una buena medida de la salud de los niños o las personas mayores.';

  @override
  String get bmiWhyItMattersTitle => 'Entonces, ¿por qué es importante el IMC?';

  @override
  String get bmiWhyItMattersBody =>
      'En general, cuanto mayor sea su IMC, mayor será el riesgo de desarrollar una variedad de afecciones relacionadas con el exceso de peso, que incluyen:\n� diabetes\n� artritis\n� enfermedad hepática\n� varios tipos de cáncer (como los de mama, colon y próstata)\n� presión arterial alta (hipertensión)\n� colesterol alto\n� apnea del sueño';

  @override
  String get noWeightHistoryYet =>
      'Aún no se ha registrado ningún historial de peso.';

  @override
  String get overLabel => 'por encima';

  @override
  String get dailyBreakdownTitle => 'Desglose diario';

  @override
  String get editDailyGoalsLabel => 'Editar objetivos diarios';

  @override
  String get errorLoadingData => 'Error al cargar datos';

  @override
  String get gramsLabel => 'gramas';

  @override
  String get healthStatusNotEvaluated => 'No evaluado';

  @override
  String get healthStatusCriticallyLow => 'Críticamente bajo';

  @override
  String get healthStatusNeedsImprovement => 'Necesita mejorar';

  @override
  String get healthStatusFairProgress => 'Progreso justo';

  @override
  String get healthStatusGoodHealth => 'Buena salud';

  @override
  String get healthStatusExcellentHealth => 'Excelente salud';

  @override
  String get remindersTitle => 'Recordatorios';

  @override
  String get failedLoadReminderSettings =>
      'Error al cargar la configuración del recordatorio.';

  @override
  String get smartNutritionRemindersTitle =>
      'Recordatorios inteligentes de nutrición';

  @override
  String get dailyReminderAtLabel => 'Recordatorio diario en';

  @override
  String get setSmartNutritionTimeLabel =>
      'Establecer nutrición inteligente hora';

  @override
  String get waterRemindersTitle => 'Recordatorios de agua';

  @override
  String get everyLabel => 'Cada';

  @override
  String get hourUnitLabel => 'hora(s)';

  @override
  String get fromLabel => 'de';

  @override
  String get setWaterStartTimeLabel => 'Establecer hora de inicio de agua';

  @override
  String get breakfastReminderTitle => 'Recordatorio de desayuno';

  @override
  String get lunchReminderTitle => 'Recordatorio de almuerzo';

  @override
  String get dinnerReminderTitle => 'Recordatorio de cena';

  @override
  String get snackReminderTitle => 'Recordatorio de refrigerios';

  @override
  String get goalTrackingAlertsTitle => 'Alertas de seguimiento de objetivos';

  @override
  String get goalTrackingAlertsSubtitle =>
      'Alertas de objetivos macro y de calorías cercanas o excedidas';

  @override
  String get stepsExerciseReminderTitle => 'Pasos/ejercicio recordatorio';

  @override
  String get dailyAtLabel => 'Diariamente a las';

  @override
  String get setActivityReminderTimeLabel =>
      'Establecer hora de recordatorio de actividad';

  @override
  String get intervalLabel => 'Intervalo:';

  @override
  String get setTimeLabel => 'Establecer hora';

  @override
  String get languageNameEnglish => 'Inglés';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNamePortuguese => 'Portugués';

  @override
  String get languageNameFrench => 'Francés';

  @override
  String get languageNameGerman => 'Alemán';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNameHindi => 'Hindi';

  @override
  String get progressMessageStart =>
      'Comenzar es la parte más difícil. ¡Estás listo para esto! ';

  @override
  String get progressMessageKeepPushing =>
      'Estás progresando. ¡Ahora es el momento de seguir esforzándose! ';

  @override
  String get progressMessagePayingOff =>
      ' Tu dedicación está dando sus frutos. ¡Sigue adelante! ';

  @override
  String get progressMessageFinalStretch => ' Es la recta final. ¡Esfuérzate! ';

  @override
  String get progressMessageCongrats => ' ¡Lo lograste! ¡Felicitaciones!';

  @override
  String dayStreakWithCount(Object count) {
    return 'Racha de $count días';
  }

  @override
  String get streakLostTitle => 'Racha perdida';

  @override
  String get streakActiveSubtitle =>
      '?Vas genial! Sigue registrando para mantener el ritmo.';

  @override
  String get streakLostSubtitle =>
      'No te rindas. Registre sus comidas hoy para volver a la normalidad.';

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
  String get alertCalorieGoalExceededTitle => 'Objetivo de calorías superado';

  @override
  String alertCalorieGoalExceededBody(Object over) {
    return 'Tienes $over kcal por encima de tu objetivo diario.';
  }

  @override
  String get alertNearCalorieLimitTitle =>
      'Estás cerca de tu límite de calorías';

  @override
  String alertNearCalorieLimitBody(Object remaining) {
    return 'Solo quedan $remaining kcal hoy. Planifique su próxima comida con cuidado.';
  }

  @override
  String get alertProteinBehindTitle => 'El objetivo de proteínas está detrás';

  @override
  String alertProteinBehindBody(Object missing) {
    return 'Todavía necesita alrededor de $missing g de proteína para alcanzar el objetivo de hoy.';
  }

  @override
  String get alertCarbTargetExceededTitle =>
      'El objetivo de carbohidratos se superó';

  @override
  String alertCarbTargetExceededBody(Object over) {
    return 'Los carbohidratos están $over g por encima del objetivo.';
  }

  @override
  String get alertFatTargetExceededTitle => 'El objetivo de grasa se excedió';

  @override
  String alertFatTargetExceededBody(Object over) {
    return 'La grasa está $over g por encima del objetivo.';
  }

  @override
  String get smartNutritionTipTitle => 'Nutrición inteligente consejo';

  @override
  String smartNutritionKcalLeft(Object calories) {
    return '$calories kcal restantes';
  }

  @override
  String smartNutritionKcalOver(Object calories) {
    return '$calories kcal sobrantes';
  }

  @override
  String smartNutritionProteinRemaining(Object protein) {
    return '$protein g de proteína restante';
  }

  @override
  String get smartNutritionProteinGoalReached =>
      'objetivo de proteína alcanzado';

  @override
  String smartNutritionCombinedMessage(
    Object calorieMessage,
    Object proteinMessage,
  ) {
    return '$calorieMessage y $proteinMessage. Registre su próxima comida para mantener el rumbo.';
  }

  @override
  String get notificationStepsExerciseTitle =>
      'Recordatorio de pasos y ejercicio';

  @override
  String get notificationStepsExerciseBody =>
      'Registre sus pasos o entrenamiento para completar el objetivo de actividad de hoy.';

  @override
  String get notificationBreakfastTitle => 'Recordatorio de desayuno';

  @override
  String get notificationBreakfastBody =>
      'Registre el desayuno para comenzar temprano el seguimiento de calorías y macros.';

  @override
  String get notificationLunchTitle => 'Recordatorio de almuerzo';

  @override
  String get notificationLunchBody =>
      'Hora del almuerzo. Agregue su comida para mantener su progreso diario preciso.';

  @override
  String get notificationDinnerTitle => 'Recordatorio de cena';

  @override
  String get notificationDinnerBody =>
      'Registre la cena y cierre su día con datos nutricionales completos.';

  @override
  String get notificationSnackTitle => 'Recordatorio de refrigerio';

  @override
  String get notificationSnackBody =>
      'Agregue su refrigerio para que las calorías y las macros se mantengan alineadas con sus objetivos.';

  @override
  String get smartNutritionDailyTitle =>
      'Control diario de nutrición inteligente';

  @override
  String smartNutritionDailyBody(
    Object calories,
    Object protein,
    Object carbs,
    Object fats,
  ) {
    return 'Objetivo $calories kcal, ${protein}g proteína, ${carbs}g carbohidratos, ${fats}g de grasa. Registre su última comida para mantener su plan preciso.';
  }

  @override
  String get notificationWaterTitle => 'Recordatorio de agua';

  @override
  String get notificationWaterBody =>
      'Control de hidratación. Registra un vaso de agua en Cal AI.';

  @override
  String get homeWidgetLogFoodCta => 'Registra tu comida';

  @override
  String get homeWidgetCaloriesTodayTitle => 'Calorías de hoy';

  @override
  String homeWidgetCaloriesSubtitle(Object calories, Object goal) {
    return '$calories de $goal kcal';
  }
}
