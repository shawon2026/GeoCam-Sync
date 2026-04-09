# Task 2 Testing Guide (Upload Manager)

## Feature Scope

Task 2 manages camera capture, local queueing, network-aware sync, retry behavior, and local cleanup for synced items.

## Screen and Navigation

- Home card: `Upload Manager`
- Home button: `Open Task 2`
- Main screen title: `Upload Manager`
- Primary action: `START NEW UPLOAD BATCH`
- Camera flow destination: `Camera Preview`

## Test Steps (Happy Path)

1. Open `Task 2`.
2. Tap `START NEW UPLOAD BATCH`.
3. Grant camera permission.
4. Capture one or more photos.
5. Tap `Upload Batch`.
6. Return to Upload Manager.
7. Verify item appears in queue and moves through sync states.

## Expected Success Results

- Batch is created locally.
- Captured files are queued as pending items.
- With stable network, items progress to synced.
- Summary updates (`Total`, `Pending`, `Uploaded`, `Failed`).
- Synced tab allows cleanup actions.

## Detailed Scenario Checklist

### Scenario A: Full Success Path

1. Open `Open Task 2`.
2. Tap `START NEW UPLOAD BATCH`.
3. Grant camera permission.
4. Capture multiple photos.
5. Tap `Upload Batch`.
6. Return to `Upload Manager`.

Expected:

- New queued items appear in `Pending`.
- Sync phase progresses when network is stable.
- Items eventually appear in `Synced`.

### Scenario B: Permission Denied Twice

1. Tap `START NEW UPLOAD BATCH`.
2. Deny camera permission twice.

Expected:

- Camera permission dialog appears.
- Dialog provides route to system settings.
- Returning with granted permission allows opening camera.

### Scenario C: Offline/Unstable Network Waiting

1. Queue at least one upload.
2. Force network to unstable/offline.

Expected:

- Upload does not proceed.
- Queue remains waiting until network recovers.

### Scenario D: Pause and Resume

1. Queue pending uploads.
2. Tap `Pause All`.
3. Tap `Resume All`.

Expected:

- Items stop progressing while paused.
- Items continue progression after resume.

### Scenario E: Synced Item Cleanup

1. Ensure at least one item is in `Synced`.
2. Use `Clear Synced Item` or `Clear All Synced`.

Expected:

- Confirmation dialog appears.
- Confirming removes selected local synced data.

## Error and Blocked Cases

- Camera permission denied twice:
  - Dialog appears
  - User can open settings
- Camera initialization or capture failure:
  - Snackbar error appears
- Queue insertion failure:
  - Snackbar error appears
- Offline/unstable network:
  - Items remain waiting; upload does not proceed
- Upload failure:
  - Item moves to failed/retry path

## Network and Sync Cases to Test

- `Stable`: uploads should progress.
- `Unstable`: queue should pause/wait.
- `Offline`: queue should wait until recovery.
- Pause/resume:
  - Tap `Pause All` then `Resume All`
  - Verify pending flow continues after resume

## Common Issues a Reviewer May Face

- Camera permission denied permanently at OS level.
- Device storage pressure may affect capture/save behavior.
- Slow devices can make preview and queue refresh feel delayed.
- Sync uses simulation in current scope, so behavior is local-prototype oriented.

## Quick Troubleshooting Notes

- If camera does not open after permission change, return to app and retry `START NEW UPLOAD BATCH`.
- If queue seems stuck, verify network label (`Stable`, `Unstable`, `Offline`) on top of Upload Manager.
- If capture fails on emulator, test on a physical device for camera stability.
