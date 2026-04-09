# Task 1 Folder Structure Rationale

## Applied Structure
- `lib/db/`
  - Shared drift database and tables for attendance and office configuration.
- `lib/features/attendance/data/`
  - Datasources: local drift + location runtime source.
  - Models: drift row mapping to domain entities.
  - Repository implementation: feature integration point.
- `lib/features/attendance/domain/`
  - Entities, repository contract, and usecases for business rules.
- `lib/features/attendance/presentation/`
  - Cubit/state for feature state machine.
  - Pages for attendance and history.
  - Reusable widgets under `presentation/widgets`.

## Why This Structure
- Preserves existing clean architecture boundaries in this project.
- Keeps feature-specific logic isolated from other modules.
- Keeps persistence concerns in `data` and behavior rules in `domain`.
- Keeps UI composition in pages while extracting reusable UI blocks into widgets.
