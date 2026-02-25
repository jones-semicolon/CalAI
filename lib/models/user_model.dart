import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:calai/enums/user_enums.dart';

import 'nutrition_model.dart';

// -----------------------------------------------------------------------------
// 1. MAIN USER MODEL
// -----------------------------------------------------------------------------

@immutable
class User {
  final String id;
  // Sub-models are always present, but their internal fields may be null
  final UserProfile profile;
  final UserBiometrics body;
  final UserGoal goal;
  final UserSettings settings;

  const User({
    required this.id,
    required this.profile,
    required this.body,
    required this.goal,
    required this.settings,
  });

  Map<String, dynamic> toJson() => {
    'uid': id,
    'profile': profile.toJson(),
    'body': body.toJson(),
    'goal': goal.toJson(),
    'settings': settings.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uid'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      body: UserBiometrics.fromJson(json['body'] ?? {}),
      goal: UserGoal.fromJson(json['goal'] ?? json),
      settings: UserSettings.fromJson(json['settings'] ?? {}),
    );
  }

  User copyWith({
    String? id,
    UserProfile? profile,
    UserBiometrics? body,
    UserGoal? goal,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      body: body ?? this.body,
      goal: goal ?? this.goal,
      settings: settings ?? this.settings,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. SUB-MODEL: PROFILE (Nullable)
// -----------------------------------------------------------------------------

@immutable
class UserProfile {
  final String? name;
  final Gender? gender;
  final DateTime? birthDate;
  final UserProvider? provider;
  final String? referralCode; 
  final String? photoURL;

  const UserProfile({
    this.name,  
    this.gender,   
    required this.birthDate, 
    this.provider, 
    this.referralCode,
    this.photoURL,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender?.name,
    'birthDate': birthDate?.toIso8601String(),
    'provider': provider?.name ?? UserProvider.anonymous.name,
    'referralCode': referralCode,
    'photoURL': photoURL,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Anonymous',
      gender: Gender.fromString(json['gender'] ?? ""),
      // ✅ Handle the conversion from Timestamp to DateTime
      birthDate: _parseBirthDate(json['birthDate']),
      provider: UserProvider.fromString(
          json['provider'] ?? UserProvider.anonymous.name
      ),
      referralCode: json['referralCode'],
      photoURL: json['photoURL'],
    );
  }

  static DateTime _parseBirthDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime(2001, 1, 1);
    }
    return DateTime(2001, 1, 1); // Fallback
  }

  UserProfile copyWith({String? name, Gender? gender, DateTime? birthDate, UserProvider? provider, String? referralCode, String? photoURL}) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      provider: provider ?? this.provider,
      referralCode: referralCode ?? this.referralCode,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}

// -----------------------------------------------------------------------------
// 3. SUB-MODEL: BIOMETRICS (Strict Height/Weight)
// -----------------------------------------------------------------------------

@immutable
class UserBiometrics {
  // These stay REQUIRED and NON-NULLABLE as requested
  final double height;
  final double currentWeight;

  // We keep units non-null because a number without a unit is dangerous.
  // Defaults will be provided in the initial state.
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;

  const UserBiometrics({
    required this.height,
    required this.currentWeight,
    required this.heightUnit,
    required this.weightUnit,
  });

  Map<String, dynamic> toJson() => {
    'height': height,
    'currentWeight': currentWeight,
    'heightUnit': heightUnit.name,
    'weightUnit': weightUnit.name,
  };

  factory UserBiometrics.fromJson(Map<String, dynamic> json) {
    return UserBiometrics(
      height: (json['height'] ?? 0).toDouble(),
      currentWeight: (json['currentWeight'] ?? 0).toDouble(),
      heightUnit: HeightUnit.fromString(json['heightUnit'] ?? ''),
      weightUnit: WeightUnit.fromString(json['weightUnit'] ?? ''),
    );
  }

  // BMI is safe because height/weight are never null (but check for 0)
  double get bmi {
    if (height <= 0) return 0.0;

    double h = height;
    double w = currentWeight;

    if (heightUnit == HeightUnit.ft) h = h * 30.48;
    if (weightUnit == WeightUnit.lbs) w = w * 0.453592;

    final heightInMeters = h / 100;
    return w / (heightInMeters * heightInMeters);
  }

  UserBiometrics copyWith({
    double? height,
    double? currentWeight,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
  }) {
    return UserBiometrics(
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      heightUnit: heightUnit ?? this.heightUnit,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }
}

// -----------------------------------------------------------------------------
// 4. SUB-MODEL: GOALS (Nullable)
// -----------------------------------------------------------------------------

@immutable
class UserGoal {
  final Goal? type;
  // final double? targetWeight; // This is a number (e.g. 75.0 kg)
  final double? weeklyRate;
  final GoalFocus? motivation;
  final WorkoutFrequency? activityLevel;
  final DietType? dietType;
  final ObstacleType? maintenanceStrategy;

  // ✅ ADDED: This field holds your NutritionGoals (Calories, Protein, etc.)
  final NutritionGoals targets;

  const UserGoal({
    this.type,
    // this.targetWeight,
    this.weeklyRate,
    this.motivation,
    this.activityLevel,
    this.dietType,
    this.maintenanceStrategy,
    required this.targets, // Default to empty goals
  });

  Map<String, dynamic> toJson() => {
    'type': type?.name,
    // 'weightGoal': targetWeight,
    'weeklyRate': weeklyRate,
    'motivation': motivation?.name,
    'activityLevel': activityLevel?.name,
    'dietType': dietType?.name,
    'maintenanceStrategy': maintenanceStrategy?.name,
    'dailyGoals': targets.toJson(),
  };

  factory UserGoal.fromJson(Map<String, dynamic> json) {
    return UserGoal(
      // ✅ Fix: Add ?? '' or a default value for every enum/string
      type: Goal.fromString(json['type'] ?? Goal.maintain.name),

      weeklyRate: (json['weeklyRate'] as num?)?.toDouble() ?? 0.8,

      motivation: GoalFocus.fromString(json['motivation'] ?? GoalFocus.healthier.name),
      activityLevel: WorkoutFrequency.fromString(json['activityLevel'] ?? WorkoutFrequency.moderate.name),
      dietType: DietType.fromString(json['dietType'] ?? DietType.classic.name),

      maintenanceStrategy: ObstacleType.fromString(
          json['maintenanceStrategy'] ?? ObstacleType.consistency.name
      ),

      // ✅ Already looks good, but let's be extra safe
      targets: json['dailyGoals'] != null
          ? NutritionGoals.fromJson(json['dailyGoals'] as Map<String, dynamic>)
          : NutritionGoals.empty,
    );
  }

  UserGoal copyWith({
    Goal? type,
    double? weeklyRate,
    GoalFocus? motivation,
    WorkoutFrequency? activityLevel,
    DietType? dietType,
    ObstacleType? maintenanceStrategy,
    NutritionGoals? targets, // ✅ ADDED
  }) {
    return UserGoal(
      type: type ?? this.type,
      weeklyRate: weeklyRate ?? this.weeklyRate,
      motivation: motivation ?? this.motivation,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      maintenanceStrategy: maintenanceStrategy ?? this.maintenanceStrategy,
      targets: targets ?? this.targets, // ✅ ADDED
    );
  }
}

// -----------------------------------------------------------------------------
// 5. SUB-MODEL: SETTINGS (Nullable)
// -----------------------------------------------------------------------------

@immutable
class UserSettings {
  final bool? isAddCalorieBurn;
  final bool? isRollover;
  final MeasurementUnit? measurementUnit;

  const UserSettings({
    this.isAddCalorieBurn,
    this.isRollover,
    this.measurementUnit
  });

  Map<String, dynamic> toJson() => {
    'isAddCalorieBurn': isAddCalorieBurn,
    'isRollover': isRollover,
    'measurementUnit': measurementUnit?.value ?? MeasurementUnit.metric.value
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      isAddCalorieBurn: json['isAddCalorieBurn'],
      isRollover: json['isRollover'],
      measurementUnit: MeasurementUnit.fromString(json['measurementUnit'] ?? MeasurementUnit.metric.value),
    );
  }

  static const defaultSettings = UserSettings(isRollover: false, isAddCalorieBurn: false, measurementUnit: MeasurementUnit.metric);

  UserSettings copyWith({bool? isAddCalorieBurn, bool? isRollover, MeasurementUnit? measurementUnit}) {
    return UserSettings(
      isAddCalorieBurn: isAddCalorieBurn ?? this.isAddCalorieBurn,
      isRollover: isRollover ?? this.isRollover,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }
}
