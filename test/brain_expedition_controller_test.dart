import 'package:flutter_test/flutter_test.dart';
import 'package:nyris_neurology/features/expedition/application/brain_expedition_controller.dart';
import 'package:nyris_neurology/features/expedition/domain/brain_region.dart';

void main() {
  group('BrainExpeditionController', () {
    test('successful signal trace unlocks connected nodes', () {
      final controller = BrainExpeditionController();

      controller.completeSelectedMission(integrity: 0.94);

      expect(
        controller.progressByRegion['prefrontal']?.state,
        BrainRegionState.stabilized,
      );
      expect(
        controller.progressByRegion['broca']?.state,
        BrainRegionState.reachable,
      );
      expect(
        controller.progressByRegion['motor']?.state,
        BrainRegionState.reachable,
      );
      expect(controller.insight, 4);
    });

    test('reset returns the expedition to the initial state', () {
      final controller = BrainExpeditionController();

      controller.completeSelectedMission(integrity: 0.91);
      controller.reset();

      expect(
        controller.progressByRegion['prefrontal']?.state,
        BrainRegionState.reachable,
      );
      expect(
        controller.progressByRegion['broca']?.state,
        BrainRegionState.locked,
      );
      expect(controller.insight, 0);
      expect(controller.focus, 4);
      expect(controller.stabilizedCount, 0);
    });

    test('failed signal trace spends focus and keeps the region reachable', () {
      final controller = BrainExpeditionController();

      controller.failSelectedMission(
        reason: 'Signal broke outside the stable corridor.',
      );

      expect(
        controller.progressByRegion['prefrontal']?.state,
        BrainRegionState.reachable,
      );
      expect(controller.focus, 3);
      expect(controller.streak, 0);
      expect(controller.signalStrength, 68);
    });
  });
}
