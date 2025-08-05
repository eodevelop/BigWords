import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/app_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'app_service.dart';
import 'settings_service.dart';
import 'permission_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  
  // Repositories
  getIt.registerSingleton<AppRepository>(AppRepository(prefs));
  getIt.registerSingleton<SettingsRepository>(SettingsRepository(prefs));
  
  // Services
  getIt.registerSingleton<AppService>(AppService(getIt<AppRepository>()));
  getIt.registerSingleton<SettingsService>(SettingsService(getIt<SettingsRepository>()));
  getIt.registerSingleton<PermissionService>(PermissionService());
}