---
name: geocam-sync-workflow
description: Use when implementing GeoCam Sync feature flows with state-driven rules for splash, attendance, upload manager, and camera preview.
---

# GeoCam Sync Workflow

## When to Use

Use this workflow when a task touches:
- Splash to Home entry flow
- Geo-fenced Attendance flow
- Upload Manager queue and sync flow
- Camera preview and batch upload flow

## Rules

1. Keep feature-first code under `lib/features/<feature_name>/...`.
2. Always run entry-gates before main feature UI:
   permission check first, then required service check.
3. Keep decision logic in state/bloc/domain, not directly in widgets.
4. Drive UI from deterministic state outcomes.
5. Prevent duplicate actions for attendance and upload enqueue.
6. Keep all documentation, code comments, workflow notes, and script messages in English only.

## Build Order

1. Define state matrix and transitions.
2. Implement minimal state and data contracts.
3. Implement UI as a pure renderer of state.
4. Add persistence behavior.
5. Validate with `flutter analyze` and manual flow checks.

## References

- `references/attendance-state-matrix.md`
- `references/upload-manager-rules.md`

## Script

Use `scripts/create_feature_module.sh <feature_name>` for new module scaffolding.
