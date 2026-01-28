import 'package:flutter_riverpod/legacy.dart';

import 'health_data.dart';
// Enums
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

enum HeightUnit { cm, ft }

enum WeightUnit { kg("kg"), lbs("lbs"); final String value; const WeightUnit(this.value);}

enum SpeedLevel { slow("slow"), recommended("recommended"), aggressive("aggressive"); final String value; const SpeedLevel(this.value); }

enum WorkoutFrequency { low("low"), moderate("moderate"), high("high"); final String value; const WorkoutFrequency(this.value); }

enum Goal { loseWeight("lose weight"), maintain("maintain"), gainWeight("gain weight"); final String value; const Goal(this.value); }

enum DietType { classic("classic"), pescatarian("pescatarian"), vegetarian("vegetarian"), vegan("vegan"); final String value; const DietType(this.value); }

enum GoalFocus { healthier("healthier"), energy("energy"), consistency("consistency"), bodyConfidence("body confidence"); final String value; const GoalFocus(this.value); }

class UserData {
  final Gender gender;
  final String name;
  final WorkoutFrequency workOutPerWeek;
  final String social;
  final bool hasTriedOtherCalorieApps;
  final double height;
  final double weight;
  final DateTime birthDay;
  final Goal goal;
  final double targetWeight;
  final DietType dietType;
  final GoalFocus likeToAccomplish;
  final bool isAddCalorieBurn;
  final bool isRollover;
  final double weightGoal;
  final double progressSpeed;
  final String stoppingReachGoal;

  double get bmi {
    if (height <= 0) return 0.0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  const UserData({
    required this.gender,
    required this.name,
    required this.workOutPerWeek,
    required this.social,
    required this.hasTriedOtherCalorieApps,
    required this.height,
    required this.weight,
    required this.birthDay,
    required this.goal,
    required this.targetWeight,
    required this.dietType,
    required this.likeToAccomplish,
    required this.isAddCalorieBurn,
    required this.weightGoal,
    required this.isRollover,
    required this.progressSpeed,
    required this.stoppingReachGoal,
  });

  factory UserData.initial() => UserData(
    gender: Gender.other,
    name: '',
    workOutPerWeek: WorkoutFrequency.low, // FIXED: Changed '' to Enum value
    social: '',
    hasTriedOtherCalorieApps: false,
    height: 168,
    weight: 54,
    weightGoal: 0.0,
    birthDay: DateTime(2001, 1, 1),
    goal: Goal.maintain,
    targetWeight: 0.0,
    dietType: DietType.classic,
    likeToAccomplish: GoalFocus.consistency,
    isAddCalorieBurn: false,
    isRollover: false,
    progressSpeed: 0.8,
    stoppingReachGoal: '',
  );

  UserData copyWith({
    Gender? gender,
    String? name,
    WorkoutFrequency? workOutPerWeek, // FIXED: Changed String? to Enum?
    String? social,
    bool? hasTriedOtherCalorieApps,
    double? height,
    double? weight,
    double? weightGoal,
    DateTime? birthDay,
    Goal? goal,
    double? targetWeight,
    DietType? dietType,
    GoalFocus? likeToAccomplish,
    bool? isAddCalorieBurn,
    bool? isRollover,
    double? progressSpeed,
    String? stoppingReachGoal,
  }) {
    return UserData(
      gender: gender ?? this.gender,
      name: name ?? this.name,
      workOutPerWeek: workOutPerWeek ?? this.workOutPerWeek,
      social: social ?? this.social,
      hasTriedOtherCalorieApps:
          hasTriedOtherCalorieApps ?? this.hasTriedOtherCalorieApps,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      weightGoal: weightGoal ?? this.weightGoal,
      birthDay: birthDay ?? this.birthDay,
      goal: goal ?? this.goal,
      targetWeight: targetWeight ?? this.targetWeight,
      dietType: dietType ?? this.dietType,
      likeToAccomplish: likeToAccomplish ?? this.likeToAccomplish,
      isAddCalorieBurn: isAddCalorieBurn ?? this.isAddCalorieBurn,
      isRollover: isRollover ?? this.isRollover,
      progressSpeed: progressSpeed ?? this.progressSpeed,
      stoppingReachGoal: stoppingReachGoal ?? this.stoppingReachGoal,
    );
  }
}

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(UserData.initial());

  /// The Generic Updater for one-liners in the UI
  void update(UserData Function(UserData state) transform) {
    state = transform(state);
  }

  /// Complex logic setters
  void setName(String name) => update((s) => s.copyWith(name: name.trim()));

  void setWeight(double value, WeightUnit unit) {
    if (value <= 0) return;
    double weightInKg = (unit == WeightUnit.lbs) ? value * 0.453592 : value;
    update((s) => s.copyWith(weight: weightInKg));
  }

  void setHeight({
    required HeightUnit unit,
    double? cm,
    int? ft,
    double? inches,
  }) {
    double finalCm = 0;
    if (unit == HeightUnit.cm) {
      finalCm = cm ?? 0;
    } else {
      finalCm = ((ft ?? 0) * 30.48) + ((inches ?? 0) * 2.54);
    }
    if (finalCm <= 0) return;
    update((s) => s.copyWith(height: finalCm));
  }

  void setTargetWeight(double target) {
    // Logic: Ensure target weight is within a sane range
    if (target <= 20 || target > 500) return;
    update((s) => s.copyWith(targetWeight: target));
  }

  void resetProfile() => state = UserData.initial();
}

final userProvider = StateNotifierProvider<UserDataNotifier, UserData>(
  (ref) => UserDataNotifier(),
);
