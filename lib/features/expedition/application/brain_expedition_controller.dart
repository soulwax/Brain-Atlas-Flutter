import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../domain/brain_region.dart';
import '../domain/brain_region_catalog.dart';

class BrainExpeditionController extends ChangeNotifier {
  BrainExpeditionController({List<BrainRegion> catalog = brainRegionCatalog})
    : _catalog = catalog {
    reset(notify: false);
  }

  static const int _maxFocus = 4;
  static const int _maxSignalStrength = 100;

  final List<BrainRegion> _catalog;

  late Map<String, BrainRegionProgress> _progress;
  String _selectedRegionId = seedRegionId;
  int _focus = _maxFocus;
  int _signalStrength = 78;
  int _insight = 0;
  int _streak = 0;
  final List<String> _activityFeed = <String>[];
  final List<String> _codexEntries = <String>[];

  List<BrainRegion> get regions => List<BrainRegion>.unmodifiable(_catalog);

  Map<String, BrainRegionProgress> get progressByRegion =>
      UnmodifiableMapView<String, BrainRegionProgress>(_progress);

  BrainRegion get selectedRegion => _catalog.firstWhere(
    (BrainRegion region) => region.id == _selectedRegionId,
  );

  BrainRegionProgress get selectedProgress => _progress[_selectedRegionId]!;

  int get focus => _focus;
  int get signalStrength => _signalStrength;
  int get insight => _insight;
  int get streak => _streak;
  int get stabilizedCount =>
      _progress.values.where((e) => e.isStabilized).length;
  int get reachableCount => _progress.values.where((e) => e.isAvailable).length;
  bool get expeditionComplete => stabilizedCount == _catalog.length;

  List<String> get activityFeed =>
      List<String>.unmodifiable(_activityFeed.reversed.take(4));

  List<String> get codexEntries =>
      List<String>.unmodifiable(_codexEntries.reversed.take(3));

  String get progressLabel => 'Stabilized $stabilizedCount/${_catalog.length}';
  bool get canLaunchSelectedMission =>
      selectedProgress.isAvailable && !selectedProgress.isStabilized;
  String get selectedMissionPrompt => selectedRegion.challengePrompt;
  String get selectedSignalRule => selectedRegion.correctOption.label;

  String get missionHeadline {
    if (expeditionComplete) {
      return 'Opening circuit stabilized';
    }

    return 'Trace and stabilize ${selectedRegion.name}';
  }

  String get missionHint {
    if (expeditionComplete) {
      return 'The foundation is ready for future layers: timed routes, boss networks, and a 3D/WebGL brain shell.';
    }

    final nextUnlocks = selectedRegion.connections
        .where((String id) => _progress[id]?.state == BrainRegionState.locked)
        .map(
          (String id) =>
              _catalog.firstWhere((BrainRegion region) => region.id == id).name,
        )
        .toList(growable: false);

    if (nextUnlocks.isEmpty) {
      return 'This node closes part of the route. Stabilize it to tighten the overall network.';
    }

    return 'Stabilize this node to unlock ${nextUnlocks.join(', ')}.';
  }

  void reset({bool notify = true}) {
    _progress = <String, BrainRegionProgress>{
      for (final BrainRegion region in _catalog)
        region.id: const BrainRegionProgress(),
    };
    _progress[seedRegionId] = const BrainRegionProgress(
      state: BrainRegionState.reachable,
    );
    _selectedRegionId = seedRegionId;
    _focus = _maxFocus;
    _signalStrength = 78;
    _insight = 0;
    _streak = 0;
    _activityFeed
      ..clear()
      ..add(
        'Prefrontal telemetry is online. Stabilize the first executive hub to branch deeper into the brain.',
      );
    _codexEntries.clear();

    if (notify) {
      notifyListeners();
    }
  }

  void selectRegion(String regionId) {
    final regionProgress = _progress[regionId];
    if (regionProgress == null || !regionProgress.isAvailable) {
      return;
    }

    if (_selectedRegionId == regionId) {
      return;
    }

    _selectedRegionId = regionId;
    _appendFeed('Telemetry locked on ${selectedRegion.name}.');
    notifyListeners();
  }

  void completeSelectedMission({required double integrity}) {
    if (!canLaunchSelectedMission) {
      return;
    }

    final currentProgress = selectedProgress.copyWith(
      attempts: selectedProgress.attempts + 1,
      state: BrainRegionState.stabilized,
    );
    final integrityValue = integrity.clamp(0.0, 1.0);
    final bonusInsight = integrityValue >= 0.92 ? 1 : 0;
    final signalGain = 8 + (integrityValue * 8).round();

    _progress[_selectedRegionId] = currentProgress;
    _insight += selectedRegion.rewardInsight + bonusInsight;
    _signalStrength = math.min(
      _maxSignalStrength,
      _signalStrength + signalGain,
    );
    _focus = math.min(_maxFocus, _focus + (integrityValue >= 0.82 ? 1 : 0));
    _streak += 1;
    _appendFeed(selectedRegion.correctOption.feedback);
    _appendFeed(
      'Signal trace stabilized ${selectedRegion.name} at ${(integrityValue * 100).round()}% integrity.',
    );
    if (bonusInsight > 0) {
      _appendFeed(
        'High-integrity routing bonus secured. Extra insight archived.',
      );
    }
    _appendCodex(selectedRegion.codexEntry);
    _unlockConnections(selectedRegion);
    _selectNextFrontier();

    _checkFocusReset();
    _checkCompletion();

    notifyListeners();
  }

  void failSelectedMission({required String reason}) {
    if (!canLaunchSelectedMission) {
      return;
    }

    _progress[_selectedRegionId] = selectedProgress.copyWith(
      attempts: selectedProgress.attempts + 1,
    );
    _focus = math.max(0, _focus - 1);
    _signalStrength = math.max(34, _signalStrength - 10);
    _streak = 0;
    _appendFeed(reason);
    _checkFocusReset();
    notifyListeners();
  }

  void jumpToNextFrontier() {
    if (_selectNextFrontier()) {
      _appendFeed('Jumped to the next reachable hotspot.');
      notifyListeners();
    }
  }

  bool _selectNextFrontier() {
    final nextRegion = _catalog.firstWhere(
      (BrainRegion region) =>
          _progress[region.id]!.state == BrainRegionState.reachable,
      orElse: () => selectedRegion,
    );

    if (nextRegion.id == _selectedRegionId) {
      return false;
    }

    _selectedRegionId = nextRegion.id;
    return true;
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
      unlockedNames.add(
        _catalog.firstWhere((BrainRegion item) => item.id == connectionId).name,
      );
    }

    if (unlockedNames.isNotEmpty) {
      _appendFeed('New pathways opened: ${unlockedNames.join(', ')}.');
    }
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
    if (expeditionComplete) {
      _appendFeed(
        'Opening network complete. The map loop now supports mission-based progression.',
      );
    }
  }
}
