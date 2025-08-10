import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/launcher_settings.dart';
import '../service/dependency_injection.dart';
import '../service/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return getIt<SettingsService>();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, LauncherSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsServiceProvider));
});

class SettingsNotifier extends StateNotifier<LauncherSettings> {
  final SettingsService _settingsService;
  
  SettingsNotifier(this._settingsService) : super(const LauncherSettings()) {
    state = _settingsService.getSettings();
  }
  
  Future<void> updateFontSize(double fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _settingsService.saveSettings(state);
  }
  
  Future<void> updateIconSize(double iconSize) async {
    state = state.copyWith(iconSize: iconSize);
    await _settingsService.saveSettings(state);
  }
  
  Future<void> toggleDarkMode() async {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    await _settingsService.saveSettings(state);
  }
}