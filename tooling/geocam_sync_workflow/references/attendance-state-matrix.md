# Attendance State Matrix

## Gate Order

1. Check location permission.
2. If granted, check location service.
3. If both pass, show attendance UI.

## Time and Range Rules

- In-range: `distance <= 50m`
- Normal attendance: up to `10:30`
- Late attendance: after `10:30`, only if in-range
- Early arrival is allowed before `09:00` if in-range

## UI Outcome Summary

- Out-of-range and not marked: disabled action with guidance.
- In-range and not marked:
  - up to `10:30`: `Mark Attendance`
  - after `10:30`: `Mark Late Attendance`
- Marked and in-range: keep enabled, show success.
- Marked and out-of-range: disabled but keep success text.

## Persistence

- One attendance entry per day.
- Prevent duplicate mark for same day.
- Reset attendance state on next day.
