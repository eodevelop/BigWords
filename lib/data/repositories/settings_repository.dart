import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/launcher_settings.dart';

class SettingsRepository {
  static const String _settingsKey = 'launcher_settings';
  final SharedPreferences _prefs;
  
  SettingsRepository(this._prefs);
  
  LauncherSettings getSettings() {
    final String? settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson == null) {
      return const LauncherSettings();
    }
    
    return LauncherSettings.fromJson(json.decode(settingsJson));
  }
  
  Future<void> saveSettings(LauncherSettings settings) async {
    await _prefs.setString(_settingsKey, json.encode(settings.toJson()));
  }
}