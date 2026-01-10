import 'package:flutter_riverpod/legacy.dart';

class UserData {
  final String gender;
  final String workOutPerWeek;
  final String social;
  final String hasTriedOtherCalorieApps;
  final double height;
  final double weight;
  final DateTime birthDay;
  final String goal;
  final String dietType;
  final String likeToAccomplish;
  final bool isAddCalorieBurn;
  final bool isRollover;

  const UserData({
    required this.gender,
    required this.workOutPerWeek,
    required this.social,
    required this.hasTriedOtherCalorieApps,
    required this.height,
    required this.weight,
    required this.birthDay,
    required this.goal,
    required this.dietType,
    required this.likeToAccomplish,
    required this.isAddCalorieBurn,
    required this.isRollover,
  });

  UserData copyWith({
    String? gender,
    String? workOutPerWeek,
    String? social,
    String? hasTriedOtherCalorieApps,
    double? height,
    double? weight,
    DateTime? birthDay,
    String? goal,
    String? dietType,
    String? likeToAccomplish,
    bool? isAddCalorieBurn,
    bool? isRollover,
  }) {
    return UserData(
      gender: gender ?? this.gender,
      workOutPerWeek: workOutPerWeek ?? this.workOutPerWeek,
      social: social ?? this.social,
      hasTriedOtherCalorieApps: hasTriedOtherCalorieApps ?? this.hasTriedOtherCalorieApps,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthDay: birthDay ?? this.birthDay,
      goal: goal ?? this.goal,
      dietType: dietType ?? this.dietType,
      likeToAccomplish: likeToAccomplish ?? this.likeToAccomplish,
      isAddCalorieBurn: isAddCalorieBurn ?? this.isAddCalorieBurn,
      isRollover: isRollover ?? this.isRollover,
    );
  }
}

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier()
    : super(
        UserData(
          height: 168,
          weight: 54,
          goal: "",
          gender: "",
          workOutPerWeek: "",
          social: "",
          hasTriedOtherCalorieApps: "",
          birthDay: DateTime(2001, 1, 1),
          dietType: "",
          likeToAccomplish: "",
          isAddCalorieBurn: false,
          isRollover: false,
        ),
      );

  void setGender(String g) => state = state.copyWith(gender: g);
  void setWorkOutPerWeek(String w) => state = state.copyWith(workOutPerWeek: w);
  void setSocial(String s) => state = state.copyWith(social: s);
  void setHasTriedOtherCalorieApps(String h) => state = state.copyWith(hasTriedOtherCalorieApps: h);
  void setHeight(double h) => state = state.copyWith(height: h);
  void setWeight(double w) => state = state.copyWith(weight: w);
  void setBirthDay(DateTime b) => state = state.copyWith(birthDay: b);
  void setGoal(String g) => state = state.copyWith(goal: g);
  void setDietType(String d) => state = state.copyWith(dietType: d);
  void setLikeToAccomplish(String l) => state = state.copyWith(likeToAccomplish: l);
  void setIsAddCalorieBurn(bool b) => state = state.copyWith(isAddCalorieBurn: b);
  void setIsRollover(bool r) => state = state.copyWith(isRollover: r);
}

final userProvider = StateNotifierProvider<UserDataNotifier, UserData>(
  (ref) => UserDataNotifier(),
);
