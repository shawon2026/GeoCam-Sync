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
- [ ] Set office location
- [ ] Distance tracking
- [ ] Attendance validation (≤ 50m)

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

The active sample module is `home`:

- `lib/features/home/presentation/...`
- `lib/features/home/domain/...`
- `lib/features/home/data/...`

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
flutter gen-l10n
flutter run
```

### Localization Notes

- ARB files: `lib/l10n/intl_en.arb`, `lib/l10n/intl_bn.arb`
- Generated files come from `flutter gen-l10n`
- `pubspec.yaml` uses `flutter: generate: true`
