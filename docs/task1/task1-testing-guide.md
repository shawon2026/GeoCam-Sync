# Task 1 Testing Guide (Geo-Fenced Attendance)

## Feature Scope

Task 1 validates whether attendance can be marked based on permission, location service, office location, distance, time, and daily duplicate rules.

## Screen and Navigation

- Home card: `Geo-Fenced Attendance`
- Home button: `Open Task 1`
- Main screen title: `Attendance`
- History screen title: `Attendance History`

## Core Rules to Validate

- In-range threshold: `<= 50m`
- Late threshold: after `10:30 AM`
- One attendance record per day

## Test Steps (Happy Path)

1. Open `Task 1`.
2. Grant location permission.
3. Ensure location service is enabled.
4. Tap `Set Office Location`.
5. Move/stay within `<= 50m` of office location.
6. Tap `Mark Attendance` (or `Mark Late Attendance` after late threshold).
7. Open history and verify a new record appears.

## Expected Success Results

- Action button becomes enabled only when eligible.
- Record is saved once for the day.
- History shows the new record with time and distance.
- If late, status appears as late attendance.

## Detailed Scenario Checklist

### Scenario A: First-Time Success (In Range, Before Late Threshold)

1. Open `Open Task 1`.
2. Grant location permission.
3. Enable location service.
4. Tap `Set Office Location`.
5. Stay inside `<= 50m`.
6. Tap `Mark Attendance`.

Expected:

- Status becomes marked.
- Action is no longer available for duplicate marking today.
- Entry appears in `Attendance History`.

### Scenario B: Late Attendance Success (In Range, After 10:30 AM)

1. Ensure current time is after `10:30 AM`.
2. Stay inside `<= 50m`.
3. Tap attendance action.

Expected:

- Action label/behavior reflects late marking.
- Saved record is stored as late attendance.

### Scenario C: Out-of-Range Block

1. Keep distance above `50m`.
2. Open task and wait for distance refresh.

Expected:

- `OUT OF RANGE` style appears.
- Attendance action remains disabled.
- Guidance text asks user to move within range.

### Scenario D: Permission Block

1. Deny location permission from system prompt.

Expected:

- App shows `Location Permission Required`.
- User sees settings redirect action.

### Scenario E: Service Block

1. Turn off device location service.

Expected:

- App shows `Location Service Required`.
- User sees settings redirect action.

### Scenario F: Already Marked Today

1. Mark attendance once.
2. Try again on same day.

Expected:

- Duplicate marking is prevented.
- Existing marked state remains visible.

## Error and Blocked Cases

- Permission denied:
  - App shows `Location Permission Required`
  - Action redirects to settings
- Location service disabled:
  - App shows `Location Service Required`
  - Action redirects to settings
- Office location not set:
  - Attendance action stays blocked
- Out of range:
  - Attendance action disabled with guidance message
- Already marked today:
  - Action blocked and status shown as already marked

## Common Issues a Reviewer May Face

- GPS drift causes distance to fluctuate near boundary.
- Indoor environment can reduce location accuracy.
- Emulator location setup may not represent real movement well.
- System permission changes require returning to app foreground to refresh state.

## Quick Troubleshooting Notes

- If state does not refresh after settings change, background and reopen the app.
- If distance behaves unexpectedly, move outdoors and recheck GPS accuracy.
- If no history appears after marking, verify that marking was actually enabled and tapped in range.
