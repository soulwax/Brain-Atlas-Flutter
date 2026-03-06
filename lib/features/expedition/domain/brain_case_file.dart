enum BrainCaseStage { investigation, repair, debrief, complete }

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

class BrainCaseFile {
  const BrainCaseFile({
    required this.id,
    required this.caseCode,
    required this.title,
    required this.presentingProblem,
    required this.observationSummary,
    required this.targetRegionId,
    required this.observationNotes,
    required this.sceneMetrics,
    required this.hypothesisPrompt,
    required this.repairObjective,
    required this.validationSummary,
    required this.explanation,
    required this.differentialNote,
  });

  final String id;
  final String caseCode;
  final String title;
  final String presentingProblem;
  final String observationSummary;
  final String targetRegionId;
  final List<String> observationNotes;
  final List<CaseSceneMetric> sceneMetrics;
  final String hypothesisPrompt;
  final String repairObjective;
  final String validationSummary;
  final String explanation;
  final String differentialNote;
}
