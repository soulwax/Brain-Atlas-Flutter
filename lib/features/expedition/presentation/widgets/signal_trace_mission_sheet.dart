import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/brain_region.dart';
import '../../domain/signal_trace_mission.dart';

enum SignalTracePhase { briefing, live, success, failure }

class SignalTraceMissionSheet extends StatefulWidget {
  const SignalTraceMissionSheet({
    super.key,
    required this.region,
    required this.focus,
    required this.signalStrength,
    required this.onMissionSuccess,
    required this.onMissionFailure,
    required this.onClose,
  });

  final BrainRegion region;
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
  late final AnimationController _timerController;

  SignalTracePhase _phase = SignalTracePhase.briefing;
  final List<Offset> _trail = <Offset>[];
  int _nextRelayIndex = 1;
  double _driftScoreTotal = 0;
  int _driftSamples = 0;
  String _status =
      'Prime the neural lens, then anchor the pulse on the entry gate.';
  String _resultHeadline = '';
  String _resultBody = '';

  bool get _isLive => _phase == SignalTracePhase.live;
  bool get _isResolved =>
      _phase == SignalTracePhase.success || _phase == SignalTracePhase.failure;

  @override
  void initState() {
    super.initState();
    _spec = buildSignalTraceMissionSpec(widget.region);
    _timerController = AnimationController(vsync: this, duration: _spec.timeLimit)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed &&
            _phase == SignalTracePhase.live) {
          _resolveFailure(
            'The pathway destabilized before the pulse reached the output gate.',
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
                Text('Signal Trace', style: theme.textTheme.headlineSmall),
                Chip(label: Text(widget.region.discipline.label)),
                Chip(label: Text('${_spec.timeLimit.inSeconds}s window')),
                Chip(label: Text('Difficulty ${_spec.difficulty}')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Press begin, anchor at the left entry gate, and drag through every relay without touching the noise fields or leaving the stable corridor.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return AnimatedBuilder(
                    animation: _timerController,
                    builder: (BuildContext context, Widget? child) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (DragStartDetails details) =>
                            _handlePanStart(details.localPosition, size),
                        onPanUpdate: (DragUpdateDetails details) =>
                            _handlePanUpdate(details.localPosition, size),
                        onPanEnd: (_) => _handlePanEnd(),
                        child: CustomPaint(
                          painter: _SignalTracePainter(
                            spec: _spec,
                            trail: _trail,
                            nextRelayIndex: _nextRelayIndex,
                            phase: _phase,
                            timerValue: _timerController.value,
                          ),
                          size: Size.infinite,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(ThemeData theme) {
    final relayCount = _spec.relays.length - 2;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xFF0D1D25),
        border: Border.all(color: const Color(0xFF224552)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.region.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(widget.region.summary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            _HudRow(label: 'Focus reserve', value: '${widget.focus}/4'),
            _HudRow(
              label: 'Signal strength',
              value: '${widget.signalStrength}%',
            ),
            _HudRow(label: 'Relays to sync', value: '$relayCount'),
            _HudRow(label: 'Noise fields', value: '${_spec.noiseZones.length}'),
            const SizedBox(height: 18),
            Text('Neural objective', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              widget.region.challengePrompt,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Text('Desired signal rule', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              widget.region.correctOption.label,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Text('Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_status, style: theme.textTheme.bodyMedium),
            const Spacer(),
            if (_phase == SignalTracePhase.briefing)
              FilledButton.icon(
                onPressed: _beginMission,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Begin trace'),
              ),
            if (_phase == SignalTracePhase.live)
              OutlinedButton.icon(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Abort mission'),
              ),
            if (_phase == SignalTracePhase.failure) ...<Widget>[
              Text(_resultHeadline, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_resultBody, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _resetAttempt,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry trace'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: widget.onClose,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Return to map'),
              ),
            ],
            if (_phase == SignalTracePhase.success) ...<Widget>[
              Text(_resultHeadline, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_resultBody, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: widget.onClose,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Return to map'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _beginMission() {
    setState(() {
      _phase = SignalTracePhase.live;
      _status = 'Anchor on the entry gate, then sweep through each relay.';
      _trail.clear();
      _nextRelayIndex = 1;
      _driftScoreTotal = 0;
      _driftSamples = 0;
    });
    _timerController.forward(from: 0);
  }

  void _resetAttempt() {
    _timerController.reset();
    setState(() {
      _phase = SignalTracePhase.briefing;
      _trail.clear();
      _nextRelayIndex = 1;
      _driftScoreTotal = 0;
      _driftSamples = 0;
      _status =
          'Prime the neural lens, then anchor the pulse on the entry gate.';
      _resultHeadline = '';
      _resultBody = '';
    });
  }

  void _handlePanStart(Offset position, Size size) {
    if (!_isLive) {
      return;
    }

    final relays = _scaledRelays(size);
    final startRadius = size.shortestSide * _spec.checkpointRadiusFactor * 1.2;
    if ((position - relays.first).distance > startRadius) {
      setState(() {
        _status = 'Start by touching the entry gate on the left edge.';
      });
      return;
    }

    setState(() {
      _trail
        ..clear()
        ..add(position);
      _status = 'Pulse locked. Thread it through the relay line.';
    });
  }

  void _handlePanUpdate(Offset position, Size size) {
    if (!_isLive || _trail.isEmpty || _isResolved) {
      return;
    }

    final laneWidth = size.shortestSide * _spec.laneWidthFactor;
    final relays = _scaledRelays(size);
    final noiseZones = _scaledNoiseZones(size);
    final distanceToPath = _distanceToPolyline(position, relays);

    if (distanceToPath > laneWidth) {
      _resolveFailure('Signal broke outside the stable corridor.');
      return;
    }

    for (final _NoiseZone noiseZone in noiseZones) {
      if ((position - noiseZone.center).distance <= noiseZone.radius) {
        _resolveFailure(
          'Noise contamination hit the pulse before the relay synced.',
        );
        return;
      }
    }

    final checkpointRadius = size.shortestSide * _spec.checkpointRadiusFactor;
    if (_nextRelayIndex < relays.length &&
        (position - relays[_nextRelayIndex]).distance <= checkpointRadius) {
      _nextRelayIndex += 1;
      if (_nextRelayIndex == relays.length) {
        _resolveSuccess();
        return;
      }
      setState(() {
        _status =
            'Relay ${_nextRelayIndex - 1}/${relays.length - 2} locked. Keep the pulse stable.';
      });
    }

    _driftSamples += 1;
    _driftScoreTotal += distanceToPath / laneWidth;
    setState(() {
      _trail.add(position);
      if (_trail.length > 260) {
        _trail.removeAt(0);
      }
    });
  }

  void _handlePanEnd() {
    if (_isLive && _trail.isNotEmpty && !_isResolved) {
      _resolveFailure('Trace released before the output gate stabilized.');
    }
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
      _status = 'Output gate locked. ${widget.region.name} is stable.';
      _resultHeadline = 'Region stabilized';
      _resultBody =
          'Trace integrity reached ${(integrity * 100).round()}%. Adjacent pathways can now open from the overworld.';
    });
  }

  void _resolveFailure(String reason) {
    if (_isResolved) {
      return;
    }

    _timerController.stop();
    widget.onMissionFailure(reason);

    setState(() {
      _phase = SignalTracePhase.failure;
      _status = reason;
      _resultHeadline = 'Trace collapsed';
      _resultBody =
          'The attempt still cost resources, but the region remains reachable. Retry to stabilize the circuit.';
    });
  }

  double _calculateIntegrity() {
    final driftPenalty = _driftSamples == 0
        ? 0
        : (_driftScoreTotal / _driftSamples) * 0.42;
    final timePenalty = _timerController.value * 0.35;

    return (1 - driftPenalty - timePenalty).clamp(0.55, 1.0).toDouble();
  }

  List<Offset> _scaledRelays(Size size) {
    return _spec.relays
        .map(
          (Offset relay) =>
              Offset(size.width * relay.dx, size.height * relay.dy),
        )
        .toList(growable: false);
  }

  List<_NoiseZone> _scaledNoiseZones(Size size) {
    final radiusBase = size.shortestSide;

    return _spec.noiseZones
        .map(
          (NoiseZoneSpec zone) => _NoiseZone(
            center: Offset(
              size.width * zone.center.dx,
              size.height * zone.center.dy,
            ),
            radius: radiusBase * zone.radiusFactor,
          ),
        )
        .toList(growable: false);
  }

  double _distanceToPolyline(Offset point, List<Offset> polyline) {
    var closest = double.infinity;
    for (var index = 0; index < polyline.length - 1; index++) {
      closest = math.min(
        closest,
        _distanceToSegment(point, polyline[index], polyline[index + 1]),
      );
    }
    return closest;
  }

  double _distanceToSegment(Offset point, Offset start, Offset end) {
    final segment = end - start;
    final lengthSquared = segment.dx * segment.dx + segment.dy * segment.dy;
    if (lengthSquared == 0) {
      return (point - start).distance;
    }

    final projection =
        ((point.dx - start.dx) * segment.dx +
            (point.dy - start.dy) * segment.dy) /
        lengthSquared;
    final t = projection.clamp(0.0, 1.0);
    final projectedPoint = Offset(
      start.dx + (segment.dx * t),
      start.dy + (segment.dy * t),
    );
    return (point - projectedPoint).distance;
  }
}

class _NoiseZone {
  const _NoiseZone({required this.center, required this.radius});

  final Offset center;
  final double radius;
}

class _SignalTracePainter extends CustomPainter {
  const _SignalTracePainter({
    required this.spec,
    required this.trail,
    required this.nextRelayIndex,
    required this.phase,
    required this.timerValue,
  });

  final SignalTraceMissionSpec spec;
  final List<Offset> trail;
  final int nextRelayIndex;
  final SignalTracePhase phase;
  final double timerValue;

  @override
  void paint(Canvas canvas, Size size) {
    final relays = spec.relays
        .map(
          (Offset relay) =>
              Offset(size.width * relay.dx, size.height * relay.dy),
        )
        .toList(growable: false);
    final corridorPath = _buildPath(relays);
    final laneWidth = size.shortestSide * spec.laneWidthFactor;
    final checkpointRadius = size.shortestSide * spec.checkpointRadiusFactor;

    _paintGrid(canvas, size);
    _paintNoiseZones(canvas, size);
    canvas.drawPath(
      corridorPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = laneWidth * 2
        ..color = const Color(0x2239E5BF),
    );
    canvas.drawPath(
      corridorPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = laneWidth * 0.5
        ..shader = const LinearGradient(
          colors: <Color>[
            Color(0xFF44DCC0),
            Color(0xFF7BE0F4),
            Color(0xFFF3C96C),
          ],
        ).createShader(Offset.zero & size),
    );
    _paintRelayProgress(canvas, relays, checkpointRadius);
    _paintTrail(canvas);
    _paintTimerBar(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x183A6272)
      ..strokeWidth = 1;

    for (var column = 1; column < 12; column++) {
      final x = size.width * (column / 12);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (var row = 1; row < 8; row++) {
      final y = size.height * (row / 8);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _paintNoiseZones(Canvas canvas, Size size) {
    for (final NoiseZoneSpec zone in spec.noiseZones) {
      final center = Offset(
        size.width * zone.center.dx,
        size.height * zone.center.dy,
      );
      final radius = size.shortestSide * zone.radiusFactor;
      final glow = Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFF96B62).withValues(alpha: 0.48),
            const Color(0xFFE42C49).withValues(alpha: 0.16),
            Colors.transparent,
          ],
          stops: const <double>[0.15, 0.55, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.8));
      final core = Paint()
        ..color = const Color(
          0xFFF96B62,
        ).withValues(alpha: 0.3 + (math.sin(timerValue * math.pi * 2) * 0.12));
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFFFB5A7).withValues(alpha: 0.6);

      canvas.drawCircle(center, radius * 1.8, glow);
      canvas.drawCircle(center, radius, core);
      canvas.drawCircle(center, radius, stroke);
    }
  }

  void _paintRelayProgress(
    Canvas canvas,
    List<Offset> relays,
    double checkpointRadius,
  ) {
    for (var index = 0; index < relays.length; index++) {
      final relay = relays[index];
      final isComplete = index < nextRelayIndex;
      final isCurrent = index == nextRelayIndex;
      final fill = Paint()
        ..shader =
            RadialGradient(
              colors: <Color>[
                isComplete
                    ? const Color(0xFFF3C96C)
                    : isCurrent
                    ? const Color(0xFF4AD7B1)
                    : const Color(0xFF173845),
                const Color(0xFF0E1C24),
              ],
            ).createShader(
              Rect.fromCircle(center: relay, radius: checkpointRadius),
            );
      final border = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isCurrent ? 3 : 2
        ..color = isComplete
            ? const Color(0xFFFFE2A3)
            : isCurrent
            ? const Color(0xFFB8FFF0)
            : const Color(0xFF31505C);

      canvas.drawCircle(relay, checkpointRadius, fill);
      canvas.drawCircle(relay, checkpointRadius, border);
    }
  }

  void _paintTrail(Canvas canvas) {
    if (trail.length < 2) {
      return;
    }

    final path = Path()..moveTo(trail.first.dx, trail.first.dy);
    for (final Offset point in trail.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 8
      ..color = phase == SignalTracePhase.failure
          ? const Color(0xFFFF7E73)
          : const Color(0xFFEFFBC4);

    canvas.drawPath(path, trailPaint);
  }

  void _paintTimerBar(Canvas canvas, Size size) {
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, 8),
      const Radius.circular(999),
    );
    final activeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * (1 - timerValue), 8),
      const Radius.circular(999),
    );
    canvas.drawRRect(barRect, Paint()..color = const Color(0xFF10232D));
    canvas.drawRRect(
      activeRect,
      Paint()
        ..shader = const LinearGradient(
          colors: <Color>[
            Color(0xFF4AD7B1),
            Color(0xFFF3C96C),
            Color(0xFFF96B62),
          ],
        ).createShader(Offset.zero & size),
    );
  }

  Path _buildPath(List<Offset> relays) {
    final path = Path()..moveTo(relays.first.dx, relays.first.dy);
    for (final Offset relay in relays.skip(1)) {
      path.lineTo(relay.dx, relay.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _SignalTracePainter oldDelegate) {
    return oldDelegate.trail != trail ||
        oldDelegate.nextRelayIndex != nextRelayIndex ||
        oldDelegate.phase != phase ||
        oldDelegate.timerValue != timerValue ||
        oldDelegate.spec != spec;
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
