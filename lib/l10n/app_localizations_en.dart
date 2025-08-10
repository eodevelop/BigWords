// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get displaySettings => 'Display Settings';

  @override
  String get fontSize => 'Font Size';

  @override
  String get iconSize => 'Icon Size';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get permissionSettings => 'Permission Settings';

  @override
  String get permissionSettingsSubtitle =>
      'Overlay and battery optimization permissions';

  @override
  String get permissionSetup => 'Permission Setup';

  @override
  String get permissionRequired => 'Permissions Required';

  @override
  String get permissionRequiredDescription =>
      'The app needs the following permissions to work properly.';

  @override
  String get overlayPermission => 'Display over other apps';

  @override
  String get overlayPermissionDescription =>
      'Required to quickly launch apps from the home screen.';

  @override
  String get batteryOptimization => 'Battery optimization exemption';

  @override
  String get batteryOptimizationDescription =>
      'Required for stable background operation.';

  @override
  String get complete => 'Complete';

  @override
  String get setPermission => 'Set Permission';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get appManagement => 'App Management';

  @override
  String get cannotLoadAppList => 'Unable to load app list';

  @override
  String get mainScreenApps => 'Main Screen Apps';

  @override
  String get availableApps => 'Available Apps';

  @override
  String get noAppSelected => 'No app selected';

  @override
  String get phone => 'Phone';

  @override
  String get messages => 'Messages';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get kakaoTalk => 'KakaoTalk';

  @override
  String get youtube => 'YouTube';
}
