# nyris_neurology

Canvas-first Flutter foundation for a brain-exploration game that runs on mobile and web.

## Core Loop

1. Scan the brain map and tap a reachable hotspot.
2. Read the region brief and launch a `Signal Trace` mission for that area.
3. Drag the pulse through relay nodes while staying inside the stable corridor and avoiding noise fields.
4. Stabilize the region to earn insight and unlock connected pathways.
5. Expand through the network until the opening circuit is restored.

## What Is Implemented

- Responsive Flutter UI for phone and browser.
- Custom `Canvas`-driven brain map with pulsing hotspots and pathway links.
- A playable `Signal Trace` microgame that runs as an overlay mission on top of the overworld map.
- Domain catalog for key brain regions, their functions, and unlock graph.
- Deterministic mission specs for relays, hazards, timing, and corridor width.
- Progression controller with focus, signal strength, insight, codex notes, and mission-based stabilization.
- Seed gameplay loop that can later drive 3D/WebGL visuals without changing the progression model.

## Recommended Next Gameplay Layer

The current loop now proves a real vertical slice. The next strong step is mission variety:

- `Signal Trace`: the current routing-and-stability mission.
- `Memory Weave`: reconstruct a route from brief visual exposure before it fades.
- `Motor Sync`: tap or drag in rhythm to fine-tune timing and force output.

That gives different brain regions distinct play patterns instead of re-skinning one mechanic forever.

## Assets Needed Next

Required to move from foundation to production presentation:

- Segmented brain model for WebGL/3D view.
  - Preferred: low-to-mid poly `.glb` with separate meshes or masks for each target region.
- Mission VFX set.
  - Pulse trail, relay activation burst, noise-field distortion, and stabilization flash.
- Region mask set for the 2D map.
  - Preferred: layered `.svg` or transparent `.png` exports for highlight states.
- Background art and texture pass.
  - Neural grid, scanline/noise overlays, and at least one atmospheric scene backdrop.
- UI icon set.
  - Planning, speech, motion, memory, vision, emotion, coordination, locked, stabilized.
- Audio pack.
  - Ambient loop, pulse drag sound, relay hit ticks, stabilize success cue, warning/failure cue.

Helpful but optional for polish:

- Font pair with a strong sci-fi/medical identity for headings and UI labels.
- Character or guide portrait for onboarding and mission narration.
- Short motion clips or sprite sheets for signal pulses, unlock bursts, and region stabilization.

## Technical Direction

- Keep the gameplay state in pure Dart so it can drive both `Canvas` and future WebGL scenes.
- Use the existing region IDs and graph edges as the source of truth for any future 3D highlighting.
- Add a renderer adapter later for a segmented brain mesh instead of rewriting the game logic.
