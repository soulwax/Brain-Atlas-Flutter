enum BrainRegionState { locked, reachable, stabilized }

enum BrainRegionDiscipline {
  planning,
  language,
  movement,
  sensory,
  memory,
  emotion,
  vision,
  coordination,
  relay,
  interoception,
}

extension BrainRegionDisciplineX on BrainRegionDiscipline {
  String get label {
    switch (this) {
      case BrainRegionDiscipline.planning:
        return 'Planning';
      case BrainRegionDiscipline.language:
        return 'Language';
      case BrainRegionDiscipline.movement:
        return 'Movement';
      case BrainRegionDiscipline.sensory:
        return 'Sensory';
      case BrainRegionDiscipline.memory:
        return 'Memory';
      case BrainRegionDiscipline.emotion:
        return 'Emotion';
      case BrainRegionDiscipline.vision:
        return 'Vision';
      case BrainRegionDiscipline.coordination:
        return 'Coordination';
      case BrainRegionDiscipline.relay:
        return 'Relay';
      case BrainRegionDiscipline.interoception:
        return 'Interoception';
    }
  }
}

class ChallengeOption {
  const ChallengeOption({
    required this.label,
    required this.feedback,
    required this.isCorrect,
  });

  final String label;
  final String feedback;
  final bool isCorrect;
}

class BrainRegion {
  const BrainRegion({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.summary,
    required this.primaryRole,
    required this.failurePattern,
    required this.networkRole,
    required this.everydayExample,
    required this.quickFacts,
    required this.discipline,
    required this.positionX,
    required this.positionY,
    required this.radiusFactor,
    required this.connections,
    required this.challengePrompt,
    required this.challengeOptions,
    required this.codexEntry,
    required this.rewardInsight,
  });

  final String id;
  final String name;
  final String shortLabel;
  final String summary;
  final String primaryRole;
  final String failurePattern;
  final String networkRole;
  final String everydayExample;
  final List<String> quickFacts;
  final BrainRegionDiscipline discipline;
  final double positionX;
  final double positionY;
  final double radiusFactor;
  final List<String> connections;
  final String challengePrompt;
  final List<ChallengeOption> challengeOptions;
  final String codexEntry;
  final int rewardInsight;

  ChallengeOption get correctOption =>
      challengeOptions.firstWhere((ChallengeOption option) => option.isCorrect);
}

class BrainRegionProgress {
  const BrainRegionProgress({
    this.state = BrainRegionState.locked,
    this.attempts = 0,
  });

  final BrainRegionState state;
  final int attempts;

  bool get isAvailable => state != BrainRegionState.locked;
  bool get isStabilized => state == BrainRegionState.stabilized;

  BrainRegionProgress copyWith({BrainRegionState? state, int? attempts}) {
    return BrainRegionProgress(
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
    );
  }
}
