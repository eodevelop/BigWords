import 'package:flutter/foundation.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart' as installed;
import '../../data/models/app_info.dart';
import '../../data/repositories/app_repository.dart';

class AppService {
  final AppRepository _appRepository;
  
  AppService(this._appRepository);
  
  Future<List<AppInfo>> getSelectedApps() async {
    return await _appRepository.getSelectedApps();
  }
  
  Future<void> saveSelectedApps(List<AppInfo> apps) async {
    await _appRepository.saveSelectedApps(apps);
  }
  
  Future<List<installed.AppInfo>> getAllInstalledApps() async {
    return await _appRepository.getAllInstalledApps();
  }
  
  Future<void> launchApp(String packageName) async {
    try {
      if (kDebugMode) {
        print('Attempting to launch app: $packageName');
      }
      
      final isAppInstalled = await InstalledApps.isAppInstalled(packageName);
      
      if (kDebugMode) {
        print('App installed check for $packageName: $isAppInstalled');
      }
      
      if (isAppInstalled == true) {
        final result = await InstalledApps.startApp(packageName);
        if (kDebugMode) {
          print('App launch result for $packageName: $result');
        }
      } else {
        throw Exception('App with package name $packageName is not installed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching app $packageName: $e');
      }
      rethrow;
    }
  }
}