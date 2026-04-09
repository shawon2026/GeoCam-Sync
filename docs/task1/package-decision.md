# Task 1 Package Decision

## Final Stack
- State Management: `flutter_bloc`, `equatable`
- Location Access & Stream: `location`
- Settings Redirect: `app_settings`
- Local Database: `drift`, `drift_flutter`
- Time Rules: `intl`
- Code Generation: `build_runner`, `drift_dev`

## Why Selected
- `flutter_bloc` + `equatable`
  - Required for deterministic state transitions in permission/service/range/time workflows.
  - Keeps UI rebuild behavior predictable.
- `location`
  - Provides permission checks, service checks, current location, and live location stream in one package.
  - Matches the desired runtime flow for Task 1.
- `app_settings`
  - Focused settings redirection package.
  - Keeps permission service flow light without adding a full permission framework.
- `drift` + `drift_flutter`
  - Structured persistence for daily attendance and office config.
  - Supports query-based history and duplicate prevention.
- `intl`
  - Clean implementation of date keying and late threshold comparisons.

## Why Not Selected
- `geolocator`
  - Not selected because current flow preference is already aligned with `location` API surface.
- `permission_handler`
  - Not selected because this task only needs settings redirection, already covered by `app_settings`.
- `hive`
  - Not selected because Task 1 requires query-driven records/history, better served by SQL-style storage.
- `shared_preferences`
  - Not selected for attendance records/history; used for lightweight flags only.
- `rxdart`
  - Not selected because current stream orchestration is achievable with Cubit + base streams.
