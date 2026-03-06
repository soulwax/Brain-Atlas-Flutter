import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/brain_region.dart';

class BrainMapCanvas extends StatelessWidget {
  const BrainMapCanvas({
    super.key,
    required this.regions,
    required this.progressByRegion,
    required this.selectedRegionId,
    required this.pulse,
    required this.onRegionTap,
  });

  final List<BrainRegion> regions;
  final Map<String, BrainRegionProgress> progressByRegion;
  final String selectedRegionId;
  final double pulse;
  final ValueChanged<String> onRegionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (TapDownDetails details) {
            final target = _hitTest(details.localPosition, size);
            if (target != null) {
              onRegionTap(target);
            }
          },
          child: CustomPaint(
            painter: _BrainMapPainter(
              regions: regions,
              progressByRegion: progressByRegion,
              selectedRegionId: selectedRegionId,
              pulse: pulse,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  String? _hitTest(Offset localPosition, Size size) {
    String? hitRegionId;
    double bestDistance = double.infinity;

    for (final BrainRegion region in regions) {
      final progress = progressByRegion[region.id];
      if (progress == null || !progress.isAvailable) {
        continue;
      }

      final center = Offset(
        size.width * region.positionX,
        size.height * region.positionY,
      );
      final radius = size.shortestSide * region.radiusFactor;
      final distance = (center - localPosition).distance;

      if (distance <= radius * 1.2 && distance < bestDistance) {
        bestDistance = distance;
        hitRegionId = region.id;
      }
    }

    return hitRegionId;
  }
}

class _BrainMapPainter extends CustomPainter {
  _BrainMapPainter({
    required this.regions,
    required this.progressByRegion,
    required this.selectedRegionId,
    required this.pulse,
  });

  final List<BrainRegion> regions;
  final Map<String, BrainRegionProgress> progressByRegion;
  final String selectedRegionId;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    _paintSilhouette(canvas, size);
    _paintConnections(canvas, size);
    _paintNodes(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x182E5A68)
      ..strokeWidth = 1;

    const columns = 10;
    const rows = 6;

    for (var i = 1; i < columns; i++) {
      final x = size.width * (i / columns);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (var i = 1; i < rows; i++) {
      final y = size.height * (i / rows);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _paintSilhouette(Canvas canvas, Size size) {
    final bounds = Rect.fromLTWH(
      size.width * 0.05,
      size.height * 0.08,
      size.width * 0.88,
      size.height * 0.8,
    );

    final path = _buildBrainPath(bounds);
    final fillPaint = Paint()
      ..shader = const RadialGradient(
        colors: <Color>[
          Color(0xFF173D48),
          Color(0xFF0E2430),
          Color(0xFF09171E),
        ],
        center: Alignment(-0.2, -0.2),
        radius: 1.2,
      ).createShader(bounds);
    final strokePaint = Paint()
      ..color = const Color(0xFF316270)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    final splitPaint = Paint()
      ..color = const Color(0xFF234D58)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(
        bounds.center.dx - size.width * 0.01,
        bounds.top + size.height * 0.12,
      ),
      Offset(
        bounds.center.dx + size.width * 0.04,
        bounds.bottom - size.height * 0.1,
      ),
      splitPaint,
    );
  }

  Path _buildBrainPath(Rect rect) {
    // The silhouette stays deliberately stylized so we can swap it with region masks or a 3D mesh later.
    return Path()
      ..moveTo(rect.left + rect.width * 0.14, rect.top + rect.height * 0.42)
      ..cubicTo(
        rect.left - rect.width * 0.02,
        rect.top + rect.height * 0.16,
        rect.left + rect.width * 0.15,
        rect.top - rect.height * 0.05,
        rect.left + rect.width * 0.35,
        rect.top + rect.height * 0.05,
      )
      ..cubicTo(
        rect.left + rect.width * 0.42,
        rect.top - rect.height * 0.02,
        rect.left + rect.width * 0.6,
        rect.top + rect.height * 0.02,
        rect.left + rect.width * 0.71,
        rect.top + rect.height * 0.14,
      )
      ..cubicTo(
        rect.left + rect.width * 0.93,
        rect.top + rect.height * 0.18,
        rect.left + rect.width * 1.01,
        rect.top + rect.height * 0.45,
        rect.left + rect.width * 0.89,
        rect.top + rect.height * 0.63,
      )
      ..cubicTo(
        rect.left + rect.width * 0.92,
        rect.top + rect.height * 0.83,
        rect.left + rect.width * 0.73,
        rect.top + rect.height * 0.98,
        rect.left + rect.width * 0.54,
        rect.top + rect.height * 0.94,
      )
      ..cubicTo(
        rect.left + rect.width * 0.38,
        rect.top + rect.height * 1.03,
        rect.left + rect.width * 0.16,
        rect.top + rect.height * 0.93,
        rect.left + rect.width * 0.12,
        rect.top + rect.height * 0.76,
      )
      ..cubicTo(
        rect.left - rect.width * 0.02,
        rect.top + rect.height * 0.64,
        rect.left + rect.width * 0.03,
        rect.top + rect.height * 0.5,
        rect.left + rect.width * 0.14,
        rect.top + rect.height * 0.42,
      )
      ..close();
  }

  void _paintConnections(Canvas canvas, Size size) {
    final regionLookup = <String, BrainRegion>{
      for (final region in regions) region.id: region,
    };

    for (final region in regions) {
      for (final targetId in region.connections) {
        if (region.id.compareTo(targetId) >= 0) {
          continue;
        }

        final endRegion = regionLookup[targetId];
        if (endRegion == null) {
          continue;
        }

        final startState = progressByRegion[region.id];
        final endState = progressByRegion[endRegion.id];
        final start = _offsetForRegion(region, size);
        final end = _offsetForRegion(endRegion, size);
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(
            (start.dx + end.dx) / 2,
            math.min(start.dy, end.dy) - size.height * 0.1,
            end.dx,
            end.dy,
          );

        final isActive =
            (startState?.isAvailable ?? false) &&
            (endState?.isAvailable ?? false);
        final isStabilized =
            (startState?.isStabilized ?? false) &&
            (endState?.isStabilized ?? false);
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isStabilized ? 4 : 2.4
          ..color = isStabilized
              ? const Color(0xFF60E8C2).withValues(alpha: 0.78)
              : isActive
              ? const Color(0xFF7AC4D7).withValues(alpha: 0.42)
              : const Color(0xFF234653).withValues(alpha: 0.22);

        canvas.drawPath(path, paint);
      }
    }
  }

  void _paintNodes(Canvas canvas, Size size) {
    for (final BrainRegion region in regions) {
      final progress = progressByRegion[region.id];
      if (progress == null) {
        continue;
      }

      final center = _offsetForRegion(region, size);
      final radius = size.shortestSide * region.radiusFactor;
      final stateColors = _colorsFor(progress.state);
      final isSelected = region.id == selectedRegionId;
      final glowRadius = radius * (1.28 + (pulse * 0.18));
      final glowPaint = Paint()
        ..color = stateColors.$1.withValues(
          alpha: progress.isAvailable ? (0.2 + (pulse * 0.12)) : 0.08,
        );
      final nodePaint = Paint()
        ..shader = RadialGradient(
          colors: <Color>[stateColors.$1, stateColors.$2],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.5 : 2
        ..color = isSelected ? const Color(0xFFF6E8B1) : stateColors.$3;

      canvas.drawCircle(center, glowRadius, glowPaint);
      canvas.drawCircle(center, radius, nodePaint);
      canvas.drawCircle(center, radius, borderPaint);

      if (progress.isAvailable && !progress.isStabilized) {
        final pulsePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(
            0xFFB0F6E3,
          ).withValues(alpha: 0.35 + (pulse * 0.25));
        canvas.drawCircle(center, radius * (1.28 + (pulse * 0.1)), pulsePaint);
      }

      if (progress.isStabilized) {
        final solvedPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFFF3C96C).withValues(alpha: 0.78);
        canvas.drawCircle(center, radius * 1.35, solvedPaint);
      }

      _paintLabel(canvas, center, radius, region.shortLabel, progress.state);
    }
  }

  void _paintLabel(
    Canvas canvas,
    Offset center,
    double radius,
    String label,
    BrainRegionState state,
  ) {
    final textStyle = TextStyle(
      color: state == BrainRegionState.locked
          ? const Color(0xFF5A7C88)
          : const Color(0xFFEAF5F7),
      fontWeight: FontWeight.w700,
      fontSize: math.max(11, radius * 0.34),
      letterSpacing: 0.3,
    );
    final painter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      maxLines: 1,
      ellipsis: '…',
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: radius * 3.4);
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy + radius + 8),
    );
  }

  Offset _offsetForRegion(BrainRegion region, Size size) {
    return Offset(
      size.width * region.positionX,
      size.height * region.positionY,
    );
  }

  (Color, Color, Color) _colorsFor(BrainRegionState state) {
    switch (state) {
      case BrainRegionState.locked:
        return (
          const Color(0xFF19303A),
          const Color(0xFF0B1820),
          const Color(0xFF28414B),
        );
      case BrainRegionState.reachable:
        return (
          const Color(0xFF5DE0BF),
          const Color(0xFF14414B),
          const Color(0xFF9CEFD7),
        );
      case BrainRegionState.stabilized:
        return (
          const Color(0xFFF3C96C),
          const Color(0xFF3E3420),
          const Color(0xFFF7E2A2),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _BrainMapPainter oldDelegate) {
    return oldDelegate.progressByRegion != progressByRegion ||
        oldDelegate.selectedRegionId != selectedRegionId ||
        oldDelegate.pulse != pulse ||
        oldDelegate.regions != regions;
  }
}
