# End-to-End User Journey

## Goal

This guide explains the full reviewer journey from app launch to both tasks, using exact screen and button names visible in the app.

## Full Journey

1. Launch app.
2. `Splash` screen appears briefly.
3. App navigates to `Home` (`GeoCam Sync`).
4. On Home, two cards are available:
   - `Geo-Fenced Attendance` with button `Open Task 1`
   - `Upload Manager` with button `Open Task 2`
5. Select one task and follow the corresponding flow.

## Home Screen Labels to Verify

- Header title: `GeoCam Sync`
- Card 1 title: `Geo-Fenced Attendance`
- Card 1 button: `Open Task 1`
- Card 2 title: `Upload Manager`
- Card 2 button: `Open Task 2`

## Task 1 Journey (Attendance)

1. Tap `Open Task 1`.
2. Screen title: `Attendance`.
3. If office location is not set, tap `Set Office Location`.
4. Observe `Live Distance` and range state (`IN RANGE` or `OUT OF RANGE`).
5. If eligible, tap `Mark Attendance` or `Mark Late Attendance`.
6. Open history from the app bar history icon.
7. Screen title: `Attendance History`.

## Task 2 Journey (Upload Manager)

1. Tap `Open Task 2`.
2. Screen title: `Upload Manager`.
3. Tap `START NEW UPLOAD BATCH`.
4. If permission is granted, open camera preview.
5. Capture one or more images.
6. Tap `Upload Batch` to enqueue captured files.
7. Return to `Upload Manager` and monitor queue states.

## What a Reviewer Should Verify

- Home clearly routes to both tasks.
- Task 1 blocks attendance when rules are not satisfied.
- Task 1 allows attendance only when rules are satisfied.
- Task 2 enqueues captures and reflects queue/sync status correctly.
- Task 2 responds correctly to network changes (`Stable`, `Unstable`, `Offline`).

## Where Success and Error Signals Usually Appear

- Success signals:
  - state labels on screen (for example `IN RANGE`, `Synced`)
  - list/history updates
  - queue/summary counters
- Error or blocked signals:
  - gate dialogs (permission/service)
  - snackbar messages for operation failures
  - disabled action buttons when rules are unmet

## Related Docs

- `docs/project/screen-navigation-map.md`
- `docs/task1/task1-testing-guide.md`
- `docs/task2/task2-testing-guide.md`
