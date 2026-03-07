enum BrainCaseStage { investigation, repair, debrief, complete }

enum CaseSeverity { moderate, high, critical }

extension CaseSeverityX on CaseSeverity {
  String get label {
    switch (this) {
      case CaseSeverity.moderate:
        return 'Moderate';
      case CaseSeverity.high:
        return 'High';
      case CaseSeverity.critical:
        return 'Critical';
    }
  }
}

class CaseSceneMetric {
  const CaseSceneMetric({
    required this.label,
    required this.impairedValue,
    required this.restoredValue,
  });

  final String label;
  final String impairedValue;
  final String restoredValue;
}

class CaseProbe {
  const CaseProbe({
    required this.id,
    required this.title,
    required this.clue,
    required this.learningNote,
  });

  final String id;
  final String title;
  final String clue;
  final String learningNote;
}

class BrainCaseFile {
  const BrainCaseFile({
    required this.id,
    required this.caseCode,
    required this.title,
    required this.severity,
    required this.baseResearchValue,
    required this.symptomTags,
    required this.presentingProblem,
    required this.observationSummary,
    required this.targetRegionId,
    required this.observationNotes,
    required this.sceneMetrics,
    required this.probes,
    required this.hypothesisPrompt,
    required this.repairObjective,
    required this.validationSummary,
    required this.explanation,
    required this.differentialNote,
    required this.masteryNote,
  });

  final String id;
  final String caseCode;
  final String title;
  final CaseSeverity severity;
  final int baseResearchValue;
  final List<String> symptomTags;
  final String presentingProblem;
  final String observationSummary;
  final String targetRegionId;
  final List<String> observationNotes;
  final List<CaseSceneMetric> sceneMetrics;
  final List<CaseProbe> probes;
  final String hypothesisPrompt;
  final String repairObjective;
  final String validationSummary;
  final String explanation;
  final String differentialNote;
  final String masteryNote;
}
