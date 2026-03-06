# Changelog

## 0.3.0 - 2026-03-06

### Added

- Added a `Signal Trace` mission overlay that turns region stabilization into a live drag-and-route microgame.
- Added deterministic mission specs with relay paths, time limits, lane widths, and noise hazards derived from each brain region.
- Added mission outcome handling for success and failure, including integrity scoring and retry flow.

### Changed

- Changed the main gameplay loop from map-plus-answer-selection to map-plus-skill-mission progression.
- Updated the side panel and mission briefings to preview trace difficulty, objectives, and signal rules before launch.

## 0.2.0 - 2026-03-06

### Added

- Added a responsive Flutter game foundation for mobile and web built around exploring and stabilizing brain regions.
- Added a custom canvas brain map with connected hotspots, live selection, and progression feedback.
- Added a reusable domain catalog and controller for region data, unlock flow, score signals, and codex rewards.
- Added project documentation describing the gameplay loop, technical direction, and required art/audio assets.

### Changed

- Replaced the placeholder app entrypoint with a production-oriented exploration shell and themed interface.
