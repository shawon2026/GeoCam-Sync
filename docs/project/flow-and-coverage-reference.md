# Flow and Coverage Reference

## Purpose

This document explains:

- where the user can go in the app
- what each major screen is responsible for
- what checks are performed
- what success, retry, waiting, and failure paths exist
- what is still outside the current scope

## Route Map

Current route entry points:

- Splash
- Home
- Attendance
- Attendance History
- Upload Manager
- Camera Preview

## Screen-by-Screen Reference

### Splash

Responsibilities:

- show app branding
- play loading animation
- move to home automatically after the animation completes

Current behavior:

- no login check
- no token bootstrap
- no onboarding branch

### Home

Responsibilities:

- act as the main navigation hub
- direct the user to Attendance or Upload Manager

### Attendance

Responsibilities:

- initialize attendance gate checks
- load office location
- load today attendance record
- listen to attendance history
- listen to live distance updates
- guide the user through blocked and allowed states

Checks performed:

- location permission
- location service enabled
- precise location quality
- saved office location existence
- current distance from office
- whether attendance is already marked today
- whether current time qualifies as late attendance

Success path:

1. Permission available
2. Service enabled
3. Precise location accepted
4. Office location exists or is created
5. Distance becomes eligible
6. Attendance can be marked
7. Record is saved and reflected in the UI

Blocked path:

- permission denied -> blocked state -> settings redirect
- service disabled -> blocked state -> settings redirect
- precise location unavailable -> blocked state with message
- office location missing -> user must set office location first

Failure path:

- current location unavailable
- office location unavailable at save time
- history stream load failure

Business rules:

- attendance range threshold: based on configured meter limit
- one record per day
- late status is determined by the configured time threshold

### Attendance History

Responsibilities:

- read local attendance records
- render reverse chronological history

Success path:

- records exist -> show history cards

Empty path:

- no records -> show empty state text

Failure path:

- history stream fails -> attendance state enters error state

### Upload Manager

Responsibilities:

- show queue summary
- show network state
- show sync phase
- let the user create a new capture batch
- let the user pause, resume, or clear synced items

Checks performed:

- camera permission
- network stability
- local queue content

Success path:

1. User opens upload manager
2. Sync engine starts background sync setup
3. User creates a new batch
4. Camera permission is granted
5. User captures photos
6. Captures are queued locally
7. Sync engine processes queue when network is stable

Blocked path:

- camera permission denied -> permission dialog -> settings redirect
- unstable or offline network -> queue remains waiting

### Camera Preview

Responsibilities:

- camera initialization
- flash toggle
- lens switching
- zoom control
- focus point update
- local capture creation
- gallery-style preview for captured items
- local batch enqueue

Success path:

- camera initializes
- user captures one or more photos
- captured files are saved locally
- thumbnails are generated
- batch is created
- files are added to queue
- sync processing is triggered

Failure path:

- camera init failure
- capture failure
- zoom update failure
- focus update failure
- camera switch failure
- flash update failure
- batch creation failure
- queue insertion failure

## Sync Engine Reference

The sync engine coordinates local queue processing with current network conditions.

### Network States

- `stable`
- `unstable`
- `offline`

### Sync Phases

- `idle`
- `uploading`
- `retrying`
- `waiting`
- `paused`
- `completed`

### Upload Processing Logic

When the network is stable:

1. waiting items become pending again
2. failed items are prepared for retry
3. the first pending item becomes uploading
4. upload is simulated through the remote datasource
5. if successful, the item becomes synced
6. synced source file is removed locally
7. batch counters are updated

When the network is not stable:

- pending or active items move into waiting state
- sync status message reflects offline or unstable state

When upload fails:

- current item becomes failed
- retry state is emitted
- the item may be re-queued until retry limit is reached

When the user pauses:

- active, waiting, failed, or pending items move to paused

When the user resumes:

- paused items move back to pending

## Local Storage Reference

The app currently relies on local persistence for core behavior.

Stored locally:

- office location
- attendance records
- upload batches
- upload items
- selected app language

Also handled locally:

- thumbnail file generation
- synced file cleanup
- synced history pruning

## What Has Been Checked In Code

Clearly implemented and checked:

- permission gating
- location service gating
- live distance updates
- duplicate attendance prevention
- late attendance rule
- local attendance history
- camera permission flow
- batch creation
- queue creation
- upload pause/resume/retry/waiting flow
- network quality classification
- synced item cleanup and retention trimming

## What Has Not Been Fully Checked Or Delivered

Not fully delivered in the current codebase:

- real backend upload endpoint
- real server response handling
- authentication and user session control
- admin-managed office setup flow
- analytics or crash reporting integration
- automated widget/integration test coverage for all flows
- final screenshot and release artifact documentation

## Reader Guide

Use this document when you want to answer questions like:

- what happens if permission is denied
- what happens if the internet is weak
- what happens if attendance was already marked
- what the queue does after a capture
- what parts are production-ready and what parts are still prototype-level
