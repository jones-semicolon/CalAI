import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/health_service.dart';

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

final stepsTodayProvider = FutureProvider<int>((ref) async {
  final service = ref.read(healthServiceProvider);

  await service.init();
  await service.ensurePermissions();

  return service.getTodaySteps();
});
