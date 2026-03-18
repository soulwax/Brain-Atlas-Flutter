import 'dart:math' as math;

import 'brain_case_file.dart';
import 'brain_region.dart';

class PatternSlotSpec {
  const PatternSlotSpec({
    required this.regionId,
    required this.slotLabel,
    required this.clue,
    required this.learningNote,
  });

  final String regionId;
  final String slotLabel;
  final String clue;
  final String learningNote;
}

class SignalTraceMissionSpec {
  const SignalTraceMissionSpec({
    required this.slots,
    required this.candidateRegionIds,
    required this.timeLimit,
    required this.difficulty,
  });

  final List<PatternSlotSpec> slots;
  final List<String> candidateRegionIds;
  final Duration timeLimit;
  final int difficulty;
}

SignalTraceMissionSpec buildSignalTraceMissionSpec({
  required BrainRegion region,
  required BrainCaseFile caseFile,
  required List<BrainRegion> catalog,
}) {
  final regionById = <String, BrainRegion>{
    for (final BrainRegion item in catalog) item.id: item,
  };
  final slots = <PatternSlotSpec>[
    for (var index = 0; index < caseFile.patternRegionIds.length; index++)
      if (regionById[caseFile.patternRegionIds[index]]
          case final BrainRegion partner)
        PatternSlotSpec(
          regionId: partner.id,
          slotLabel: _buildSlotLabel(
            partner: partner,
            index: index,
            orderedPartnerIds: caseFile.patternRegionIds,
            regionById: regionById,
          ),
          clue: partner.primaryRole,
          learningNote:
              '${partner.name} feeds this case pattern because ${partner.networkRole.toLowerCase()}.',
        ),
  ];
  final distractorIds = _pickDistractorIds(
    targetRegion: region,
    protectedIds: <String>{
      region.id,
      ...slots.map((PatternSlotSpec slot) => slot.regionId),
    },
    catalog: catalog,
  );
  final candidateRegionIds =
      <String>[
        ...slots.map((PatternSlotSpec slot) => slot.regionId),
        ...distractorIds,
      ]..sort(
        (String left, String right) => _stableSeed(
          left,
          region.id,
          caseFile.id,
        ).compareTo(_stableSeed(right, region.id, caseFile.id)),
      );
  final difficulty = math.max(
    1,
    slots.length + region.rewardInsight + (distractorIds.length ~/ 2),
  );

  return SignalTraceMissionSpec(
    slots: slots,
    candidateRegionIds: candidateRegionIds,
    timeLimit: Duration(seconds: math.max(32, 54 - difficulty * 2)),
    difficulty: difficulty,
  );
}

String _buildSlotLabel({
  required BrainRegion partner,
  required int index,
  required List<String> orderedPartnerIds,
  required Map<String, BrainRegion> regionById,
}) {
  final duplicateCount = orderedPartnerIds
      .where((String id) => regionById[id]?.discipline == partner.discipline)
      .length;
  final baseLabel = '${partner.discipline.label} link';
  if (duplicateCount < 2) {
    return baseLabel;
  }

  return '$baseLabel ${index + 1}';
}

List<String> _pickDistractorIds({
  required BrainRegion targetRegion,
  required Set<String> protectedIds,
  required List<BrainRegion> catalog,
}) {
  final candidates =
      catalog
          .where((BrainRegion region) => !protectedIds.contains(region.id))
          .toList(growable: false)
        ..sort((BrainRegion left, BrainRegion right) {
          final scoreDifference =
              _distractorScore(right, targetRegion) -
              _distractorScore(left, targetRegion);
          if (scoreDifference != 0) {
            return scoreDifference;
          }

          return left.name.compareTo(right.name);
        });

  return candidates.take(2).map((BrainRegion item) => item.id).toList();
}

int _distractorScore(BrainRegion candidate, BrainRegion targetRegion) {
  var score = candidate.rewardInsight;
  if (candidate.discipline == targetRegion.discipline) {
    score += 4;
  }
  if (candidate.connections.contains(targetRegion.id) ||
      targetRegion.connections.contains(candidate.id)) {
    score += 3;
  }
  if (candidate.challengeOptions.length ==
      targetRegion.challengeOptions.length) {
    score += 1;
  }
  return score;
}

int _stableSeed(String candidateId, String regionId, String caseId) {
  return '$candidateId::$regionId::$caseId'.codeUnits.fold<int>(
    0,
    (int total, int codeUnit) => total + codeUnit,
  );
}
