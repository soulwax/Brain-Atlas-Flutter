import 'package:flutter/material.dart';

import '../../domain/brain_case_file.dart';
import '../../domain/brain_region.dart';
import '../../domain/signal_trace_mission.dart';

enum SignalTracePhase { briefing, live, success, failure }

class SignalTraceMissionSheet extends StatefulWidget {
  const SignalTraceMissionSheet({
    super.key,
    required this.region,
    required this.caseFile,
    required this.catalog,
    required this.focus,
    required this.signalStrength,
    required this.onMissionSuccess,
    required this.onMissionFailure,
    required this.onClose,
  });

  final BrainRegion region;
  final BrainCaseFile caseFile;
  final List<BrainRegion> catalog;
  final int focus;
  final int signalStrength;
  final ValueChanged<double> onMissionSuccess;
  final ValueChanged<String> onMissionFailure;
  final VoidCallback onClose;

  @override
  State<SignalTraceMissionSheet> createState() =>
      _SignalTraceMissionSheetState();
}

class _SignalTraceMissionSheetState extends State<SignalTraceMissionSheet>
    with SingleTickerProviderStateMixin {
  late final SignalTraceMissionSpec _spec;
  late final Map<String, BrainRegion> _regionById;
  late final AnimationController _timerController;

  SignalTracePhase _phase = SignalTracePhase.briefing;
  final Map<int, String> _assignments = <int, String>{};
  int? _selectedSlotIndex;
  int _placementCount = 0;
  String _status =
      'Study the clue cards first, then rebuild the partner pattern around the target region.';
  String _resultHeadline = '';
  String _resultBody = '';
  List<String> _learningNotes = const <String>[];

  bool get _isLive => _phase == SignalTracePhase.live;
  bool get _isResolved =>
      _phase == SignalTracePhase.success || _phase == SignalTracePhase.failure;

  @override
  void initState() {
    super.initState();
    _regionById = <String, BrainRegion>{
      for (final BrainRegion item in widget.catalog) item.id: item,
    };
    _spec = buildSignalTraceMissionSpec(
      region: widget.region,
      caseFile: widget.caseFile,
      catalog: widget.catalog,
    );
    _timerController = AnimationController(vsync: this, duration: _spec.timeLimit)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed &&
            _phase == SignalTracePhase.live) {
          _resolveFailure(
            'The scan window closed before the circuit pattern was fully rebuilt.',
          );
        }
      });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD9070F13),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: const Color(0xFF091821),
                    border: Border.all(color: const Color(0xFF234653)),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 40,
                        offset: Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(flex: 8, child: _buildPlayfield(theme)),
                              const SizedBox(width: 18),
                              SizedBox(width: 340, child: _buildSidebar(theme)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: 380,
                                child: _buildPlayfield(theme),
                              ),
                              const SizedBox(height: 18),
                              _buildSidebar(theme),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayfield(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF102431), Color(0xFF08131A)],
        ),
        border: Border.all(color: const Color(0xFF244B59)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  'Circuit Pattern Lab',
                  style: theme.textTheme.headlineSmall,
                ),
                Chip(label: Text(widget.caseFile.caseCode)),
                Chip(label: Text('${_spec.timeLimit.inSeconds}s scan window')),
                Chip(label: Text('Pattern ${_spec.slots.length} links')),
                Chip(label: Text('Difficulty ${_spec.difficulty}')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.caseFile.repairObjective,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            AnimatedBuilder(
              animation: _timerController,
              builder: (BuildContext context, Widget? child) {
                return _TimerBar(timerValue: _timerController.value);
              },
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _AnchorCard(region: widget.region),
                    const SizedBox(height: 18),
                    Text('Partner clues', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        for (var index = 0; index < _spec.slots.length; index++)
                          _PatternSlotCard(
                            slot: _spec.slots[index],
                            assignedRegion: _assignments[index] == null
                                ? null
                                : _regionById[_assignments[index]!],
                            isSelected: _selectedSlotIndex == index,
                            isInteractive: _isLive,
                            onTap: () => _handleSlotTap(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Candidate regions',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        for (final String candidateId
                            in _spec.candidateRegionIds)
                          _CandidateRegionCard(
                            region: _regionById[candidateId]!,
                            isAssigned: _assignments.containsValue(candidateId),
                            isInteractive: _isLive,
                            onTap: () => _handleCandidateTap(candidateId),
                          ),
                      ],
                    ),
                    if (_learningNotes.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 20),
                      Text('Circuit notes', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 10),
                      for (final String note in _learningNotes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LearningNoteTile(note: note),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xFF0D1D25),
        border: Border.all(color: const Color(0xFF224552)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.region.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(
                widget.caseFile.presentingProblem,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _HudRow(label: 'Focus reserve', value: '${widget.focus}/4'),
              _HudRow(
                label: 'Signal strength',
                value: '${widget.signalStrength}%',
              ),
              _HudRow(
                label: 'Links placed',
                value: '${_assignments.length}/${_spec.slots.length}',
              ),
              AnimatedBuilder(
                animation: _timerController,
                builder: (BuildContext context, Widget? child) {
                  return _HudRow(
                    label: 'Time left',
                    value: '${_remainingSeconds}s',
                  );
                },
              ),
              const SizedBox(height: 18),
              Text('Pattern objective', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                widget.region.networkRole,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Text('Case anchor', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                widget.caseFile.observationSummary,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Text('Status', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_status, style: theme.textTheme.bodyMedium),
              if (_phase == SignalTracePhase.failure ||
                  _phase == SignalTracePhase.success) ...<Widget>[
                const SizedBox(height: 18),
                Text(_resultHeadline, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(_resultBody, style: theme.textTheme.bodyMedium),
              ],
              if (widget.caseFile.probes.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                Text('Study cue', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  widget.caseFile.probes.first.learningNote,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 18),
              if (_phase == SignalTracePhase.briefing)
                FilledButton.icon(
                  onPressed: _beginMission,
                  icon: const Icon(Icons.psychology_alt_rounded),
                  label: const Text('Begin pattern lab'),
                ),
              if (_phase == SignalTracePhase.live) ...<Widget>[
                FilledButton.icon(
                  onPressed: _validatePattern,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: const Text('Validate pattern'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _clearAssignments,
                  icon: const Icon(Icons.layers_clear_rounded),
                  label: const Text('Clear layout'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Abort mission'),
                ),
              ],
              if (_phase == SignalTracePhase.failure) ...<Widget>[
                FilledButton.icon(
                  onPressed: _resetAttempt,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry pattern'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Return to map'),
                ),
              ],
              if (_phase == SignalTracePhase.success)
                FilledButton.icon(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Return to map'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _beginMission() {
    setState(() {
      _phase = SignalTracePhase.live;
      _assignments.clear();
      _selectedSlotIndex = 0;
      _placementCount = 0;
      _learningNotes = const <String>[];
      _status =
          'Match each clue to the brain region that completes this patient pattern.';
    });
    _timerController.forward(from: 0);
  }

  void _resetAttempt() {
    _timerController.reset();
    setState(() {
      _phase = SignalTracePhase.briefing;
      _assignments.clear();
      _selectedSlotIndex = null;
      _placementCount = 0;
      _status =
          'Study the clue cards first, then rebuild the partner pattern around the target region.';
      _resultHeadline = '';
      _resultBody = '';
      _learningNotes = const <String>[];
    });
  }

  void _handleSlotTap(int index) {
    if (!_isLive) {
      return;
    }

    setState(() {
      if (_selectedSlotIndex == index && _assignments.containsKey(index)) {
        final removedRegion = _regionById[_assignments.remove(index)]!;
        _status =
            '${removedRegion.name} removed. Choose a new region for ${_spec.slots[index].slotLabel.toLowerCase()}.';
      } else {
        _selectedSlotIndex = index;
        _status =
            'Selected ${_spec.slots[index].slotLabel.toLowerCase()}. Choose the matching region card.';
      }
    });
  }

  void _handleCandidateTap(String candidateId) {
    if (!_isLive || _isResolved) {
      return;
    }

    final targetSlot = _selectedSlotIndex ?? _firstOpenSlotIndex;
    if (targetSlot == null) {
      setState(() {
        _status =
            'All clue cards are filled. Validate the pattern or tap a slot to replace a region.';
      });
      return;
    }

    setState(() {
      final existingSlot = _slotForRegion(candidateId);
      if (existingSlot != null) {
        _assignments.remove(existingSlot);
      }
      _assignments[targetSlot] = candidateId;
      _selectedSlotIndex = _nextOpenSlotIndex(after: targetSlot);
      _placementCount += 1;
      final candidate = _regionById[candidateId]!;
      _status = _selectedSlotIndex == null
          ? '${candidate.name} placed. Validate the full partner pattern.'
          : '${candidate.name} placed. Continue with the next clue card.';
    });
  }

  void _clearAssignments() {
    if (!_isLive) {
      return;
    }

    setState(() {
      _assignments.clear();
      _selectedSlotIndex = 0;
      _status =
          'Layout cleared. Rebuild the pattern by matching each clue card again.';
    });
  }

  void _validatePattern() {
    if (!_isLive) {
      return;
    }

    if (_assignments.length != _spec.slots.length) {
      setState(() {
        _status = 'Fill every clue card before validating the circuit pattern.';
      });
      return;
    }

    final mismatchedSlots = <PatternSlotSpec>[
      for (var index = 0; index < _spec.slots.length; index++)
        if (_assignments[index] != _spec.slots[index].regionId)
          _spec.slots[index],
    ];

    if (mismatchedSlots.isEmpty) {
      _resolveSuccess();
      return;
    }

    final mismatchLabels = mismatchedSlots
        .map((PatternSlotSpec slot) => slot.slotLabel.toLowerCase())
        .join(', ');
    _resolveFailure(
      'The $mismatchLabels did not match the case clues. Review the partner roles and try again.',
      slotsToReview: mismatchedSlots,
    );
  }

  void _resolveSuccess() {
    if (_isResolved) {
      return;
    }

    _timerController.stop();
    final integrity = _calculateIntegrity();
    widget.onMissionSuccess(integrity);

    setState(() {
      _phase = SignalTracePhase.success;
      _learningNotes = _spec.slots
          .map((PatternSlotSpec slot) => _buildLearningNote(slot))
          .toList(growable: false);
      _status =
          'Pattern locked. ${widget.region.name} now sits in a clear network.';
      _resultHeadline = 'Pattern restored';
      _resultBody =
          'Pattern integrity reached ${(integrity * 100).round()}%. ${widget.caseFile.validationSummary}';
    });
  }

  void _resolveFailure(
    String reason, {
    List<PatternSlotSpec> slotsToReview = const <PatternSlotSpec>[],
  }) {
    if (_isResolved) {
      return;
    }

    _timerController.stop();
    widget.onMissionFailure(reason);

    setState(() {
      _phase = SignalTracePhase.failure;
      _status = reason;
      _learningNotes = slotsToReview
          .map(_buildLearningNote)
          .toList(growable: false);
      _resultHeadline = 'Pattern incomplete';
      _resultBody =
          'The attempt still cost resources, but the region remains reachable. Review the partner roles and rebuild the pattern again.';
    });
  }

  double _calculateIntegrity() {
    final placementPenalty =
        (0.05 * (_placementCount - _spec.slots.length).clamp(0, 6));
    final timePenalty = _timerController.value * 0.24;

    return (1 - placementPenalty - timePenalty).clamp(0.62, 1.0).toDouble();
  }

  int? get _firstOpenSlotIndex {
    for (var index = 0; index < _spec.slots.length; index++) {
      if (!_assignments.containsKey(index)) {
        return index;
      }
    }

    return null;
  }

  int? _nextOpenSlotIndex({required int after}) {
    for (var offset = 1; offset <= _spec.slots.length; offset++) {
      final nextIndex = (after + offset) % _spec.slots.length;
      if (!_assignments.containsKey(nextIndex)) {
        return nextIndex;
      }
    }

    return null;
  }

  int? _slotForRegion(String regionId) {
    for (final MapEntry<int, String> entry in _assignments.entries) {
      if (entry.value == regionId) {
        return entry.key;
      }
    }

    return null;
  }

  int get _remainingSeconds {
    final remaining = (_spec.timeLimit.inSeconds * (1 - _timerController.value))
        .ceil();
    return remaining.clamp(0, _spec.timeLimit.inSeconds);
  }

  String _buildLearningNote(PatternSlotSpec slot) {
    final partner = _regionById[slot.regionId]!;
    return '${slot.slotLabel}: ${partner.name}. ${slot.learningNote}';
  }
}

class _HudRow extends StatelessWidget {
  const _HudRow({required this.label, required this.value});

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
                color: const Color(0xFF97AEB8),
              ),
            ),
          ),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({required this.timerValue});

  final double timerValue;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: LinearProgressIndicator(
          value: 1 - timerValue,
          backgroundColor: const Color(0xFF10232D),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AD7B1)),
        ),
      ),
    );
  }
}

class _AnchorCard extends StatelessWidget {
  const _AnchorCard({required this.region});

  final BrainRegion region;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF173845), Color(0xFF10222C)],
        ),
        border: Border.all(color: const Color(0xFF4AD7B1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                Chip(label: Text(region.shortLabel)),
              ],
            ),
            const SizedBox(height: 10),
            Text(region.summary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text('Target role', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(region.primaryRole, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _PatternSlotCard extends StatelessWidget {
  const _PatternSlotCard({
    required this.slot,
    required this.assignedRegion,
    required this.isSelected,
    required this.isInteractive,
    required this.onTap,
  });

  final PatternSlotSpec slot;
  final BrainRegion? assignedRegion;
  final bool isSelected;
  final bool isInteractive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isInteractive ? onTap : null,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0x99102129),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF3C96C)
                : const Color(0xFF274A57),
            width: isSelected ? 2.6 : 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(slot.slotLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(slot.clue, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0x80182730),
                border: Border.all(color: const Color(0xFF244B59)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: assignedRegion == null
                    ? Text(
                        isInteractive
                            ? 'Tap to place the matching region'
                            : 'No region placed',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF8EA8B4),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            assignedRegion!.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignedRegion!.discipline.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF9EDCCD),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateRegionCard extends StatelessWidget {
  const _CandidateRegionCard({
    required this.region,
    required this.isAssigned,
    required this.isInteractive,
    required this.onTap,
  });

  final BrainRegion region;
  final bool isAssigned;
  final bool isInteractive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isInteractive ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isAssigned ? const Color(0x66244B59) : const Color(0x80102129),
          border: Border.all(
            color: isAssigned
                ? const Color(0xFF4AD7B1)
                : const Color(0xFF274A57),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(region.name, style: theme.textTheme.titleMedium),
                ),
                if (isAssigned)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4AD7B1),
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              region.discipline.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFF3C96C),
              ),
            ),
            const SizedBox(height: 8),
            Text(region.failurePattern, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _LearningNoteTile extends StatelessWidget {
  const _LearningNoteTile({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0x80102129),
        border: Border.all(color: const Color(0xFF274A57)),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: Text(note)),
    );
  }
}
