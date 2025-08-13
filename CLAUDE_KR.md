# CLAUDE_KR.md

이 파일은 Claude Code (claude.ai/code)가 이 저장소에서 작업할 때 참고하는 한국어 가이드입니다.

## 프로젝트 개요

"big_words"라는 Flutter 애플리케이션입니다. 현재는 카운터 데모 앱이 있는 기본 Flutter 스타터 프로젝트입니다. Android와 iOS 플랫폼 디렉토리가 포함된 표준 Flutter 프로젝트 구조를 사용합니다.

## 개발 명령어

### 애플리케이션 실행
```bash
flutter run
```

### 테스팅
```bash
flutter test
```

### 코드 분석 및 린팅
```bash
flutter analyze
```

### 의존성 관리
```bash
flutter pub get          # 의존성 설치
flutter pub upgrade      # 의존성 업그레이드
flutter pub outdated     # 오래된 패키지 확인
```

### 빌드
```bash
flutter build apk        # Android APK 빌드
flutter build ios        # iOS 빌드 (macOS 필요)
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── core/
│   ├── service/             # 상태 관리 및 비즈니스 로직 서비스
│   └── utils/               # 유틸리티 함수 및 헬퍼
├── data/
│   ├── enums/               # 타입 안전 열거형
│   ├── models/              # 데이터 클래스 및 엔티티 모델
│   ├── repositories/        # 데이터 접근 레이어 (Repository 패턴)
│   ├── initialization/      # 기본 데이터 및 초기화
│   └── theme/               # UI 테마 및 스타일링
└── ui/
    ├── screens/             # 메인 애플리케이션 화면
    ├── widgets/             # 재사용 가능한 UI 컴포넌트
    └── dialog/              # 모달 다이얼로그 및 오버레이
```

### 상위 레벨 구조
- `lib/main.dart` - 메인 애플리케이션 진입점
- `test/widget_test.dart` - 메인 앱의 위젯 테스트
- `pubspec.yaml` - 프로젝트 설정 및 의존성
- `analysis_options.yaml` - flutter_lints를 사용한 Dart 분석기 설정
- `android/` - Android 관련 설정 및 빌드 파일
- `ios/` - iOS 관련 설정 및 빌드 파일

## 주요 의존성

- `flutter` - Flutter SDK
- `cupertino_icons` - iOS 스타일 아이콘
- `flutter_test` - 테스팅 프레임워크
- `flutter_lints` - Flutter 프로젝트용 린트 규칙

## 아키텍처 노트

현재 기본 Flutter 애플리케이션 구조를 사용합니다:
- `MyApp` - MaterialApp이 있는 루트 애플리케이션 위젯
- `MyHomePage` - 카운터 기능이 있는 Stateful 위젯
- 딥 퍼플 색상 스키마를 사용한 표준 Material Design 테마

## 개발 환경

- Flutter SDK 버전: ^3.7.0
- Material Design 컴포넌트 사용
- flutter_lints로 코드 품질 관리

## 코딩 표준 및 가이드라인

### Dart 개발 원칙

#### 핵심 규칙
- 모든 변수와 함수에 대해 항상 타입을 선언하세요 (매개변수와 반환값 포함)
- `any` 타입 사용을 피하고 필요시 구체적인 타입을 생성하세요
- 함수 내에서 빈 줄을 최소화하세요
- 파일당 하나의 export만 사용하세요
- Flutter/Dart 공식 문서 표준을 따르세요 (@Docs 참조 선호)

#### 명명 규칙
- 클래스: PascalCase
- 변수, 함수, 메서드: camelCase
- 파일과 디렉토리: underscores_case
- 환경 변수: UPPERCASE
- 매직 넘버 대신 상수를 정의하세요
- 함수는 동사로 시작해야 합니다
- 불린 변수는 `is`, `has`, `can` 같은 접두사를 사용하세요
- 축약어 대신 완전한 단어를 사용하세요 (API, URL 같은 표준 축약어 제외)

#### 데이터 관리
- 원시 타입 대신 복합 타입으로 데이터를 캡슐화하세요
- 함수 검증 대신 내부 검증이 있는 클래스를 사용하세요
- 데이터 불변성을 선호하세요
- 변경되지 않는 데이터에는 `readonly`를 사용하세요
- 변경되지 않는 리터럴에는 `as const`를 사용하세요

#### 클래스 설계
- SOLID 원칙을 따르세요
- 상속보다 컴포지션을 선호하세요
- 계약을 정의하기 위해 인터페이스를 선언하세요
- 작고 집중된 클래스를 작성하세요:
  - 200줄 미만
  - 공개 메서드 10개 미만
  - 프로퍼티 10개 미만

### Flutter 아키텍처 패턴

#### 프로젝트 구성
- `services/` - 비즈니스 로직 서비스
- `repositories/` - 데이터 지속성 관리
- `entities/` - 데이터 모델
- `cache/` - 데이터 캐싱 관리

#### 상태 관리
- 상태 관리에 Riverpod 사용
- 상태 지속성에 `keepAlive` 사용
- UI 상태 관리에 freezed 사용
- 비즈니스 로직에 Riverpod과 컨트롤러 패턴 사용
- 컨트롤러는 항상 메서드를 입력으로 받고 UI 상태를 업데이트해야 합니다

#### 의존성 관리 (getIt)
- 서비스와 레포지토리: singleton 사용
- 사용 사례: factory 사용
- 컨트롤러: lazy singleton 사용

#### UI 최적화
- 작고 재사용 가능한 컴포넌트로 분해하세요
- 깊게 중첩된 위젯 구조를 피하세요
- 리빌드를 줄이기 위해 const 생성자를 광범위하게 사용하세요
- deprecated 메서드 대신 권장 메서드를 사용하세요 (`withOpacity` 등 피하기)

### 테스팅 가이드라인
- Flutter의 표준 위젯 테스팅 사용
- 각 API 모듈에 대해 통합 테스트 사용

## 버전 관리 가이드라인

### 중요한 제한사항
- **절대로 임의의 commit이나 push를 수행하지 마세요**
- 모든 Git 작업은 명시적인 사용자 승인과 지시가 필요합니다
- 변경사항을 만들기 전에 항상 기존 코드베이스와의 충돌을 확인하세요
- 가독성에 중점을 둔 명확하고 간단한 언어로 프롬프트를 생성하세요

## 코드 구현 워크플로우

### 마크다운 템플릿 기반 개발

새로운 기능을 구현하거나 기존 코드를 수정할 때 다음 워크플로우를 따르세요:

#### 1. temp/ 디렉토리 사용
- **절대로 소스 파일을 직접 수정하지 마세요**
- 프로젝트 루트의 `/temp/` 디렉토리에 마크다운 파일을 생성하세요
- 각 파일은 수정하거나 생성할 소스 파일 하나를 나타냅니다

#### 2. 파일 명명 규칙
- **기존 파일 수정**: `순서숫자_파일명.md`
- **새 파일 생성**: `순서숫자_new_파일명.md`
- 예시:
  - `1_main.md` - 기존 main.dart 수정
  - `2_new_user_model.md` - 새 user_model.dart 생성
  - `3_home_screen.md` - 기존 home_screen.dart 수정

#### 3. 마크다운 파일 구조
````markdown
# 파일: lib/path/to/filename.dart

## 타입: [수정 | 생성]

## 변경 요약:
- 변경사항에 대한 간단한 설명
- 의존성 또는 전제조건

## 전체 코드:
```dart
// 단계별 상세 주석이 포함된 전체 파일 내용
// STEP 1: 첫 번째 변경사항 설명
// STEP 2: 두 번째 변경사항 설명
import 'package:flutter/material.dart';

class Example {
  // 완전한 구현
}
```
````

#### 4. 문서화 요구사항
- **완전한 파일 내용** (스니펫 금지)
- **STEP 주석** 각 수정 지점마다
- **모든 import** 포함 (변경되지 않은 것도)
- **명확한 경로** 실제 파일 위치

#### 5. 구현 순서
- Model/Entity 클래스 먼저
- Repository/Service 클래스 두 번째
- UI/Widget 클래스 마지막
- 컴파일 오류를 피하기 위해 의존성 순서를 정확히 지키세요