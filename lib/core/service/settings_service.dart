import '../../data/models/launcher_settings.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _settingsRepository;
  
  SettingsService(this._settingsRepository);
  
  LauncherSettings getSettings() {
    return _settingsRepository.getSettings();
  }
  
  Future<void> saveSettings(LauncherSettings settings) async {
    await _settingsRepository.saveSettings(settings);
  }
}