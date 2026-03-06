import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../application/brain_expedition_controller.dart';
import '../domain/brain_case_file.dart';
import '../domain/brain_region.dart';
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
  bool _missionOpen = false;

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
        final activeCase = _controller.activeCase;
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
                        final isWide = constraints.maxWidth >= 1140;
                        final mapPanel = _MapPanel(
                          controller: _controller,
                          pulse: _pulseController.value,
                        );
                        final sidePanel = _SidePanel(
                          controller: _controller,
                          onSubmitHypothesis: _controller.submitHypothesis,
                          onLaunchMission: _openMission,
                          onAdvanceCase: _handleAdvanceCase,
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
                                                450,
                                                constraints.maxWidth * 0.35,
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
                              activeCase == null
                                  ? 'The diagnostic slice is complete. Add another case arc or a second repair mechanic next.'
                                  : 'Teaching now happens through symptom, hypothesis, repair, and validation instead of region labels first.',
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
              if (_missionOpen &&
                  activeCase != null &&
                  _controller.selectedRegion != null)
                SignalTraceMissionSheet(
                  region: _controller.selectedRegion!,
                  caseFile: activeCase,
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

  void _openMission() {
    if (!_controller.canLaunchSelectedMission) {
      return;
    }

    setState(() {
      _missionOpen = true;
    });
  }

  void _closeMission() {
    if (!_missionOpen) {
      return;
    }

    setState(() {
      _missionOpen = false;
    });
  }

  void _handleAdvanceCase() {
    _closeMission();
    _controller.advanceCase();
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
                'Diagnose the failing brain circuit from symptoms first, repair it through action, then validate the behavioral change before the explanation lands.',
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
              'Loop: observe, localize, repair, validate.',
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
                  label: const Text('Browse hotspots'),
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
    final activeCase = controller.activeCase;

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
              _StageChip(stage: controller.caseStage),
              if (activeCase != null) Chip(label: Text(activeCase.caseCode)),
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
                  selectedRegionId: controller.selectedRegion?.id,
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
  const _SidePanel({
    required this.controller,
    required this.onSubmitHypothesis,
    required this.onLaunchMission,
    required this.onAdvanceCase,
  });

  final BrainExpeditionController controller;
  final VoidCallback onSubmitHypothesis;
  final VoidCallback onLaunchMission;
  final VoidCallback onAdvanceCase;

  @override
  Widget build(BuildContext context) {
    final activeCase = controller.activeCase;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (activeCase == null)
            _CompletionCard(controller: controller)
          else ...<Widget>[
            _CaseFileCard(
              caseFile: activeCase,
              caseStatus: controller.caseStatus,
            ),
            const SizedBox(height: 16),
            _HypothesisCard(
              controller: controller,
              onSubmitHypothesis: onSubmitHypothesis,
              onLaunchMission: onLaunchMission,
              onAdvanceCase: onAdvanceCase,
            ),
            const SizedBox(height: 16),
            _SceneCard(caseFile: activeCase, stage: controller.caseStage),
          ],
          const SizedBox(height: 16),
          _SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final String entry in controller.activityFeed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '• $entry',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
                    'Archived Learnings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final String entry in controller.codexEntries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '• $entry',
                        style: Theme.of(context).textTheme.bodyMedium,
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

class _CaseFileCard extends StatelessWidget {
  const _CaseFileCard({required this.caseFile, required this.caseStatus});

  final BrainCaseFile caseFile;
  final String caseStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Chip(label: Text(caseFile.caseCode)),
              Text(caseFile.title, style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 14),
          Text(caseFile.presentingProblem, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 14),
          Text(caseFile.observationSummary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 14),
          for (final String note in caseFile.observationNotes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $note', style: theme.textTheme.bodyMedium),
            ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0x99102129),
              border: Border.all(color: const Color(0xFF274A57)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(caseStatus, style: theme.textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

class _HypothesisCard extends StatelessWidget {
  const _HypothesisCard({
    required this.controller,
    required this.onSubmitHypothesis,
    required this.onLaunchMission,
    required this.onAdvanceCase,
  });

  final BrainExpeditionController controller;
  final VoidCallback onSubmitHypothesis;
  final VoidCallback onLaunchMission;
  final VoidCallback onAdvanceCase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedRegion = controller.selectedRegion;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Hypothesis Console', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          if (selectedRegion == null)
            Text(
              'No hypothesis selected yet. Tap a reachable hotspot to compare that region against the current symptom pattern.',
              style: theme.textTheme.bodyMedium,
            )
          else ...<Widget>[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(selectedRegion.name, style: theme.textTheme.titleLarge),
                Chip(label: Text(selectedRegion.discipline.label)),
                if (controller.selectedProgress?.isStabilized ?? false)
                  const Chip(label: Text('Stabilized')),
              ],
            ),
            const SizedBox(height: 12),
            Text(selectedRegion.summary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),
            _StatLine(
              label: 'Attempts',
              value: '${controller.selectedProgress?.attempts ?? 0}',
            ),
            _StatLine(
              label: 'Reward',
              value: '+${selectedRegion.rewardInsight} insight',
            ),
          ],
          const SizedBox(height: 18),
          if (controller.caseStage == BrainCaseStage.investigation)
            FilledButton.icon(
              onPressed: controller.canSubmitHypothesis
                  ? onSubmitHypothesis
                  : null,
              icon: const Icon(Icons.psychology_alt_rounded),
              label: const Text('Test hypothesis'),
            ),
          if (controller.caseStage == BrainCaseStage.repair) ...<Widget>[
            Text('Repair objective', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              controller.selectedMissionPrompt,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text('Signal rule', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              controller.selectedSignalRule,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: controller.canLaunchSelectedMission
                  ? onLaunchMission
                  : null,
              icon: const Icon(Icons.graphic_eq_rounded),
              label: const Text('Launch signal trace'),
            ),
          ],
          if (controller.caseStage == BrainCaseStage.debrief) ...<Widget>[
            Text('Validation archived', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'The behavior has improved. Archive the case to move on to the next symptom pattern.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onAdvanceCase,
              icon: const Icon(Icons.library_add_check_rounded),
              label: const Text('Archive case and continue'),
            ),
          ],
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({required this.caseFile, required this.stage});

  final BrainCaseFile caseFile;
  final BrainCaseStage stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showRestored = stage == BrainCaseStage.debrief;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Behavior Scene', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(
            showRestored
                ? caseFile.validationSummary
                : caseFile.observationSummary,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          for (final CaseSceneMetric metric in caseFile.sceneMetrics)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SceneMetricRow(
                metric: metric,
                showRestored: showRestored,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            showRestored ? 'Why it changed' : 'What to notice',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            showRestored ? caseFile.explanation : caseFile.hypothesisPrompt,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.controller});

  final BrainExpeditionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Opening Arc Complete', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(
            'The first case loop now works end to end: symptom, localization, repair, validation, explanation.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 14),
          Text(
            'Add more cases, more repair types, or a richer scene presentation next. The state model is already shaped around that loop.',
            style: theme.textTheme.bodyMedium,
          ),
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

class _StageChip extends StatelessWidget {
  const _StageChip({required this.stage});

  final BrainCaseStage stage;

  @override
  Widget build(BuildContext context) {
    final (String label, Color accent) = switch (stage) {
      BrainCaseStage.investigation => ('Observe', const Color(0xFF8EB8FF)),
      BrainCaseStage.repair => ('Repair', const Color(0xFF4AD7B1)),
      BrainCaseStage.debrief => ('Validate', const Color(0xFFF3C96C)),
      BrainCaseStage.complete => ('Complete', const Color(0xFFFF8B74)),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: accent.withValues(alpha: 0.14),
        border: Border.all(color: accent.withValues(alpha: 0.42)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(
          label,
          style: TextStyle(color: accent, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _SceneMetricRow extends StatelessWidget {
  const _SceneMetricRow({required this.metric, required this.showRestored});

  final CaseSceneMetric metric;
  final bool showRestored;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0x80102129),
        border: Border.all(color: const Color(0xFF274A57)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(metric.label, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (showRestored)
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      metric.impairedValue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFFFB6A5),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFFF3C96C),
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      metric.restoredValue,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFBFF7E8),
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(metric.impairedValue, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
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
