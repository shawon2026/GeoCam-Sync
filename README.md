# GeoCam Sync 🌍📸

A Flutter-based technical assessment project combining a **Geo-Fenced Attendance System** and an **Advanced Camera & Sync Engine**.

---

## 🚧 Status
🚀 Project setup phase — implementation in progress

---

## 🎯 Objective

This project aims to demonstrate:

- Geo-fenced attendance validation (within 50m)
- Custom camera integration
- Offline-first upload system with retry
- Clean Architecture + Repository Pattern
- BLoC/Cubit state management

---

## 🧩 Features

### Attendance
- [x] Set office location from current GPS
- [x] Live distance tracking with range color states
- [x] Attendance validation (≤ 50m)
- [x] Late attendance handling (after 10:30 AM)
- [x] Attendance history from local database

### Camera & Sync
- [ ] Custom camera UI
- [ ] Batch capture
- [ ] Upload queue
- [ ] Retry on network recovery

---

## 🧱 Architecture

This project follows a minimal **Clean Architecture** with feature-first structure.

### Layer Breakdown

- `core/` → shared app-level utilities (network, errors, DI, routes, theme, common helpers)
- `features/<module>/presentation/` → UI + BLoC state
- `features/<module>/domain/` → entities, repository contracts, use cases
- `features/<module>/data/` → datasource, model, repository implementation

### Current Feature Module

The active modules are:

- `lib/features/home/presentation/...`
- `lib/features/home/domain/...`
- `lib/features/home/data/...`
- `lib/features/attendance/presentation/...`
- `lib/features/attendance/domain/...`
- `lib/features/attendance/data/...`
- `lib/db/...` for drift tables and database

### Data Flow (Request → UI)

1. `UI/BLoC` triggers `UseCase`
2. `UseCase` calls `Domain Repository` interface
3. `RepositoryImpl` coordinates remote/local datasource
4. `RemoteDataSource` calls `ApiClient.request(...)`
5. Response JSON is mapped in `data/models`
6. Repository returns `Entity` / `Failure` to domain/presentation

### Model Placement Guideline

Inside `features/<module>/data/models/`, keep models separated by concern:

- `request/` → API request DTOs (`toJson`)
- `response/` → API response DTOs (`fromJson`)
- `local/` → local cache/db DTOs

This keeps API contract and local storage contract clean and scalable.

## ✅ Package Usage (Keypoints)

- `flutter_bloc`, `equatable`: feature state + immutable state comparison (`attendance_cubit`, `upload_manager`, `sync_engine`, `camera_preview`).
- `dartz`: repository/use-case return type as `Either<Failure, T>` (domain and data layers).
- `get_it`: DI and object graph setup in `lib/core/di/service_locator.dart`.
- `location`: GPS read, permission/service checks, and live distance stream in `lib/features/attendance/data/datasources/location_datasource.dart`.
- `permission_handler`: camera permission gate in upload manager screens and permission service.
- `app_settings`: open app/system settings flows (`core/services/app_settings_service.dart`).
- `connectivity_plus`: connectivity stream + network probing (`core/network/connectivity_service.dart`, `global_network_listener.dart`).
- `drift`, `drift_flutter`, `sqlite3_flutter_libs`: local SQL persistence for attendance + upload queue (`lib/db/...`).
- `shared_preferences`: persisted language preference in `lib/core/localization/locale_manager.dart`.
- `camera`, `path`, `path_provider`, `image`: camera capture, file pathing, temp storage, thumbnail generation in upload manager.
- `flutter_screenutil`, `google_fonts`: responsive sizing and typography in global UI widgets.
- `intl`: date/time formatting and localization helpers (`core/utils/date_time_helper.dart`, `l10n` generated classes).
- `workmanager`: background upload trigger (`core/services/background_worker_service.dart`).

### Task 1 Docs
- Package decision: `docs/task1/package-decision.md`
- State matrix: `docs/task1/attendance-state-matrix.md`
- Folder rationale: `docs/task1/folder-structure-rationale.md`
- Full package usage map: `docs/setup/package-usage-map.md`

---

## 📦 Final Build Drop

Final release build artifacts are available in this folder:

- APK path: `release/artifacts/app-release.apk`
- Download APK: [Download Latest Release APK](release/artifacts/app-release.apk)
- Direct download (GitHub raw link format): `https://github.com/<owner>/<repo>/raw/<branch>/release/artifacts/app-release.apk`

---

## ⚡ Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### Localization Notes

- ARB files: `lib/l10n/intl_en.arb`, `lib/l10n/intl_bn.arb`
- Generated files come from `flutter gen-l10n`
- `pubspec.yaml` uses `flutter: generate: true`

## App Icon (Launcher)

This project uses `flutter_launcher_icons` to generate Android and iOS launcher icons.

Quick steps used:

1. Place icon asset at `assets/images/logo.png`
2. Configure in `pubspec.yaml`:
   - `flutter_launcher_icons` in `dev_dependencies`
   - `flutter_launcher_icons` config with:
     - `android: true`
     - `ios: true`
     - `image_path: assets/images/logo.png`
     - `remove_alpha_ios: true`
3. Run:

```bash
flutter pub get
dart run flutter_launcher_icons
```
