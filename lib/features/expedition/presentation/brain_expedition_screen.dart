import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../application/brain_expedition_controller.dart';
import '../domain/brain_region.dart';
import '../domain/signal_trace_mission.dart';
import 'widgets/brain_map_canvas.dart';
import 'widgets/signal_trace_mission_sheet.dart';

class BrainExpeditionScreen extends StatefulWidget {
  const BrainExpeditionScreen({super.key});

  @override
  State<BrainExpeditionScreen> createState() => _BrainExpeditionScreenState();
}

class _BrainExpeditionScreenState extends State<BrainExpeditionScreen>
    with SingleTickerProviderStateMixin {
  late final BrainExpeditionController _controller;
  late final AnimationController _pulseController;
  String? _activeMissionRegionId;

  BrainRegion? get _activeMissionRegion {
    final activeMissionRegionId = _activeMissionRegionId;
    if (activeMissionRegionId == null) {
      return null;
    }

    for (final BrainRegion region in _controller.regions) {
      if (region.id == activeMissionRegionId) {
        return region;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _controller = BrainExpeditionController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mergedListenable = Listenable.merge(<Listenable>[
      _controller,
      _pulseController,
    ]);

    return AnimatedBuilder(
      animation: mergedListenable,
      builder: (BuildContext context, Widget? child) {
        final activeMissionRegion = _activeMissionRegion;
        final theme = Theme.of(context);

        return Scaffold(
          body: Stack(
            children: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFF061017),
                      Color(0xFF0B1D26),
                      Color(0xFF10232D),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final isWide = constraints.maxWidth >= 1120;
                        final mapPanel = _MapPanel(
                          controller: _controller,
                          pulse: _pulseController.value,
                        );
                        final sidePanel = _SidePanel(
                          controller: _controller,
                          onLaunchMission: _openMissionForSelectedRegion,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _Header(
                              controller: _controller,
                              onReset: _handleReset,
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: isWide
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(flex: 7, child: mapPanel),
                                        const SizedBox(width: 18),
                                        SizedBox(
                                          width: math
                                              .min(
                                                430,
                                                constraints.maxWidth * 0.33,
                                              )
                                              .toDouble(),
                                          child: sidePanel,
                                        ),
                                      ],
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 440,
                                            child: mapPanel,
                                          ),
                                          const SizedBox(height: 18),
                                          sidePanel,
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'The overworld now hands off to a real mission loop. WebGL can become a presentation layer once the trace mechanic feels right.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF8EA8B4),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (activeMissionRegion != null)
                SignalTraceMissionSheet(
                  region: activeMissionRegion,
                  focus: _controller.focus,
                  signalStrength: _controller.signalStrength,
                  onMissionSuccess: (double integrity) {
                    _controller.completeSelectedMission(integrity: integrity);
                  },
                  onMissionFailure: (String reason) {
                    _controller.failSelectedMission(reason: reason);
                  },
                  onClose: _closeMission,
                ),
            ],
          ),
        );
      },
    );
  }

  void _openMissionForSelectedRegion() {
    if (!_controller.canLaunchSelectedMission) {
      return;
    }

    setState(() {
      _activeMissionRegionId = _controller.selectedRegion.id;
    });
  }

  void _closeMission() {
    if (_activeMissionRegionId == null) {
      return;
    }

    setState(() {
      _activeMissionRegionId = null;
    });
  }

  void _handleReset() {
    _closeMission();
    _controller.reset();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller, required this.onReset});

  final BrainExpeditionController controller;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      runSpacing: 16,
      spacing: 24,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Neural Cartographer', style: theme.textTheme.displaySmall),
              const SizedBox(height: 10),
              Text(
                'Explore a living brain map, launch short signal-trace missions, and stabilize core regions through execution instead of static answers.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  _MetricChip(
                    label: 'Focus',
                    value: '${controller.focus}/4',
                    accent: const Color(0xFF4AD7B1),
                  ),
                  _MetricChip(
                    label: 'Signal',
                    value: '${controller.signalStrength}%',
                    accent: const Color(0xFFF3C96C),
                  ),
                  _MetricChip(
                    label: 'Insight',
                    value: '${controller.insight}',
                    accent: const Color(0xFF8EB8FF),
                  ),
                  _MetricChip(
                    label: 'Streak',
                    value: '${controller.streak}',
                    accent: const Color(0xFFFF8B74),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(controller.progressLabel, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Foundation loop: scan, trace, stabilize, expand.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset expedition'),
                ),
                OutlinedButton.icon(
                  onPressed: controller.jumpToNextFrontier,
                  icon: const Icon(Icons.route_rounded),
                  label: const Text('Next hotspot'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({required this.controller, required this.pulse});

  final BrainExpeditionController controller;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text('Exploration Surface', style: theme.textTheme.titleLarge),
              const Chip(label: Text('Canvas-ready')),
              const Chip(label: Text('Mission loop active')),
              Chip(label: Text('${controller.reachableCount} hotspots online')),
            ],
          ),
          const SizedBox(height: 10),
          Text(controller.missionHeadline, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(controller.missionHint, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 18),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF0F2430), Color(0xFF0A1820)],
                ),
                border: Border.all(color: const Color(0xFF234754)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: BrainMapCanvas(
                  regions: controller.regions,
                  progressByRegion: controller.progressByRegion,
                  selectedRegionId: controller.selectedRegion.id,
                  pulse: pulse,
                  onRegionTap: controller.selectRegion,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const <Widget>[
              _LegendChip(label: 'Reachable', color: Color(0xFF4AD7B1)),
              _LegendChip(label: 'Stabilized', color: Color(0xFFF3C96C)),
              _LegendChip(label: 'Locked', color: Color(0xFF19303A)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.controller, required this.onLaunchMission});

  final BrainExpeditionController controller;
  final VoidCallback onLaunchMission;

  @override
  Widget build(BuildContext context) {
    final region = controller.selectedRegion;
    final progress = controller.selectedProgress;
    final spec = buildSignalTraceMissionSpec(region);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(region.name, style: theme.textTheme.titleLarge),
                    Chip(label: Text(region.discipline.label)),
                    if (progress.isStabilized)
                      const Chip(label: Text('Stabilized')),
                  ],
                ),
                const SizedBox(height: 14),
                Text(region.summary, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 14),
                Text(
                  'Attempts: ${progress.attempts}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Reward: +${region.rewardInsight} insight',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFF3C96C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                if (controller.canLaunchSelectedMission)
                  FilledButton.icon(
                    onPressed: onLaunchMission,
                    icon: const Icon(Icons.graphic_eq_rounded),
                    label: const Text('Launch signal trace'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: controller.jumpToNextFrontier,
                    icon: const Icon(Icons.arrow_outward_rounded),
                    label: const Text('Move to next frontier'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Signal Trace Mission', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  controller.selectedMissionPrompt,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 14),
                Text('Desired signal rule', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  controller.selectedSignalRule,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _StatLine(
                  label: 'Time window',
                  value: '${spec.timeLimit.inSeconds}s',
                ),
                _StatLine(
                  label: 'Noise fields',
                  value: '${spec.noiseZones.length}',
                ),
                _StatLine(
                  label: 'Signal corridor',
                  value: '${(spec.laneWidthFactor * 100).round()}%',
                ),
                _StatLine(label: 'Difficulty', value: '${spec.difficulty}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Gameplay Loop', style: theme.textTheme.titleLarge),
                const SizedBox(height: 14),
                const _LoopStep(
                  index: '01',
                  title: 'Scan the brain map',
                  description:
                      'Tap a reachable hotspot and inspect the role that region plays in the broader network.',
                ),
                const SizedBox(height: 14),
                const _LoopStep(
                  index: '02',
                  title: 'Trace the signal route',
                  description:
                      'Launch a short mission, drag the pulse through every relay, and avoid unstable noise fields.',
                ),
                const SizedBox(height: 14),
                const _LoopStep(
                  index: '03',
                  title: 'Stabilize and expand',
                  description:
                      'Successful traces stabilize the node, boost insight, and expose adjacent pathways for the next run.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Recent Activity', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final String entry in controller.activityFeed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('• $entry', style: theme.textTheme.bodyMedium),
                  ),
              ],
            ),
          ),
          if (controller.codexEntries.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            _SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Unlocked Codex Notes',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final String entry in controller.codexEntries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '• $entry',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xCC0C1A22),
        border: Border.all(color: const Color(0xFF234653)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xCC10222C),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: <InlineSpan>[
              TextSpan(
                text: '$label ',
                style: const TextStyle(color: Color(0xFF9AB2BC)),
              ),
              TextSpan(
                text: value,
                style: TextStyle(color: accent, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x9912222B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF224451)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _LoopStep extends StatelessWidget {
  const _LoopStep({
    required this.index,
    required this.title,
    required this.description,
  });

  final String index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF132A33),
            border: Border.all(color: const Color(0xFF2A5867)),
          ),
          child: Text(
            index,
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFF4AD7B1),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF94AAB4),
              ),
            ),
          ),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
