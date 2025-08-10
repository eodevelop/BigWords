import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart' as installed;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/app_info.dart';
import '../service/dependency_injection.dart';
import '../service/app_service.dart';

final appServiceProvider = Provider<AppService>((ref) {
  return getIt<AppService>();
});

final selectedAppsProvider = StateNotifierProvider<SelectedAppsNotifier, AsyncValue<List<AppInfo>>>((ref) {
  return SelectedAppsNotifier(ref.watch(appServiceProvider));
});

class SelectedAppsNotifier extends StateNotifier<AsyncValue<List<AppInfo>>> {
  final AppService _appService;
  
  SelectedAppsNotifier(this._appService) : super(const AsyncValue.loading()) {
    loadApps();
  }
  
  Future<void> loadApps() async {
    state = const AsyncValue.loading();
    try {
      final apps = await _appService.getSelectedApps();
      state = AsyncValue.data(apps);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateApps(List<AppInfo> apps) async {
    try {
      await _appService.saveSelectedApps(apps);
      state = AsyncValue.data(apps);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> addApp(AppInfo app) async {
    state.whenData((apps) async {
      final newApps = [...apps, app];
      await updateApps(newApps);
    });
  }
  
  Future<void> removeApp(String packageName) async {
    state.whenData((apps) async {
      final newApps = apps.where((app) => app.packageName != packageName).toList();
      await updateApps(newApps);
    });
  }
}

final installedAppsProvider = FutureProvider<List<installed.AppInfo>>((ref) async {
  final appService = ref.watch(appServiceProvider);
  return await appService.getAllInstalledApps();
});

final appIconCacheProvider = StateNotifierProvider<AppIconCacheNotifier, Map<String, Uint8List>>((ref) {
  return AppIconCacheNotifier();
});

class AppIconCacheNotifier extends StateNotifier<Map<String, Uint8List>> {
  final Map<String, installed.AppInfo> _rawApps = {};
  static const String _cacheKeyPrefix = 'app_icon_';
  bool _isInitialized = false;
  
  AppIconCacheNotifier() : super({}) {
    _loadCachedIcons();
  }
  
  Future<void> _loadCachedIcons() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, Uint8List> cachedIcons = {};
      
      final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKeyPrefix));
      
      for (final key in keys) {
        final packageName = key.substring(_cacheKeyPrefix.length);
        final base64String = prefs.getString(key);
        
        if (base64String != null) {
          try {
            final iconData = base64Decode(base64String);
            cachedIcons[packageName] = Uint8List.fromList(iconData);
          } catch (e) {
            // 잘못된 캐시 데이터는 제거
            await prefs.remove(key);
          }
        }
      }
      
      state = cachedIcons;
      _isInitialized = true;
    } catch (e) {
      _isInitialized = true;
    }
  }
  
  Future<void> cacheApp(installed.AppInfo app) async {
    if (app.icon != null && app.icon!.isNotEmpty) {
      await _loadCachedIcons(); // 캐시가 로드되었는지 확인
      
      _rawApps[app.packageName] = app;
      final iconData = Uint8List.fromList(app.icon!);
      
      // 메모리 캐시 업데이트
      state = {...state, app.packageName: iconData};
      
      // SharedPreferences에 저장
      try {
        final prefs = await SharedPreferences.getInstance();
        final base64String = base64Encode(iconData);
        await prefs.setString(_cacheKeyPrefix + app.packageName, base64String);
      } catch (e) {
        // 캐시 저장 실패는 무시
      }
    }
  }
  
  Uint8List? getCachedIcon(String packageName) {
    return state[packageName];
  }
  
  installed.AppInfo? getRawApp(String packageName) {
    return _rawApps[packageName];
  }
  
  Future<void> cacheApps(List<installed.AppInfo> apps) async {
    await _loadCachedIcons(); // 캐시가 로드되었는지 확인
    
    final Map<String, Uint8List> newIconState = Map<String, Uint8List>.from(state);
    final List<String> newCacheKeys = [];
    final Map<String, String> newCacheData = {};
    
    for (final app in apps) {
      if (app.icon != null && 
          app.icon!.isNotEmpty && 
          !state.containsKey(app.packageName)) {
        
        _rawApps[app.packageName] = app;
        final iconData = Uint8List.fromList(app.icon!);
        newIconState[app.packageName] = iconData;
        
        // SharedPreferences에 저장할 데이터 준비
        final base64String = base64Encode(iconData);
        newCacheKeys.add(app.packageName);
        newCacheData[_cacheKeyPrefix + app.packageName] = base64String;
      }
    }
    
    // 메모리 캐시 업데이트
    state = newIconState;
    
    // SharedPreferences에 일괄 저장
    if (newCacheKeys.isNotEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        for (final entry in newCacheData.entries) {
          await prefs.setString(entry.key, entry.value);
        }
      } catch (e) {
        // 캐시 저장 실패는 무시
      }
    }
  }
  
  bool hasIcon(String packageName) {
    return state.containsKey(packageName);
  }
  
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_cacheKeyPrefix));
      
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      _rawApps.clear();
      state = {};
    } catch (e) {
      // 캐시 클리어 실패는 무시
    }
  }
}