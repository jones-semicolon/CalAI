import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../api/exercise_api.dart';
import '../enums/exercise_enums.dart';
import '../services/calai_firestore_service.dart';
import 'user_provider.dart';

// The state of our logger (Idle, Loading, Success, Error)
enum ExerciseLogStatus { idle, loading, success, error }

class ExerciseLogState {
  final ExerciseLogStatus status;
  final String? errorMessage;

  ExerciseLogState({this.status = ExerciseLogStatus.idle, this.errorMessage});

  ExerciseLogState copyWith({ExerciseLogStatus? status, String? errorMessage}) {
    return ExerciseLogState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ExerciseLogNotifier extends StateNotifier<ExerciseLogState> {
  final Ref ref;
  final ExerciseApi _api = ExerciseApi();

  ExerciseLogNotifier(this.ref) : super(ExerciseLogState());

  Future<void> logExercise({
    required ExerciseType exerciseType,
    required Intensity intensity,
    required int duration,
  }) async {
    state = state.copyWith(status: ExerciseLogStatus.loading);
    debugPrint("Logging exercise...");

    try {
      final user = ref.read(userProvider);
      final double weightKg = user.body.currentWeight > 0 ? user.body.currentWeight : 70.0;

      // 1. Get Calories from API
      // Note: Adjusted to handle the List<ExerciseLog> return we fixed earlier
      final log = await _api.getBurnedCalories(
        weightKg: weightKg,
        exerciseType: exerciseType,
        intensity: intensity,
        durationMins: duration,
      );

      // 2. Save to Firestore
      await ref.read(calaiServiceProvider).logExerciseEntry(
        exercise: log,
      );

      state = state.copyWith(status: ExerciseLogStatus.success);
    } catch (e) {
      state = state.copyWith(status: ExerciseLogStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logExerciseDescription({
    required String description,
  }) async {
    state = state.copyWith(status: ExerciseLogStatus.loading);

    try {
      final user = ref.read(userProvider);
      final double weightKg = user.body.currentWeight > 0 ? user.body.currentWeight : 70.0;
      final log = await _api.getBurnedCalories(
        weightKg: weightKg,
        description: description
      );

      // 2. Save to Firestore
      await ref.read(calaiServiceProvider).logExerciseEntry(
        exercise: log,
      );

      state = state.copyWith(status: ExerciseLogStatus.success);
    } catch (e) {
      state = state.copyWith(status: ExerciseLogStatus.error, errorMessage: e.toString());
    }
  }

  void reset() => state = ExerciseLogState();
}

final exerciseLogProvider = StateNotifierProvider<ExerciseLogNotifier, ExerciseLogState>((ref) {
  return ExerciseLogNotifier(ref);
});