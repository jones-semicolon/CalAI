import 'package:flutter/material.dart';

enum Gender {
  male("male"),     // Change to lowercase to match your fromString logic
  female("female"),
  other("other");

  final String value;
  const Gender(this.value);

  String get label => this == Gender.male ? 'Male' : this == Gender.female ? 'Female' : 'Other';

  static Gender fromString(String val) {
    return Gender.values.firstWhere(
          (e) => e.value == val.toLowerCase().trim(),
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

enum MeasurementUnit {
  metric("metric"),
  imperial("imperial");

  final String value;
  const MeasurementUnit(this.value);

  static MeasurementUnit fromString(String val) {
    return MeasurementUnit.values.firstWhere(
          (e) => e.value == val,
      orElse: () => MeasurementUnit.metric,
    );
  }

  // --- UI Labels ---

  /// Returns 'kg' or 'lbs'
  String get weightLabel => this == MeasurementUnit.metric ? 'kg' : 'lbs';

  /// Returns 'cm' or 'ft'
  String get heightLabel => this == MeasurementUnit.metric ? 'cm' : 'ft';

  /// Returns 'ml' or 'fl oz'
  String get liquidLabel => this == MeasurementUnit.metric ? 'ml' : 'fl oz';

  /// Returns 'g' or 'oz' (for small food portions)
  String get massLabel => this == MeasurementUnit.metric ? 'g' : 'oz';

  // --- Logic Helpers ---

  bool get isMetric => this == MeasurementUnit.metric;
  bool get isImperial => this == MeasurementUnit.imperial;

  double weightToMetric(double value) {
    if (isMetric) return value;
    // Convert Imperial Input to Metric Storage
    return value * 0.453592; // lbs to kg
  }

  /// Use this when PULLING from the database for the UI
  double metricToDisplay(double value) {
    if (isMetric) return value;
    // Convert Metric Storage to Imperial Display
    return value * 2.20462; // kg to lbs
  }

  double liquidToDisplay(double ml) {
    if (isMetric) return ml;
    return ml * 0.033814; // ml to US fl oz
  }

  double heightToDisplay(double cm) {
    if (isMetric) return cm;
    return cm * 0.0328084; // cm to ft
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

enum ObstacleType {
  consistency('Lack of consistency', Icons.bar_chart),
  unhealthyEating('Unhealthy eating habits', Icons.fastfood),
  lackOfSupport('Lack of supports', Icons.group),
  busySchedule('Busy schedule', Icons.calendar_month),
  mealInspiration('Lack of meal inspiration', Icons.food_bank);

  final String title;
  final IconData icon;
  const ObstacleType(this.title, this.icon);

  static ObstacleType fromString(String val) {
    return ObstacleType.values.firstWhere(
          (e) => e.title == val,
      orElse: () => ObstacleType.consistency,
    );
  }
}