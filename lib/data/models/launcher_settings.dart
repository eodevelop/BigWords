import 'package:freezed_annotation/freezed_annotation.dart';

part 'launcher_settings.freezed.dart';
part 'launcher_settings.g.dart';

@freezed
class LauncherSettings with _$LauncherSettings {
  const factory LauncherSettings({
    @Default(24.0) double fontSize,
    @Default(120.0) double iconSize,
    @Default(false) bool isDarkMode,
    @Default(2) int gridColumns,
    @Default(true) bool showAppNames,
  }) = _LauncherSettings;

  factory LauncherSettings.fromJson(Map<String, dynamic> json) =>
      _$LauncherSettingsFromJson(json);
}
