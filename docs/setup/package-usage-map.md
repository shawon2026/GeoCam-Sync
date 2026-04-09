# Package Usage Map

This document maps each active package to its practical role in the app and the primary integration points.

## Runtime Dependencies

- `flutter_bloc`
  - Role: Cubit-based state management for feature flows.
  - Used in: `lib/features/attendance/presentation/cubit/attendance_cubit.dart`, `lib/features/upload_manager/presentation/cubit/...`.

- `equatable`
  - Role: Value equality for entities and state classes.
  - Used in: `lib/core/error/failures.dart`, `lib/features/**/domain/entities/*.dart`, `lib/features/**/presentation/cubit/*_state.dart`.

- `dartz`
  - Role: Functional error handling with `Either<Failure, T>`.
  - Used in: `lib/core/usecases/usecase.dart`, domain repositories/use-cases, data repositories.

- `get_it`
  - Role: Service locator and dependency injection container.
  - Used in: `lib/core/di/service_locator.dart`.

- `connectivity_plus`
  - Role: Connectivity stream source for network-state orchestration.
  - Used in: `lib/core/network/connectivity_service.dart`, `lib/core/presentation/widgets/global_network_listener.dart`.

- `location`
  - Role: Location permission checks, service checks, current location, distance stream.
  - Used in: `lib/features/attendance/data/datasources/location_datasource.dart`.

- `permission_handler`
  - Role: Camera permission checks and status handling.
  - Used in: `lib/core/services/camera_permission_service.dart`, `lib/features/upload_manager/presentation/pages/*.dart`.

- `app_settings`
  - Role: Redirect user to app/location settings when permission/service is blocked.
  - Used in: `lib/core/services/app_settings_service.dart`.

- `drift`
  - Role: Typed query layer, table definitions, companions.
  - Used in: `lib/db/tables/*.dart`, `lib/db/app_database.dart`.

- `drift_flutter`
  - Role: Flutter-native Drift database bootstrap.
  - Used in: `lib/db/app_database.dart` via `driftDatabase(...)`.

- `sqlite3_flutter_libs`
  - Role: Native SQLite runtime libraries required by Drift on device.
  - Used by: Drift runtime (indirect dependency, no direct import in app code).

- `shared_preferences`
  - Role: Persisted lightweight local preference storage.
  - Used in: `lib/core/localization/locale_manager.dart` for language selection persistence.

- `camera`
  - Role: Camera controller and photo capture APIs.
  - Used in: `lib/features/upload_manager/data/datasources/camera_datasource.dart`, `camera_preview_view.dart`.

- `path`, `path_provider`
  - Role: File path creation and app directory resolution.
  - Used in: `camera_datasource.dart`, `thumbnail_service.dart`, `local_upload_datasource.dart`.

- `image`
  - Role: Client-side thumbnail generation.
  - Used in: `lib/core/services/thumbnail_service.dart`.

- `flutter_screenutil`
  - Role: Responsive sizing for typography and spacing.
  - Used in: `lib/main.dart`, `lib/core/presentation/widgets/global_text.dart`, `global_appbar.dart`.

- `google_fonts`
  - Role: Consistent typography setup for shared text widget.
  - Used in: `lib/core/presentation/widgets/global_text.dart`.

- `intl`
  - Role: Date formatting and generated localization support.
  - Used in: `lib/core/utils/date_time_helper.dart`, `lib/l10n/app_localizations*.dart`.

- `workmanager`
  - Role: Background task registration for upload processing.
  - Used in: `lib/core/services/background_worker_service.dart`.

## Dev Dependencies

- `flutter_lints`
  - Role: Baseline lint rules for code quality.
  - Used in: `analysis_options.yaml` (`include: package:flutter_lints/flutter.yaml`).

- `build_runner`, `drift_dev`
  - Role: Drift code generation pipeline.
  - Used for: generating and refreshing `lib/db/app_database.g.dart`.

- `flutter_launcher_icons`
  - Role: Launcher icon asset generation for Android/iOS.
  - Configured in: `pubspec.yaml` under `flutter_launcher_icons`.
