# GeoCam Sync Project Walkthrough

## What This App Is

GeoCam Sync is a two-part Flutter app:

- a geo-fenced attendance flow
- a camera-based upload manager flow

The app is designed to be easy to operate from a simple home screen. One part helps a user mark attendance only when the right location conditions are met. The other part helps a user capture photos, place them into a local queue, and let the app sync them based on network quality.

## What A User Sees First

When the app opens:

1. A splash screen is shown.
2. After the loading animation finishes, the app moves to the home screen.
3. The home screen gives two primary choices:
   - Geo-Fenced Attendance
   - Upload Manager

There is no login flow in the current app. The app opens directly into the main experience.

## Main User Navigation

### Home Screen

The home screen acts as the entry hub for the whole app.

From here, the user can go to:

- Attendance
- Upload Manager

### Attendance Flow

The attendance flow is focused on one question:

"Can the user mark attendance right now?"

To answer that, the app checks:

- location permission
- device location service
- precise location quality
- whether office location is already set
- current distance from the office location
- whether attendance for today was already marked
- whether the current time should be treated as late attendance

If office location is not set yet, the user can save the current location as office location.

If the user is inside the allowed range, the attendance action becomes available.

If the user is outside the allowed range, the app explains that attendance is not available yet.

If the user already marked attendance today, the app keeps that status and prevents duplicate marking.

The user can also open attendance history from the attendance app bar.

### Upload Manager Flow

The upload manager flow is focused on moving captured photos through a local queue until they become synced.

From the upload manager screen, the user can:

- see overall queue summary
- see current network state
- see current sync phase
- start a new upload batch
- pause uploads
- resume uploads
- clear synced local items

When the user starts a new batch:

1. The app checks camera permission.
2. If permission is granted, it opens the camera preview.
3. If permission is denied twice, the app shows a dialog and can redirect the user to settings.

Inside camera preview, the user can:

- capture photos
- zoom
- switch between front and back camera
- change focus point by tapping
- toggle flash
- preview captured items
- delete selected captured items
- enqueue all captured items into an upload batch

After items are queued, the sync engine starts processing them based on network state.

## Success Cases

### Attendance Success Cases

- Permission is granted, service is enabled, and office location is available.
- User is within the allowed range.
- User has not already marked attendance today.
- The app saves either a regular attendance record or a late attendance record.
- Attendance history updates from the local database.

### Upload Manager Success Cases

- Camera permission is granted.
- Camera initializes successfully.
- Photos are captured and stored locally.
- A new upload batch is created.
- Captured files are added into the queue.
- Network becomes stable.
- Queued items move from pending to uploading to synced.
- Synced source file is cleaned up locally after upload completion.

## Error and Blocked Cases

### Attendance Error or Blocked Cases

- Location permission is denied.
- Precise location is not available.
- Device location service is off.
- Current location cannot be read.
- Office location has not been set yet.
- User is outside the allowed attendance range.
- Attendance history cannot be loaded.
- The user has already marked attendance for the current day.

### Upload Manager Error or Blocked Cases

- Camera permission is denied.
- Camera setup fails.
- Capture fails.
- Zoom, focus, flash, or camera switch operation fails.
- Upload batch cannot be created.
- Captured files cannot be queued.
- Network is offline.
- Network exists but is too unstable for upload.
- Upload item fails and must be retried.
- Background sync registration fails.

## What The App Checks Today

### Attendance Checks

- user location permission
- precise location access
- location service enabled state
- live distance from saved office location
- one attendance record per day
- late attendance threshold

### Upload Checks

- camera permission
- current network quality
- queue item state progression
- retry path for failed uploads
- pause and resume behavior
- synced history retention

## What Is Not Fully Implemented Yet

The app is functional as a local workflow prototype, but some production-grade areas are intentionally not complete yet.

Examples:

- no real backend API integration for file upload
- upload flow currently uses a dummy upload simulation
- no authentication or user account flow
- no admin flow for office configuration management
- no remote reporting dashboard
- screenshots and release file links are not filled in yet

## How Non-Technical Reviewers Can Understand The App

If you are not technical, the easiest way to understand the app is this:

- the home screen lets you choose one of two jobs
- the attendance job checks whether you are physically allowed to mark attendance
- the upload manager job lets you collect photos and send them later when the network is good enough

That means the app is mainly about:

- rule-based attendance validation
- local queue management
- network-aware syncing

## Best Supporting Documents

For deeper reading, use these in order:

1. `README.md`
2. `docs/project/project-walkthrough.md`
3. `docs/project/flow-and-coverage-reference.md`
4. `docs/task1/attendance-state-matrix.md`
5. `docs/setup/package-usage-map.md`
