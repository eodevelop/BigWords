import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart' as installed;
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