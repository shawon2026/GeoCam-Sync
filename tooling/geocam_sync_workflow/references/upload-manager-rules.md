# Upload Manager Rules

## Core Behavior

- Queue continues outside Upload Manager screen.
- Queue keeps running when app is backgrounded.
- Engine auto-resumes when network is upload-capable.

## Network States

- Stable: run uploads.
- Unstable: throttle or pause risky uploads.
- Offline: keep files in waiting state.

## Queue and Storage

- Persist only pending/retry files and metadata.
- On successful upload, remove metadata and delete local file.
- Keep failed items in retry state with bounded retry strategy.
- Limit concurrency to 1-2 uploads.

## UI Rules

- Empty state if no files.
- Show summary with overall progress and upload speed.
- Show pending list only when pending count > 0.
- Primary control toggles pause/resume all.
