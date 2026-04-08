# Architecture Overview

## Layers

- `core/`: shared utilities and infrastructure
- `features/<module>/presentation`: UI + BLoC
- `features/<module>/domain`: entities, repository contracts, usecases
- `features/<module>/data`: datasource, models, repository implementation

## Current Module

- `home` module is the active reference implementation.

## Data Flow

1. UI/BLoC -> UseCase
2. UseCase -> Repository (domain contract)
3. RepositoryImpl -> Remote/Local datasource
4. Remote datasource -> ApiClient
5. JSON mapping in data models
6. Entity/Failure back to presentation
