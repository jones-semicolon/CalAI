import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health _health = Health();

  /// Call once before any read
  Future<void> init() async {
    await _health.configure();
  }

  /// Ensures all required permissions are granted
  Future<void> ensurePermissions() async {
    // Android system permission
    final activity = await Permission.activityRecognition.request();
    if (!activity.isGranted) {
      throw Exception("ACTIVITY_RECOGNITION denied");
    }

    // Health Connect permission
    final granted = await _health.requestAuthorization(
      [HealthDataType.STEPS],
    );

    if (!granted) {
      throw Exception("Health permission denied");
    }
  }

  /// Fetch today’s steps
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    return await _health.getTotalStepsInInterval(midnight, now) ?? 0;
  }
}
