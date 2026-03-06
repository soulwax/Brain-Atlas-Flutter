# nyris_neurology

Canvas-first Flutter foundation for a brain-exploration game that runs on mobile and web.

## Core Loop

1. Observe a short case and identify the key symptom pattern.
2. Scan the brain map and commit a hypothesis for the failing region.
3. Launch a repair mission such as `Signal Trace` once the diagnosis fits the case.
4. Validate the behavioral change after repair and read a short causal explanation.
5. Archive the case, unlock connected pathways, and move to the next symptom pattern.

## What Is Implemented

- Responsive Flutter UI for phone and browser.
- Custom `Canvas`-driven brain map with pulsing hotspots and pathway links.
- A playable symptom-first loop with case files, hypothesis testing, repair, validation, and debrief.
- A playable `Signal Trace` microgame that runs as the first repair type on top of the overworld map.
- Curated case catalog with observation notes, scene metrics, and after-repair explanations for the opening brain regions.
- Domain catalog for key brain regions, their functions, and unlock graph.
- Deterministic mission specs for relays, hazards, timing, and corridor width.
- Progression controller with case stages, focus, signal strength, insight, codex notes, and mission-based stabilization.
- Seed gameplay loop that can later drive 3D/WebGL visuals without changing the progression model.

## Recommended Next Gameplay Layer

The current loop now proves the educational structure. The next strong step is mission variety inside the same case system:

- `Signal Trace`: the current routing-and-stability mission.
- `Memory Weave`: reconstruct a route from brief visual exposure before it fades.
- `Motor Sync`: tap or drag in rhythm to fine-tune timing and force output.

That gives different brain regions distinct play patterns without abandoning the case-based diagnosis loop.

## Assets Needed Next

Required to move from foundation to production presentation:

- Segmented brain model for WebGL/3D view.
  - Preferred: low-to-mid poly `.glb` with separate meshes or masks for each target region.
- Case presentation art set.
  - Patient cards, vignette illustrations, or lightweight storyboard panels for observation and validation scenes.
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
- Character or guide portrait for onboarding, debrief narration, and case framing.
- Short motion clips or sprite sheets for signal pulses, unlock bursts, and region stabilization.

## Technical Direction

- Keep the gameplay state in pure Dart so it can drive both `Canvas` and future WebGL scenes.
- Keep the case model separate from repair mechanics so multiple mini-games can validate the same diagnosis loop.
- Use the existing region IDs and graph edges as the source of truth for any future 3D highlighting.
- Add a renderer adapter later for a segmented brain mesh instead of rewriting the game logic.
