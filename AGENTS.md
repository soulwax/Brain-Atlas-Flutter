# AI Agent Working Guide

This repository uses Flutter and follows a feature-oriented structure.  
This file defines how AI coding agents should operate for safe, consistent, and efficient edits.

## Project Snapshot

- **Framework**: Flutter (Dart)
- **Entry point**: `lib/main.dart`
- **Primary app shell**: `lib/app/brain_expedition_app.dart`
- **Main feature**: `lib/features/expedition`
- **Tests**: `test/`

## Repository Structure (important paths)

- `lib/main.dart` — app bootstrap
- `lib/app/` — app-level composition and theme wiring
- `lib/features/expedition/application/` — controllers/state orchestration
- `lib/features/expedition/domain/` — entities, catalogs, mission specs
- `lib/features/expedition/presentation/` — screens/widgets/canvas rendering
- `test/` — unit/widget tests
- Platform folders (`android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`) should only be touched when explicitly required.

## Agent Goals

1. Make minimal, targeted edits.
2. Preserve gameplay logic and region progression behavior.
3. Keep UI behavior deterministic and responsive.
4. Avoid broad refactors unless requested.
5. Maintain compatibility across mobile + web.

## Editing Rules

- Prefer modifying existing files over introducing new abstractions unless necessary.
- Do not rename public classes/files without explicit need.
- Keep domain logic in `domain/`, orchestration in `application/`, and UI drawing/interaction in `presentation/`.
- Avoid moving business logic into canvas painter classes.
- Keep imports clean and package-relative as currently used in the codebase.
- Do not edit generated or ephemeral folders (e.g., `.dart_tool/`, `build/`, `ios/Flutter/ephemeral/`).

## Flutter/Dart Conventions

- Follow lints from `analysis_options.yaml`.
- Use `const` constructors/widgets where possible.
- Keep widgets focused and composable.
- Prefer immutable models and explicit typing.
- Handle nullability intentionally; avoid `!` unless justified.
- Keep functions short and readable; extract helpers when complexity grows.

## State & Gameplay Safety

When editing expedition gameplay:

- Preserve unlock graph semantics in domain catalog files.
- Keep mission scoring/integrity calculations deterministic.
- Avoid introducing frame-dependent randomness without a seed/control.
- Ensure pointer/drag handling remains smooth for mission overlays.
- Maintain separation between mission state updates and rendering.

## Testing & Validation Checklist

Agents should run or recommend running:

1. `flutter analyze`
2. `flutter test`

For UI/gameplay changes, also validate manually on one mobile target or Chrome:

- Region selection still works.
- Mission launch/complete/fail flows still work.
- Overlay interactions are responsive.
- No visual regressions in canvas map.

## Performance Guardrails

- Avoid unnecessary rebuilds in high-frequency UI paths.
- Be cautious with expensive paint operations inside canvas rendering.
- Reuse objects where practical in animation/paint loops.
- Keep asset loading and parsing outside hot render loops.

## Allowed vs Avoid

### Allowed
- Small feature additions in existing architecture
- Bug fixes with focused scope
- Test additions/updates for changed behavior
- Documentation updates (README, this file)

### Avoid
- Large architectural rewrites without request
- Platform-native changes unless task requires
- Dependency additions unless clearly necessary
- Silent behavior changes to scoring/progression

## Commit/PR Guidance (for agents that create PRs)

- Branch naming: `blackboxai/<short-task-name>`
- Use concise conventional-style commit messages:
  - `feat(expedition): ...`
  - `fix(mission): ...`
  - `refactor(presentation): ...`
  - `test(controller): ...`
  - `docs(agent): ...`

## Quick Task Intake Template

Before editing, summarize:

1. Requested outcome
2. Files likely impacted
3. Risk level (low/medium/high)
4. Validation plan (`analyze`, `test`, manual check)

Then proceed with minimal diff.

## Notes for Future Agents

- Treat `README.md` as product/context reference.
- If behavior is unclear, inspect `application` and `domain` first, then `presentation`.
- For visual bugs, check canvas hit-testing and coordinate transforms before changing game rules.
