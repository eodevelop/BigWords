import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 화면 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'화면 설정'**
  String get displaySettings;

  /// 글자 크기 설정
  ///
  /// In ko, this message translates to:
  /// **'글자 크기'**
  String get fontSize;

  /// 아이콘 크기 설정
  ///
  /// In ko, this message translates to:
  /// **'아이콘 크기'**
  String get iconSize;

  /// 테마 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get themeSettings;

  /// 다크 모드 설정
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// 시스템 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get systemSettings;

  /// 권한 설정 메뉴
  ///
  /// In ko, this message translates to:
  /// **'권한 설정'**
  String get permissionSettings;

  /// 권한 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'오버레이 및 배터리 최적화 권한'**
  String get permissionSettingsSubtitle;

  /// 권한 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'권한 설정'**
  String get permissionSetup;

  /// 권한 필요 메시지 제목
  ///
  /// In ko, this message translates to:
  /// **'권한 설정이 필요합니다'**
  String get permissionRequired;

  /// 권한 필요 설명
  ///
  /// In ko, this message translates to:
  /// **'앱이 제대로 작동하려면 아래 권한들이 필요합니다.'**
  String get permissionRequiredDescription;

  /// 오버레이 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'다른 앱 위에 표시'**
  String get overlayPermission;

  /// 오버레이 권한 설명
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에서 빠르게 앱을 실행하기 위해 필요합니다.'**
  String get overlayPermissionDescription;

  /// 배터리 최적화 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'배터리 최적화 제외'**
  String get batteryOptimization;

  /// 배터리 최적화 권한 설명
  ///
  /// In ko, this message translates to:
  /// **'백그라운드에서 안정적으로 실행되기 위해 필요합니다.'**
  String get batteryOptimizationDescription;

  /// 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// 권한 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'권한 설정하기'**
  String get setPermission;

  /// 일반 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get errorOccurred;

  /// 앱 관리 메뉴/화면 제목
  ///
  /// In ko, this message translates to:
  /// **'앱 관리'**
  String get appManagement;

  /// 앱 목록 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'앱 목록을 불러올 수 없습니다'**
  String get cannotLoadAppList;

  /// 메인 화면 앱 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'메인 화면 앱'**
  String get mainScreenApps;

  /// 추가 가능한 앱 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'추가 가능한 앱'**
  String get availableApps;

  /// 앱이 선택되지 않았을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'선택된 앱이 없습니다'**
  String get noAppSelected;

  /// 전화 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'전화'**
  String get phone;

  /// 메시지 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'메시지'**
  String get messages;

  /// 카메라 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'카메라'**
  String get camera;

  /// 갤러리 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'갤러리'**
  String get gallery;

  /// 카카오톡 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'카카오톡'**
  String get kakaoTalk;

  /// 유튜브 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'유튜브'**
  String get youtube;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
