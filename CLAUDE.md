# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "big_words" - currently a basic Flutter starter project with a counter demo app. The project uses standard Flutter project structure with Android and iOS platform directories.

## Development Commands

### Running the Application
```bash
flutter run
```

### Testing
```bash
flutter test
```

### Code Analysis and Linting
```bash
flutter analyze
```

### Dependencies Management
```bash
flutter pub get          # Install dependencies
flutter pub upgrade      # Upgrade dependencies
flutter pub outdated     # Check for outdated packages
```

### Building
```bash
flutter build apk        # Build Android APK
flutter build ios        # Build iOS (requires macOS)
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── service/             # State management & business logic services
│   └── utils/               # Utility functions and helpers
├── data/
│   ├── enums/               # Type-safe enumerations
│   ├── models/              # Data classes and entity models
│   ├── repositories/        # Data access layer (Repository pattern)
│   ├── initialization/      # Default data and initialization
│   └── theme/               # UI themes and styling
├── l10n/                    # Localization files (ARB format)
│   ├── app_ko.arb           # Korean translations
│   └── app_en.arb           # English translations
└── ui/
    ├── screens/             # Main application screens
    ├── widgets/             # Reusable UI components
    └── dialog/              # Modal dialogs and overlays
```

### High-level Structure
- `lib/main.dart` - Main application entry point
- `test/widget_test.dart` - Widget tests for the main app
- `pubspec.yaml` - Project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration using flutter_lints
- `android/` - Android-specific configuration and build files
- `ios/` - iOS-specific configuration and build files

## Key Dependencies

- `flutter` - Flutter SDK
- `flutter_localizations` - Internationalization support
- `intl` - Localization and date/time formatting
- `cupertino_icons` - iOS-style icons
- `flutter_riverpod` - State management
- `freezed` - Code generation for immutable classes
- `shared_preferences` - Local storage
- `flutter_test` - Testing framework
- `flutter_lints` - Linting rules for Flutter projects

## Architecture Notes

Currently uses the default Flutter application structure:
- `MyApp` - Root application widget with MaterialApp
- `MyHomePage` - Stateful widget with counter functionality
- Standard Material Design theme with deep purple color scheme

## Development Environment

- Flutter SDK version: ^3.7.0
- Uses Material Design components
- Configured with flutter_lints for code quality

## Coding Standards and Guidelines

### Dart Development Principles

#### Core Rules
- Always declare types for all variables and functions (including parameters and return values)
- Avoid using `any` type - create specific types when needed
- Minimize empty lines within functions
- Use only one export per file
- Follow Flutter/Dart official documentation standards (@Docs references preferred)

#### Naming Conventions
- Classes: PascalCase
- Variables, functions, methods: camelCase
- Files and directories: underscores_case
- Environment variables: UPPERCASE
- Define constants instead of magic numbers
- Functions should start with verbs
- Boolean variables should use prefixes like `is`, `has`, `can`
- Use complete words instead of abbreviations (except standard ones like API, URL)

#### Data Management
- Encapsulate data with composite types instead of primitives
- Use classes with internal validation instead of function validation
- Prefer data immutability
- Use `readonly` for unchanging data
- Use `as const` for unchanging literals

#### Class Design
- Follow SOLID principles
- Prefer composition over inheritance
- Declare interfaces to define contracts
- Write small, focused classes:
  - Less than 200 lines
  - Less than 10 public methods
  - Less than 10 properties

### Flutter Architecture Patterns

#### Project Organization
- `services/` - Business logic services
- `repositories/` - Data persistence management
- `entities/` - Data models
- `cache/` - Data caching management

#### State Management
- Use Riverpod for state management
- Use `keepAlive` for state persistence
- Use freezed for UI state management
- Use controller pattern with Riverpod for business logic
- Controllers should always take methods as input and update UI state

#### Dependency Management (getIt)
- Services and repositories: use singleton
- Use cases: use factory
- Controllers: use lazy singleton

#### UI Optimization
- Break down into small, reusable components
- Avoid deeply nested widget structures
- Use const constructors extensively to reduce rebuilds
- Use recommended methods instead of deprecated ones (avoid `withOpacity`, etc.)

### Testing Guidelines
- Use Flutter's standard widget testing
- Use integration tests for each API module

## Localization

The app supports multiple languages using Flutter's built-in localization system:

### Configuration
- Translations are stored in `lib/l10n/` directory
- `app_ko.arb` - Korean translations (default)
- `app_en.arb` - English translations
- Language is set at build time in `main.dart` (line 37: `locale: const Locale('ko')`)

### Changing App Language
To release the app in a different language, modify the locale in `lib/main.dart`:
```dart
locale: const Locale('en'),  // For English
locale: const Locale('ko'),  // For Korean (default)
```

### Adding New Translations
1. Add new keys to both ARB files (`app_ko.arb` and `app_en.arb`)
2. Run `flutter gen-l10n` to generate localization code
3. Use `AppLocalizations.of(context)!.keyName` in widgets

### Localization Commands
```bash
flutter gen-l10n         # Generate localization code from ARB files
```

## Version Control Guidelines

### Important Restrictions
- **NEVER perform arbitrary commits or pushes**
- All Git operations require explicit user approval and instruction
- Always check for conflicts with existing codebase before making changes
- Generate prompts with focus on readability (prefer clear, simple language)

## Code Implementation Workflow

### Markdown Template-Based Development

When implementing new features or modifying existing code, follow this workflow:

#### 1. Use the temp/ Directory
- **NEVER modify source files directly**
- Create markdown files in the `/temp/` directory at the project root
- Each file represents ONE source file to be modified or created

#### 2. File Naming Convention
- **Existing files**: `순서숫자_filename.md`
- **New files**: `순서숫자_new_filename.md`
- Examples:
  - `1_main.md` - Modify existing main.dart
  - `2_new_user_model.md` - Create new user_model.dart
  - `3_home_screen.md` - Modify existing home_screen.dart

#### 3. Markdown File Structure
````markdown
# File: lib/path/to/filename.dart

## Type: [MODIFY | CREATE]

## Changes Summary:
- Brief description of what changes
- Dependencies or prerequisites

## Complete Code:
```dart
// Full file content with detailed step-by-step comments
// STEP 1: Description of first change
// STEP 2: Description of second change
import 'package:flutter/material.dart';

class Example {
  // Complete implementation
}
```
````

#### 4. Documentation Requirements
- **Complete file contents** (never snippets)
- **STEP comments** for each modification point
- **All imports** included (even unchanged ones)
- **Clear path** to the actual file location

#### 5. Implementation Order
- Model/Entity classes first
- Repository/Service classes second
- UI/Widget classes last
- Ensure dependency order is correct to avoid compilation errors