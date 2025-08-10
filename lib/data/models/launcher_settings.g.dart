// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launcher_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LauncherSettingsImpl _$$LauncherSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$LauncherSettingsImpl(
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 24.0,
  iconSize: (json['iconSize'] as num?)?.toDouble() ?? 80.0,
  isDarkMode: json['isDarkMode'] as bool? ?? false,
  gridColumns: (json['gridColumns'] as num?)?.toInt() ?? 2,
  showAppNames: json['showAppNames'] as bool? ?? true,
);

Map<String, dynamic> _$$LauncherSettingsImplToJson(
  _$LauncherSettingsImpl instance,
) => <String, dynamic>{
  'fontSize': instance.fontSize,
  'iconSize': instance.iconSize,
  'isDarkMode': instance.isDarkMode,
  'gridColumns': instance.gridColumns,
  'showAppNames': instance.showAppNames,
};
