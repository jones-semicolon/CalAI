import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeWidgetPermissionSettingsService {
  static const MethodChannel _channel = MethodChannel('calai/permissions');

  static Future<bool> openSpecialPermissions() async {
    try {
      final opened = await _channel.invokeMethod<bool>(
        'openSpecialPermissions',
      );
      if (opened == true) return true;
    } catch (_) {
      // Fallback handled below.
    }

    return openAppSettings();
  }
}
