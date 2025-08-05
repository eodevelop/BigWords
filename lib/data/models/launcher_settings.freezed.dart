// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launcher_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LauncherSettings _$LauncherSettingsFromJson(Map<String, dynamic> json) {
  return _LauncherSettings.fromJson(json);
}

/// @nodoc
mixin _$LauncherSettings {
  double get fontSize => throw _privateConstructorUsedError;
  double get iconSize => throw _privateConstructorUsedError;
  bool get isDarkMode => throw _privateConstructorUsedError;
  int get gridColumns => throw _privateConstructorUsedError;
  bool get showAppNames => throw _privateConstructorUsedError;

  /// Serializes this LauncherSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LauncherSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LauncherSettingsCopyWith<LauncherSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LauncherSettingsCopyWith<$Res> {
  factory $LauncherSettingsCopyWith(
    LauncherSettings value,
    $Res Function(LauncherSettings) then,
  ) = _$LauncherSettingsCopyWithImpl<$Res, LauncherSettings>;
  @useResult
  $Res call({
    double fontSize,
    double iconSize,
    bool isDarkMode,
    int gridColumns,
    bool showAppNames,
  });
}

/// @nodoc
class _$LauncherSettingsCopyWithImpl<$Res, $Val extends LauncherSettings>
    implements $LauncherSettingsCopyWith<$Res> {
  _$LauncherSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LauncherSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = null,
    Object? iconSize = null,
    Object? isDarkMode = null,
    Object? gridColumns = null,
    Object? showAppNames = null,
  }) {
    return _then(
      _value.copyWith(
            fontSize:
                null == fontSize
                    ? _value.fontSize
                    : fontSize // ignore: cast_nullable_to_non_nullable
                        as double,
            iconSize:
                null == iconSize
                    ? _value.iconSize
                    : iconSize // ignore: cast_nullable_to_non_nullable
                        as double,
            isDarkMode:
                null == isDarkMode
                    ? _value.isDarkMode
                    : isDarkMode // ignore: cast_nullable_to_non_nullable
                        as bool,
            gridColumns:
                null == gridColumns
                    ? _value.gridColumns
                    : gridColumns // ignore: cast_nullable_to_non_nullable
                        as int,
            showAppNames:
                null == showAppNames
                    ? _value.showAppNames
                    : showAppNames // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LauncherSettingsImplCopyWith<$Res>
    implements $LauncherSettingsCopyWith<$Res> {
  factory _$$LauncherSettingsImplCopyWith(
    _$LauncherSettingsImpl value,
    $Res Function(_$LauncherSettingsImpl) then,
  ) = __$$LauncherSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double fontSize,
    double iconSize,
    bool isDarkMode,
    int gridColumns,
    bool showAppNames,
  });
}

/// @nodoc
class __$$LauncherSettingsImplCopyWithImpl<$Res>
    extends _$LauncherSettingsCopyWithImpl<$Res, _$LauncherSettingsImpl>
    implements _$$LauncherSettingsImplCopyWith<$Res> {
  __$$LauncherSettingsImplCopyWithImpl(
    _$LauncherSettingsImpl _value,
    $Res Function(_$LauncherSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LauncherSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = null,
    Object? iconSize = null,
    Object? isDarkMode = null,
    Object? gridColumns = null,
    Object? showAppNames = null,
  }) {
    return _then(
      _$LauncherSettingsImpl(
        fontSize:
            null == fontSize
                ? _value.fontSize
                : fontSize // ignore: cast_nullable_to_non_nullable
                    as double,
        iconSize:
            null == iconSize
                ? _value.iconSize
                : iconSize // ignore: cast_nullable_to_non_nullable
                    as double,
        isDarkMode:
            null == isDarkMode
                ? _value.isDarkMode
                : isDarkMode // ignore: cast_nullable_to_non_nullable
                    as bool,
        gridColumns:
            null == gridColumns
                ? _value.gridColumns
                : gridColumns // ignore: cast_nullable_to_non_nullable
                    as int,
        showAppNames:
            null == showAppNames
                ? _value.showAppNames
                : showAppNames // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LauncherSettingsImpl implements _LauncherSettings {
  const _$LauncherSettingsImpl({
    this.fontSize = 24.0,
    this.iconSize = 80.0,
    this.isDarkMode = false,
    this.gridColumns = 4,
    this.showAppNames = true,
  });

  factory _$LauncherSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LauncherSettingsImplFromJson(json);

  @override
  @JsonKey()
  final double fontSize;
  @override
  @JsonKey()
  final double iconSize;
  @override
  @JsonKey()
  final bool isDarkMode;
  @override
  @JsonKey()
  final int gridColumns;
  @override
  @JsonKey()
  final bool showAppNames;

  @override
  String toString() {
    return 'LauncherSettings(fontSize: $fontSize, iconSize: $iconSize, isDarkMode: $isDarkMode, gridColumns: $gridColumns, showAppNames: $showAppNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LauncherSettingsImpl &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.iconSize, iconSize) ||
                other.iconSize == iconSize) &&
            (identical(other.isDarkMode, isDarkMode) ||
                other.isDarkMode == isDarkMode) &&
            (identical(other.gridColumns, gridColumns) ||
                other.gridColumns == gridColumns) &&
            (identical(other.showAppNames, showAppNames) ||
                other.showAppNames == showAppNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fontSize,
    iconSize,
    isDarkMode,
    gridColumns,
    showAppNames,
  );

  /// Create a copy of LauncherSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LauncherSettingsImplCopyWith<_$LauncherSettingsImpl> get copyWith =>
      __$$LauncherSettingsImplCopyWithImpl<_$LauncherSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LauncherSettingsImplToJson(this);
  }
}

abstract class _LauncherSettings implements LauncherSettings {
  const factory _LauncherSettings({
    final double fontSize,
    final double iconSize,
    final bool isDarkMode,
    final int gridColumns,
    final bool showAppNames,
  }) = _$LauncherSettingsImpl;

  factory _LauncherSettings.fromJson(Map<String, dynamic> json) =
      _$LauncherSettingsImpl.fromJson;

  @override
  double get fontSize;
  @override
  double get iconSize;
  @override
  bool get isDarkMode;
  @override
  int get gridColumns;
  @override
  bool get showAppNames;

  /// Create a copy of LauncherSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LauncherSettingsImplCopyWith<_$LauncherSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
