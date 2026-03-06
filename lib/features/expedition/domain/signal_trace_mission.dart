import 'dart:math' as math;
import 'dart:ui';

import 'brain_region.dart';

class NoiseZoneSpec {
  const NoiseZoneSpec({required this.center, required this.radiusFactor});

  final Offset center;
  final double radiusFactor;
}

class SignalTraceMissionSpec {
  const SignalTraceMissionSpec({
    required this.relays,
    required this.noiseZones,
    required this.timeLimit,
    required this.laneWidthFactor,
    required this.checkpointRadiusFactor,
    required this.difficulty,
  });

  final List<Offset> relays;
  final List<NoiseZoneSpec> noiseZones;
  final Duration timeLimit;
  final double laneWidthFactor;
  final double checkpointRadiusFactor;
  final int difficulty;
}

SignalTraceMissionSpec buildSignalTraceMissionSpec(BrainRegion region) {
  final seed = region.id.codeUnits.fold<int>(
    0,
    (int sum, int codeUnit) => sum + codeUnit,
  );
  final difficulty = math.max(
    1,
    region.rewardInsight + (region.connections.length ~/ 2),
  );
  final lateralBias = ((seed % 5) - 2) / 18;
  final verticalWave = ((seed % 7) - 3) / 22;
  final relayPoints = <Offset>[
    Offset(0.12, _clamp(0.72 - (lateralBias * 0.45), 0.18, 0.82)),
    Offset(
      0.28,
      _clamp(0.26 + lateralBias.abs() * 0.85 + ((seed % 3) * 0.035), 0.2, 0.8),
    ),
    Offset(0.48, _clamp(0.62 - verticalWave, 0.2, 0.8)),
    Offset(
      0.68,
      _clamp(0.3 + lateralBias + (((seed ~/ 3) % 3) * 0.024), 0.18, 0.78),
    ),
    Offset(0.88, _clamp(0.56 - (lateralBias * 0.6), 0.2, 0.82)),
  ];

  final noiseZones = <NoiseZoneSpec>[
    for (var index = 1; index < relayPoints.length - 1; index++)
      NoiseZoneSpec(
        center: Offset(
          _clamp(
            relayPoints[index].dx + (index.isEven ? 0.05 : -0.035),
            0.16,
            0.86,
          ),
          _clamp(
            relayPoints[index].dy +
                (((seed + index) % 2 == 0) ? 1 : -1) *
                    (0.085 + (difficulty * 0.006)),
            0.15,
            0.84,
          ),
        ),
        radiusFactor: _clamp(
          0.06 + (difficulty * 0.004) - (index * 0.004),
          0.05,
          0.082,
        ),
      ),
  ];

  return SignalTraceMissionSpec(
    relays: relayPoints,
    noiseZones: noiseZones,
    timeLimit: Duration(seconds: math.max(14, 21 - difficulty)),
    laneWidthFactor: _clamp(0.11 - (difficulty * 0.008), 0.055, 0.1),
    checkpointRadiusFactor: 0.046,
    difficulty: difficulty,
  );
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
