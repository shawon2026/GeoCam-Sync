# Task 1 Attendance State Matrix

## Entry Gate
1. Check location permission.
2. Check location service.
3. If either fails, show blocked state and redirect action.

## Runtime Rules
- In-range threshold: `<= 50m`
- Late threshold: `after 10:30 AM`
- One attendance record per day

## Decision Matrix
- Out of range + not marked (before late): action disabled, prompt to move within 50m.
- In range + not marked (before late): action enabled, mark as `present`.
- In range + not marked (after late): action enabled, mark as `late`.
- Already marked + in range: show marked status.
- Already marked + out of range: keep marked status, action disabled.

## Persistence
- Daily record key: `yyyy-MM-dd`
- Duplicate prevention: unique day row in drift table.
- History: descending by marked time.
