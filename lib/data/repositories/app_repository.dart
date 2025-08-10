import 'dart:convert';

import 'package:installed_apps/app_info.dart' as installed;
import 'package:installed_apps/installed_apps.dart';
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
    final apps = appsList.map((json) => AppInfo.fromJson(json)).toList();

    // 잘못된 데이터 검증 및 초기화
    bool hasInvalidData = apps.any(
      (app) => app.packageName == app.appName || !app.packageName.contains('.'),
    );

    if (hasInvalidData) {
      await _prefs.remove(_appsKey);
      return _getDefaultApps();
    }

    return apps;
  }

  Future<void> saveSelectedApps(List<AppInfo> apps) async {
    final String appsJson = json.encode(
      apps.map((app) => app.toJson()).toList(),
    );
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
        packageName: 'com.samsung.android.dialer',
        appName: '전화',
        iconPath: null,
        position: 0,
      ),
      const AppInfo(
        packageName: 'com.samsung.android.messaging',
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
        packageName: 'com.sec.android.app.camera',
        appName: '카메라',
        iconPath: null,
        position: 3,
      ),
    ];
  }
}
