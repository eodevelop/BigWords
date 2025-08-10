# 다국어 지원 가이드 (Localization Guide)

## 개요
이 앱은 Flutter의 내장 다국어 시스템을 사용하여 한국어와 영어를 지원합니다.

## 현재 지원 언어
- 한국어 (ko) - 기본값
- 영어 (en)

## 언어 변경 방법

### 빌드 시 언어 설정
앱을 특정 언어로 출시하려면 `lib/main.dart` 파일의 37번째 줄을 수정하세요:

```dart
// 한국어 버전 (기본값)
locale: const Locale('ko'),

// 영어 버전
locale: const Locale('en'),
```

## 번역 파일 구조

### 파일 위치
- `lib/l10n/app_ko.arb` - 한국어 번역
- `lib/l10n/app_en.arb` - 영어 번역

### ARB 파일 형식
```json
{
  "@@locale": "ko",
  "settings": "설정",
  "@settings": {
    "description": "설정 화면 제목"
  }
}
```

## 새로운 번역 추가하기

### 1. ARB 파일에 키 추가
두 언어 파일 모두에 새로운 키를 추가합니다:

```json
// app_ko.arb
"newFeature": "새 기능"

// app_en.arb  
"newFeature": "New Feature"
```

### 2. 코드 생성
```bash
flutter gen-l10n
```

### 3. 위젯에서 사용
```dart
Text(AppLocalizations.of(context).newFeature)
```

## 새로운 언어 추가하기

### 1. 새 ARB 파일 생성
`lib/l10n/app_[언어코드].arb` 파일을 생성합니다.

### 2. supportedLocales에 추가
`lib/main.dart`의 supportedLocales 배열에 새 언어를 추가합니다:

```dart
supportedLocales: const [
  Locale('ko'),
  Locale('en'),
  Locale('ja'), // 새로 추가된 일본어
],
```

### 3. 코드 생성
```bash
flutter gen-l10n
```

## 주의사항
- 언어 선택 UI는 의도적으로 제공하지 않습니다
- 각 언어별로 별도의 앱을 빌드하여 출시하는 방식입니다
- 모든 번역 키는 두 언어 파일에 모두 존재해야 합니다