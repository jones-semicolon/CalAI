enum GoalAlertType {
  nearCalorieLimit,
  exceededCalorieLimit,
  belowProteinTarget,
  exceededCarbTarget,
  exceededFatTarget,
}

class GoalAlert {
  const GoalAlert({
    required this.type,
    required this.title,
    required this.body,
  });

  final GoalAlertType type;
  final String title;
  final String body;
}
