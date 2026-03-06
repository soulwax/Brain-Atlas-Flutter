# nyris_neurology

Canvas-first Flutter foundation for a brain-exploration game that runs on mobile and web.

## Core Loop

1. Scan the brain map and tap a reachable hotspot.
2. Read the region brief and resolve a short challenge tied to that area's real role.
3. Stabilize the region to earn insight and unlock connected pathways.
4. Expand through the network until the opening circuit is restored.

## What Is Implemented

- Responsive Flutter UI for phone and browser.
- Custom `Canvas`-driven brain map with pulsing hotspots and pathway links.
- Domain catalog for key brain regions, their functions, and unlock graph.
- Progression controller with focus, signal strength, insight, and codex notes.
- Seed gameplay loop that can later drive 3D/WebGL visuals without changing the progression model.

## Recommended Next Gameplay Layer

The current loop proves the exploration flow. The next strong step is a two-phase mission:

- `Explore phase`: navigate the brain map, stabilize regions, and collect region-specific abilities.
- `Challenge phase`: enter a short action/puzzle encounter powered by the unlocked regions, such as tracing a neural pathway, balancing signal timing, or routing memory fragments before noise spreads.

That keeps the game from becoming quiz-only while preserving the educational brain-region framing.

## Assets Needed Next

Required to move from foundation to production presentation:

- Segmented brain model for WebGL/3D view.
  - Preferred: low-to-mid poly `.glb` with separate meshes or masks for each target region.
- Region mask set for the 2D map.
  - Preferred: layered `.svg` or transparent `.png` exports for highlight states.
- Background art and texture pass.
  - Neural grid, scanline/noise overlays, and at least one atmospheric scene backdrop.
- UI icon set.
  - Planning, speech, motion, memory, vision, emotion, coordination, locked, stabilized.
- Audio pack.
  - Ambient loop, hover/tap sounds, stabilize success cue, warning/failure cue.

Helpful but optional for polish:

- Font pair with a strong sci-fi/medical identity for headings and UI labels.
- Character or guide portrait for onboarding and mission narration.
- Short motion clips or sprite sheets for signal pulses, unlock bursts, and region stabilization.

## Technical Direction

- Keep the gameplay state in pure Dart so it can drive both `Canvas` and future WebGL scenes.
- Use the existing region IDs and graph edges as the source of truth for any future 3D highlighting.
- Add a renderer adapter later for a segmented brain mesh instead of rewriting the game logic.
