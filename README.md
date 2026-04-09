# GeoCam Sync

GeoCam Sync is a Flutter technical assessment app that combines two flows in one project: a geo-fenced attendance module and a camera-driven upload manager. The app focuses on offline-first behavior, local persistence, permission handling, and a simple bilingual UI.

## Project Title and Description

- Project title: `GeoCam Sync`
- Description: A feature-first Flutter app for geo-fenced attendance marking and queued photo upload management with local storage, network-aware sync behavior, and Bengali/English localization support.

## Screenshots

### Home
<p align="center">
  <img src="./screenshots/home/1.jpg" alt="Home Screen" width="280" />
</p>

### Task 1: Attendance
<p align="center">
  <img src="screenshots/attendance/1.jpg" alt="Attendance 1" width="220" />
  <img src="screenshots/attendance/2.jpg" alt="Attendance 2" width="220" />
  <img src="screenshots/attendance/3.jpg" alt="Attendance 3" width="220" />
  <img src="screenshots/attendance/4.jpg" alt="Attendance 4" width="220" />
  <img src="screenshots/attendance/5.jpg" alt="Attendance 5" width="220" />
</p>

### Task 2: Upload Manager
<p align="center">
  <img src="screenshots/upload_manager/2.jpg" alt="Upload Manager 1" width="220" />
  <img src="screenshots/upload_manager/3.jpg" alt="Upload Manager 2" width="220" />
  <img src="screenshots/upload_manager/4.jpg" alt="Upload Manager 3" width="220" />
  <img src="screenshots/upload_manager/5.jpg" alt="Upload Manager 4" width="220" />
  <img src="screenshots/upload_manager/6.jpg" alt="Upload Manager 5" width="220" />
</p>

## Project Structure / Approach

This project is organized with a feature-first layered architecture where each active module keeps its `presentation`, `domain`, and `data` responsibilities separate, while `core/` centralizes shared infrastructure such as dependency injection, routing, localization, connectivity handling, and reusable UI building blocks. State orchestration is handled with Cubit, with `AttendanceCubit` driving the geo-fenced attendance flow, `UploadManagerCubit` managing queued upload state, `SyncEngineCubit` coordinating network-aware sync behavior, and `CameraPreviewCubit` controlling the capture, zoom, focus, flash, and gallery-preview lifecycle.

### Layer Breakdown

- `lib/core/` -> shared DI, services, connectivity, localization, widgets, routes, and helpers
- `lib/features/<module>/presentation/` -> screens, widgets, and Cubit state handling
- `lib/features/<module>/domain/` -> entities, repository contracts, and use cases
- `lib/features/<module>/data/` -> datasource and repository implementations
- `lib/db/` -> Drift database, converters, and table definitions

### Active Feature Areas

- `lib/features/home/presentation/...`
- `lib/features/attendance/presentation/...`
- `lib/features/attendance/domain/...`
- `lib/features/attendance/data/...`
- `lib/features/upload_manager/presentation/...`
- `lib/features/upload_manager/domain/...`
- `lib/features/upload_manager/data/...`
- `lib/db/...`

## Core Features

### Attendance

- Set office location from current GPS
- Live distance tracking with range color states
- Attendance validation within allowed radius
- Late attendance handling after configured time
- Daily attendance history from local database

### Upload Manager

- Camera preview and capture flow
- Local batch creation and queueing
- Network-aware sync state handling
- Retry/pause/resume style upload queue behavior
- Thumbnail generation for captured media

## Package Usage

- `flutter_bloc`, `equatable`: feature state and immutable state comparison
- `dartz`: `Either<Failure, T>`-based repository and use-case returns
- `get_it`: dependency graph in `lib/core/di/service_locator.dart`
- `location`: GPS read, permission checks, and live distance stream
- `permission_handler`: camera permission flow
- `app_settings`: open system settings from the app
- `connectivity_plus`: connectivity stream and upload network monitoring
- `drift`, `drift_flutter`, `sqlite3_flutter_libs`: local SQL persistence
- `shared_preferences`: saved language selection
- `camera`, `path`, `path_provider`, `image`: camera capture, pathing, file storage, and thumbnail generation
- `flutter_screenutil`, `google_fonts`: responsive sizing and typography
- `intl`: date/time formatting and generated localization support
- `workmanager`: background upload trigger

## Docs Map

- Full project walkthrough: [docs/project/project-walkthrough.md](docs/project/project-walkthrough.md)
- Flow and coverage reference: [docs/project/flow-and-coverage-reference.md](docs/project/flow-and-coverage-reference.md)
- Package decision: [docs/task1/package-decision.md](docs/task1/package-decision.md)
- Attendance state matrix: [docs/task1/attendance-state-matrix.md](docs/task1/attendance-state-matrix.md)
- Folder structure rationale: [docs/task1/folder-structure-rationale.md](docs/task1/folder-structure-rationale.md)
- Package usage map: [docs/setup/package-usage-map.md](docs/setup/package-usage-map.md)
- Generative AI usage note: [docs/agent-journey/generative-ai-usage.md](docs/agent-journey/generative-ai-usage.md)

## Generative AI Usage

Generative AI was used as an implementation support tool for refactoring, feature shaping, architecture cleanup, and documentation drafting. It was mainly used to speed up repetitive engineering work, review module boundaries, prepare cleanup passes, and refine README/documentation structure rather than to replace manual validation.

Example prompt directions used in this project:

- "Review this Flutter feature module and identify unused data/domain/presentation scaffolding that can be safely removed."
- "Refactor shared app bar behavior so language switcher becomes the default action when no custom action is passed."
- "Scan the app for user-facing hardcoded strings that are missing localization and list only the necessary ones."
- "Convert presentation-layer sizing to `flutter_screenutil` using `.h`, `.w`, `.r`, and `.sp` where appropriate."
- "Group current repository changes into logical conventional commits with scope-based descriptions."

## Toolchain and Prerequisites

The following versions were verified from local terminal on April 9, 2026.

### Verified Versions (Current Machine)

- Flutter: `3.38.3` (stable)
- Dart SDK: `3.10.1` (stable)
- DevTools: `2.51.1`
- Android SDK: `36.1.0` (`platform android-36`, `build-tools 36.1.0`)
- Java: `OpenJDK 21.0.10`

### Minimum Required for This Project

- Flutter SDK compatible with Dart `3.10.1` (from `pubspec.yaml`: `environment: sdk: ^3.10.1`)
- Dart SDK `^3.10.1`
- Android SDK + accepted Android licenses
- JDK 17+ (project Gradle config uses Java 17 compatibility)
- Android device/emulator for running Android build

### Required Commands to Run This App

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### Optional (Only If You Build Linux Desktop)

- `clang++`
- `ninja` (`ninja-build`)
- `libgtk-3-dev`

## How to Run

### Clone and open the project

```bash
git clone <your-repo-url>
cd GeoCam-Sync
```

### Install dependencies and generate files

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Run the app

```bash
flutter run
```

### Notes

- Main localization files: `lib/l10n/intl_en.arb` and `lib/l10n/intl_bn.arb`
- Generated localization is enabled through `flutter: generate: true` in `pubspec.yaml`
- The app currently targets portrait mode only

## App Icon

This project uses `flutter_launcher_icons` to generate Android and iOS launcher icons.

```bash
flutter pub get
dart run flutter_launcher_icons
```
