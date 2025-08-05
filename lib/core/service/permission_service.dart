import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> checkOverlayPermission() async {
    return await Permission.systemAlertWindow.isGranted;
  }
  
  Future<void> requestOverlayPermission() async {
    if (!await Permission.systemAlertWindow.isGranted) {
      await Permission.systemAlertWindow.request();
    }
  }
  
  Future<bool> checkBatteryOptimization() async {
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }
  
  Future<void> requestBatteryOptimization() async {
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }
  
  Future<void> checkAndRequestAllPermissions() async {
    await requestOverlayPermission();
    await requestBatteryOptimization();
  }
}