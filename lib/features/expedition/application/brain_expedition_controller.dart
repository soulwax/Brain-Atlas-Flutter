import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../domain/brain_case_catalog.dart';
import '../domain/brain_case_file.dart';
import '../domain/brain_region.dart';
import '../domain/brain_region_catalog.dart';

class BrainExpeditionController extends ChangeNotifier {
  BrainExpeditionController({
    List<BrainRegion> catalog = brainRegionCatalog,
    List<BrainCaseFile> caseCatalog = brainCaseCatalog,
  }) : _catalog = catalog,
       _caseCatalog = caseCatalog {
    reset(notify: false);
  }

  static const int _maxFocus = 4;
  static const int _maxSignalStrength = 100;

  final List<BrainRegion> _catalog;
  final List<BrainCaseFile> _caseCatalog;

  late Map<String, BrainRegionProgress> _progress;
  String? _selectedRegionId;
  String? _activeCaseId;
  BrainCaseStage _caseStage = BrainCaseStage.investigation;
  String _caseStatus =
      'Review the symptoms first, then localize the fault on the map.';
  int _focus = _maxFocus;
  int _signalStrength = 78;
  int _insight = 0;
  int _streak = 0;
  final List<String> _activityFeed = <String>[];
  final List<String> _codexEntries = <String>[];

  List<BrainRegion> get regions => List<BrainRegion>.unmodifiable(_catalog);

  Map<String, BrainRegionProgress> get progressByRegion =>
      UnmodifiableMapView<String, BrainRegionProgress>(_progress);

  BrainRegion? get selectedRegion {
    final selectedRegionId = _selectedRegionId;
    if (selectedRegionId == null) {
      return null;
    }

    return _regionById(selectedRegionId);
  }

  BrainRegionProgress? get selectedProgress {
    final selectedRegionId = _selectedRegionId;
    if (selectedRegionId == null) {
      return null;
    }

    return _progress[selectedRegionId];
  }

  BrainCaseFile? get activeCase {
    final activeCaseId = _activeCaseId;
    if (activeCaseId == null) {
      return null;
    }

    return _caseById(activeCaseId);
  }

  BrainCaseStage get caseStage => _caseStage;

  int get focus => _focus;
  int get signalStrength => _signalStrength;
  int get insight => _insight;
  int get streak => _streak;
  int get stabilizedCount =>
      _progress.values.where((e) => e.isStabilized).length;
  int get reachableCount => _progress.values.where((e) => e.isAvailable).length;
  int get resolvedCaseCount => _caseCatalog
      .where(
        (BrainCaseFile item) => _progress[item.targetRegionId]!.isStabilized,
      )
      .length;
  bool get expeditionComplete => _caseStage == BrainCaseStage.complete;
  bool get hasActiveCase => activeCase != null;
  bool get hasSelectedRegion => selectedRegion != null;

  bool get selectedRegionMatchesCase =>
      selectedRegion != null &&
      selectedRegion!.id == activeCase?.targetRegionId;

  bool get canSubmitHypothesis =>
      _caseStage == BrainCaseStage.investigation &&
      selectedRegion != null &&
      (selectedProgress?.isAvailable ?? false);

  bool get canLaunchSelectedMission =>
      _caseStage == BrainCaseStage.repair &&
      selectedRegionMatchesCase &&
      !(selectedProgress?.isStabilized ?? true);

  bool get canAdvanceCase => _caseStage == BrainCaseStage.debrief;

  List<String> get activityFeed =>
      List<String>.unmodifiable(_activityFeed.reversed.take(4));

  List<String> get codexEntries =>
      List<String>.unmodifiable(_codexEntries.reversed.take(3));

  String get progressLabel {
    if (expeditionComplete) {
      return 'Opening circuit restored';
    }

    return 'Resolved $resolvedCaseCount/${_caseCatalog.length} cases';
  }

  String get currentCaseLabel => activeCase?.caseCode ?? 'All cases complete';

  String get missionHeadline {
    final activeCase = this.activeCase;
    if (activeCase == null) {
      return 'All opening cases resolved';
    }

    switch (_caseStage) {
      case BrainCaseStage.investigation:
        return 'Localize the fault behind ${activeCase.title.toLowerCase()}';
      case BrainCaseStage.repair:
        return 'Repair ${selectedRegion?.name ?? _targetRegion.name}';
      case BrainCaseStage.debrief:
        return 'Validate the recovery and learn the circuit';
      case BrainCaseStage.complete:
        return 'Opening circuit restored';
    }
  }

  String get missionHint {
    final activeCase = this.activeCase;
    if (activeCase == null) {
      return 'The first case arc is complete. Add more cases or new repair types next.';
    }

    switch (_caseStage) {
      case BrainCaseStage.investigation:
        return activeCase.hypothesisPrompt;
      case BrainCaseStage.repair:
        return activeCase.repairObjective;
      case BrainCaseStage.debrief:
        return activeCase.explanation;
      case BrainCaseStage.complete:
        return 'The first case arc is complete. Add more cases or new repair types next.';
    }
  }

  String get caseStatus => _caseStatus;

  String get selectedMissionPrompt =>
      activeCase?.repairObjective ?? 'No active repair objective.';

  String get selectedSignalRule =>
      selectedRegion?.correctOption.label ?? 'Select a hypothesis first.';

  void reset({bool notify = true}) {
    _progress = <String, BrainRegionProgress>{
      for (final BrainRegion region in _catalog)
        region.id: const BrainRegionProgress(),
    };
    _progress[seedRegionId] = const BrainRegionProgress(
      state: BrainRegionState.reachable,
    );
    _selectedRegionId = null;
    _activeCaseId = _findNextCaseId();
    _caseStage = _activeCaseId == null
        ? BrainCaseStage.complete
        : BrainCaseStage.investigation;
    _caseStatus = _activeCaseId == null
        ? 'All opening cases are already resolved.'
        : 'Review the presenting problem, then choose the most likely region on the map.';
    _focus = _maxFocus;
    _signalStrength = 78;
    _insight = 0;
    _streak = 0;
    _activityFeed
      ..clear()
      ..add(
        'Case files are live. Start with the first symptom pattern and localize the failing circuit before repairing it.',
      );
    _codexEntries.clear();

    if (notify) {
      notifyListeners();
    }
  }

  void selectRegion(String regionId) {
    if (_caseStage != BrainCaseStage.investigation) {
      return;
    }

    final regionProgress = _progress[regionId];
    if (regionProgress == null || !regionProgress.isAvailable) {
      return;
    }

    if (_selectedRegionId == regionId) {
      return;
    }

    _selectedRegionId = regionId;
    _caseStatus =
        'Hypothesis set to ${selectedRegion!.name}. Compare it to the symptom pattern, then test the diagnosis.';
    _appendFeed('Hypothesis shifted to ${selectedRegion!.name}.');
    notifyListeners();
  }

  void submitHypothesis() {
    if (!canSubmitHypothesis || activeCase == null || selectedRegion == null) {
      return;
    }

    if (selectedRegionMatchesCase) {
      _caseStage = BrainCaseStage.repair;
      _caseStatus =
          'Localization confirmed. Launch the repair mission and see whether the behavior recovers.';
      _appendFeed(
        'Hypothesis confirmed: ${selectedRegion!.name} matches the symptom pattern in ${activeCase!.caseCode}.',
      );
    } else {
      _signalStrength = math.max(40, _signalStrength - 4);
      _streak = 0;
      _caseStatus = _buildMismatchMessage(selectedRegion!, activeCase!);
      _appendFeed(
        'Hypothesis mismatch: ${selectedRegion!.name} does not best explain ${activeCase!.title.toLowerCase()}.',
      );
    }

    notifyListeners();
  }

  void completeSelectedMission({required double integrity}) {
    if (!canLaunchSelectedMission ||
        activeCase == null ||
        selectedRegion == null) {
      return;
    }

    final currentProgress = selectedProgress!.copyWith(
      attempts: selectedProgress!.attempts + 1,
      state: BrainRegionState.stabilized,
    );
    final integrityValue = integrity.clamp(0.0, 1.0);
    final bonusInsight = integrityValue >= 0.92 ? 1 : 0;
    final signalGain = 8 + (integrityValue * 8).round();

    _progress[selectedRegion!.id] = currentProgress;
    _insight += selectedRegion!.rewardInsight + bonusInsight;
    _signalStrength = math.min(
      _maxSignalStrength,
      _signalStrength + signalGain,
    );
    _focus = math.min(_maxFocus, _focus + (integrityValue >= 0.82 ? 1 : 0));
    _streak += 1;
    _caseStage = BrainCaseStage.debrief;
    _caseStatus =
        'Repair successful. Compare the before and after state, then archive the explanation.';
    _appendFeed(
      'Signal trace stabilized ${selectedRegion!.name} at ${(integrityValue * 100).round()}% integrity.',
    );
    _appendFeed(activeCase!.validationSummary);
    if (bonusInsight > 0) {
      _appendFeed(
        'High-integrity routing bonus secured. Extra insight archived.',
      );
    }
    _appendCodex('${activeCase!.caseCode}: ${activeCase!.explanation}');
    _unlockConnections(selectedRegion!);
    _checkCompletion();
    notifyListeners();
  }

  void failSelectedMission({required String reason}) {
    if (!canLaunchSelectedMission) {
      return;
    }

    _progress[selectedRegion!.id] = selectedProgress!.copyWith(
      attempts: selectedProgress!.attempts + 1,
    );
    _focus = math.max(0, _focus - 1);
    _signalStrength = math.max(34, _signalStrength - 10);
    _streak = 0;
    _caseStatus = '$reason Re-enter the repair once the route is clear.';
    _appendFeed(reason);
    _checkFocusReset();
    notifyListeners();
  }

  void advanceCase() {
    if (!canAdvanceCase) {
      return;
    }

    _selectedRegionId = null;
    _activeCaseId = _findNextCaseId();
    if (_activeCaseId == null) {
      _caseStage = BrainCaseStage.complete;
      _caseStatus =
          'All opening cases resolved. The next step is adding more cases or new repair mechanics.';
      _appendFeed(
        'All opening cases resolved. The first diagnostic loop is complete.',
      );
    } else {
      _caseStage = BrainCaseStage.investigation;
      _caseStatus =
          'New case loaded. Observe the failure first, then choose a likely region.';
      _appendFeed(
        'New case file loaded: ${activeCase!.caseCode} ${activeCase!.title}.',
      );
    }

    notifyListeners();
  }

  void jumpToNextFrontier() {
    if (_caseStage != BrainCaseStage.investigation) {
      return;
    }

    final reachable = _catalog
        .where((BrainRegion region) => _progress[region.id]!.isAvailable)
        .toList(growable: false);
    if (reachable.isEmpty) {
      return;
    }

    if (_selectedRegionId == null) {
      _selectedRegionId = reachable.first.id;
      _caseStatus =
          'Hypothesis set to ${selectedRegion!.name}. Compare it to the symptom pattern, then test the diagnosis.';
      notifyListeners();
      return;
    }

    final currentIndex = reachable.indexWhere(
      (BrainRegion region) => region.id == _selectedRegionId,
    );
    final nextIndex = currentIndex == -1
        ? 0
        : (currentIndex + 1) % reachable.length;
    _selectedRegionId = reachable[nextIndex].id;
    _caseStatus =
        'Hypothesis set to ${selectedRegion!.name}. Compare it to the symptom pattern, then test the diagnosis.';
    notifyListeners();
  }

  void _unlockConnections(BrainRegion region) {
    final unlockedNames = <String>[];

    for (final String connectionId in region.connections) {
      final current = _progress[connectionId];
      if (current == null || current.isAvailable) {
        continue;
      }

      _progress[connectionId] = current.copyWith(
        state: BrainRegionState.reachable,
      );
      unlockedNames.add(_regionById(connectionId).name);
    }

    if (unlockedNames.isNotEmpty) {
      _appendFeed('New pathways opened: ${unlockedNames.join(', ')}.');
    }
  }

  String _buildMismatchMessage(BrainRegion region, BrainCaseFile activeCase) {
    final targetRegion = _targetRegion;
    return '${region.name} mainly governs ${region.discipline.label.toLowerCase()}, but ${activeCase.title.toLowerCase()} points to ${targetRegion.name} because ${activeCase.differentialNote}.';
  }

  BrainRegion _regionById(String regionId) {
    return _catalog.firstWhere((BrainRegion region) => region.id == regionId);
  }

  BrainCaseFile _caseById(String caseId) {
    return _caseCatalog.firstWhere((BrainCaseFile item) => item.id == caseId);
  }

  BrainRegion get _targetRegion => _regionById(activeCase!.targetRegionId);

  String? _findNextCaseId() {
    for (final BrainCaseFile item in _caseCatalog) {
      final progress = _progress[item.targetRegionId];
      if (progress != null && progress.isAvailable && !progress.isStabilized) {
        return item.id;
      }
    }

    return null;
  }

  void _appendFeed(String message) {
    _activityFeed.add(message);
    if (_activityFeed.length > 12) {
      _activityFeed.removeAt(0);
    }
  }

  void _appendCodex(String entry) {
    if (_codexEntries.contains(entry)) {
      return;
    }

    _codexEntries.add(entry);
  }

  void _checkFocusReset() {
    if (_focus == 0 && !expeditionComplete) {
      _focus = _maxFocus;
      _signalStrength = math.min(_maxSignalStrength, _signalStrength + 4);
      _appendFeed(
        'Neural lens recalibrated. Focus restored for the next sweep.',
      );
    }
  }

  void _checkCompletion() {
    if (_findNextCaseId() == null) {
      _appendFeed(
        'This repair closes the opening case arc. Archive the explanation and move to the final summary.',
      );
    }
  }
}
