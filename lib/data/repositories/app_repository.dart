import 'dart:convert';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart' as installed;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_info.dart';

class AppRepository {
  static const String _appsKey = 'launcher_apps';
  final SharedPreferences _prefs;
  
  AppRepository(this._prefs);
  
  Future<List<AppInfo>> getSelectedApps() async {
    final String? appsJson = _prefs.getString(_appsKey);
    if (appsJson == null) {
      return _getDefaultApps();
    }
    
    final List<dynamic> appsList = json.decode(appsJson);
    return appsList.map((json) => AppInfo.fromJson(json)).toList();
  }
  
  Future<void> saveSelectedApps(List<AppInfo> apps) async {
    final String appsJson = json.encode(apps.map((app) => app.toJson()).toList());
    await _prefs.setString(_appsKey, appsJson);
  }
  
  Future<List<installed.AppInfo>> getAllInstalledApps() async {
    final List<installed.AppInfo> apps = await InstalledApps.getInstalledApps(
      true, // excludeSystemApps
      true, // withIcon
    );
    return apps;
  }
  
  List<AppInfo> _getDefaultApps() {
    return [
      const AppInfo(
        packageName: 'com.android.dialer',
        appName: '전화',
        iconPath: null,
        position: 0,
      ),
      const AppInfo(
        packageName: 'com.android.mms',
        appName: '메시지',
        iconPath: null,
        position: 1,
      ),
      const AppInfo(
        packageName: 'com.kakao.talk',
        appName: '카카오톡',
        iconPath: null,
        position: 2,
      ),
      const AppInfo(
        packageName: 'com.android.camera',
        appName: '카메라',
        iconPath: null,
        position: 3,
      ),
    ];
  }
}