enum Gender {
  male("male"),
  female("female"),
  other("other");

  final String value;
  const Gender(this.value);

  static Gender fromString(String val) {
    return Gender.values.firstWhere(
          (e) => e.value == val,
      orElse: () => Gender.other,
    );
  }
}

enum HeightUnit {
  cm("cm"),
  ft("ft");

  final String value;
  const HeightUnit(this.value);

  static HeightUnit fromString(String val) {
    return HeightUnit.values.firstWhere(
          (e) => e.value == val,
      orElse: () => HeightUnit.cm,
    );
  }
}

enum WeightUnit {
  kg("kg"),
  lbs("lbs");

  final String value;
  const WeightUnit(this.value);

  static WeightUnit fromString(String val) {
    return WeightUnit.values.firstWhere(
          (e) => e.value == val,
      orElse: () => WeightUnit.kg,
    );
  }
}

enum SpeedLevel {
  slow("slow"),
  recommended("recommended"),
  aggressive("aggressive");

  final String value;
  const SpeedLevel(this.value);

  static SpeedLevel fromString(String val) {
    return SpeedLevel.values.firstWhere(
          (e) => e.value == val,
      orElse: () => SpeedLevel.recommended,
    );
  }
}

enum WorkoutFrequency {
  low("low"),
  moderate("moderate"),
  high("high");

  final String value;
  const WorkoutFrequency(this.value);

  static WorkoutFrequency fromString(String val) {
    return WorkoutFrequency.values.firstWhere(
          (e) => e.value == val,
      orElse: () => WorkoutFrequency.low,
    );
  }
}

enum Goal {
  loseWeight("lose weight"),
  maintain("maintain"),
  gainWeight("gain weight");

  final String value;
  const Goal(this.value);

  static Goal fromString(String val) {
    return Goal.values.firstWhere(
          (e) => e.value == val,
      orElse: () => Goal.maintain,
    );
  }
}

enum DietType {
  classic("classic"),
  pescatarian("pescatarian"),
  vegetarian("vegetarian"),
  vegan("vegan");

  final String value;
  const DietType(this.value);

  static DietType fromString(String val) {
    return DietType.values.firstWhere(
          (e) => e.value == val,
      orElse: () => DietType.classic,
    );
  }
}

enum GoalFocus {
  healthier("healthier"),
  energy("energy"),
  consistency("consistency"),
  bodyConfidence("body confidence");

  final String value;
  const GoalFocus(this.value);

  static GoalFocus fromString(String val) {
    return GoalFocus.values.firstWhere(
          (e) => e.value == val,
      orElse: () => GoalFocus.healthier,
    );
  }
}

enum UserProvider {
  anonymous("anonymous"),
  google("google"),
  apple("apple");

  final String value;
  const UserProvider(this.value);

  static UserProvider fromString(String val) {
    return UserProvider.values.firstWhere(
          (e) => e.value == val,
      orElse: () => UserProvider.anonymous,
    );
  }
}