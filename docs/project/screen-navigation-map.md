# Screen and Navigation Map

## Why This Exists

This document helps a new reviewer understand:

- what each screen is called
- which route name is used internally
- how to navigate from one screen to another

## Route Table

| Internal Route | Screen Name in App | Entry Point |
| --- | --- | --- |
| `AppRoutes.splash` | Splash | App launch |
| `AppRoutes.home` | Home (`GeoCam Sync`) | Auto from splash |
| `AppRoutes.attendance` | Attendance | Home -> `Open Task 1` |
| `AppRoutes.attendanceHistory` | Attendance History | Attendance app bar history icon |
| `AppRoutes.uploadManager` | Upload Manager | Home -> `Open Task 2` |
| `AppRoutes.cameraPreview` | Camera Preview experience | Upload Manager -> `START NEW UPLOAD BATCH` |

## Navigation Flow (Simple)

1. `Splash` -> `Home`
2. From `Home`:
   - `Open Task 1` -> `Attendance`
   - `Open Task 2` -> `Upload Manager`
3. From `Attendance`:
   - tap history icon -> `Attendance History`
4. From `Upload Manager`:
   - tap `START NEW UPLOAD BATCH` -> permission check -> `Camera Preview`
5. From `Camera Preview`:
   - close button -> back to `Upload Manager`
   - `Upload Batch` -> enqueue captures -> return to `Upload Manager`

## Non-Technical Naming Reference

- `Task 1` means the Attendance feature.
- `Task 2` means the Upload Manager feature.
- `Queue` means photos are saved and waiting for upload.
- `Synced` means upload is completed and recorded in local state.

## User-Facing Home Card Labels

- Card 1:
  - Title: `Geo-Fenced Attendance`
  - Button: `Open Task 1`
- Card 2:
  - Title: `Upload Manager`
  - Button: `Open Task 2`

