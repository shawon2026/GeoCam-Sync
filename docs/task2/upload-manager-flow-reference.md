# Task 2 Upload Manager Flow Reference

## Purpose

This document explains Task 2 in practical, non-technical language:

- what Upload Manager does
- how a user navigates through Task 2 screens
- what each button does
- what success and blocked cases look like

## Task 2 Goal

Task 2 helps a user capture photos now and upload them safely later.

If network is unstable, items stay in queue and continue when network becomes stable.

## Task 2 Screen Path

1. Open app.
2. From `Home`, tap `Open Task 2`.
3. User enters `Upload Manager`.
4. Tap `START NEW UPLOAD BATCH`.
5. If camera permission is granted, user enters `Camera Preview`.
6. Capture one or more photos.
7. Tap `Upload Batch` to enqueue files.
8. User returns to `Upload Manager` and sees queue/sync updates.

## User-Facing Labels (Exact)

Home card:

- Title: `Upload Manager`
- Subtitle: `Task 2: Manage upload queue, progress, retries, and sync flow.`
- Button: `Open Task 2`

Upload Manager screen:

- App bar title: `Upload Manager`
- Primary action: `START NEW UPLOAD BATCH`
- Status heading: `NETWORK STATUS`
- Tabs: `Pending (x)`, `Synced (x)`
- Queue actions: `Pause All`, `Resume All`, `Select`, `Select All`, `Unselect All`, `Clear Selected`, `Clear All Synced`

Camera Preview screen:

- Top actions: close, flash toggle, settings
- Capture area actions: gallery preview, capture button, camera switch
- Bottom action: `Upload Batch`

## What Upload Manager Shows

- network condition: `Stable`, `Unstable`, `Offline`
- sync phase: idle/uploading/retrying/waiting/paused/completed
- queue summary: total, pending, uploaded, failed
- pending uploads list and synced uploads list

## Permission Behavior

- First, app checks camera permission.
- If denied, app requests again.
- If still denied, a camera permission dialog appears.
- User can open device settings from dialog and return.
- When permission is granted, camera opens.

## Success Cases

- User captures photos successfully.
- App creates a local upload batch.
- Captured files are added to queue.
- On stable network, queued files move to synced.
- Synced local files can be cleared from storage by user.

## Blocked or Failure Cases

- camera permission denied
- camera initialization/capture failure
- local queue insertion failure
- offline or unstable network (queue waits)
- upload failure (item enters retry/fail path)

## Current Scope Limits

- Upload is currently simulation-based (no real backend API).
- No authentication/account mapping in Task 2.

