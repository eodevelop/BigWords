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
    // 사용자 앱 가져오기
    final List<installed.AppInfo> userApps =
        await InstalledApps.getInstalledApps(
          true, // excludeSystemApps
          true, // withIcon
        );

    // 필요한 시스템 앱의 패키지명 목록
    final systemAppPackages = [
      'com.samsung.android.dialer',
      'com.samsung.android.messaging',
      'com.sec.android.app.camera',
      'com.sec.android.gallery3d',
      'com.google.android.youtube',
      'com.android.chrome',  // 크롬 브라우저
      'com.samsung.android.internet',  // 삼성 인터넷
      'com.google.android.apps.maps',  // 구글 지도
      'com.samsung.android.calendar',  // 삼성 캘린더
      'com.google.android.calendar',  // 구글 캘린더
      'com.samsung.android.contacts',  // 삼성 연락처
      'com.google.android.contacts',  // 구글 연락처
      'com.sec.android.app.clockpackage',  // 시계/알람
      'com.google.android.deskclock',  // 구글 시계
      'com.sec.android.app.weather',  // 날씨
      'com.sec.android.daemonapp',  // 삼성 날씨
      'com.samsung.android.app.notes',  // 삼성 노트
      'com.samsung.android.app.reminder',  // 리마인더
      'com.sec.android.app.calculator',  // 계산기
      'com.google.android.calculator',  // 구글 계산기
    ];

    // 시스템 앱 포함해서 모든 앱 가져오기
    final List<installed.AppInfo> allApps =
        await InstalledApps.getInstalledApps(
          false, // includeSystemApps
          true, // withIcon
        );

    // 필요한 시스템 앱만 필터링
    final systemApps =
        allApps
            .where((app) => systemAppPackages.contains(app.packageName))
            .toList();

    // 사용자 앱과 필요한 시스템 앱 합치기
    return [...userApps, ...systemApps];
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
        packageName: 'com.sec.android.app.camera',
        appName: '카메라',
        iconPath: null,
        position: 2,
      ),
      const AppInfo(
        packageName: 'com.sec.android.gallery3d',
        appName: '갤러리',
        iconPath: null,
        position: 3,
      ),
      const AppInfo(
        packageName: 'com.kakao.talk',
        appName: '카카오톡',
        iconPath: null,
        position: 4,
      ),
      const AppInfo(
        packageName: 'com.google.android.youtube',
        appName: '유튜브',
        iconPath: null,
        position: 5,
      ),
    ];
  }
}
