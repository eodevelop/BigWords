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
    await InstalledApps.startApp(packageName);
  }
}