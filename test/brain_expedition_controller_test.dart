import 'package:flutter_test/flutter_test.dart';
import 'package:nyris_neurology/features/expedition/application/brain_expedition_controller.dart';
import 'package:nyris_neurology/features/expedition/domain/brain_case_file.dart';
import 'package:nyris_neurology/features/expedition/domain/brain_region.dart';

void main() {
  group('BrainExpeditionController', () {
    test(
      'correct diagnosis plus successful repair unlocks connected nodes',
      () {
        final controller = BrainExpeditionController();

        expect(controller.activeCase?.targetRegionId, 'prefrontal');

        controller.selectRegion('prefrontal');
        controller.submitHypothesis();
        controller.completeSelectedMission(integrity: 0.94);

        expect(controller.caseStage, BrainCaseStage.debrief);
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
      },
    );

    test(
      'wrong diagnosis keeps the case in investigation and lightly penalizes signal',
      () {
        final controller = BrainExpeditionController();

        controller.selectRegion('prefrontal');
        controller.submitHypothesis();
        controller.completeSelectedMission(integrity: 0.82);
        controller.advanceCase();
        controller.selectRegion('motor');
        controller.submitHypothesis();

        expect(controller.caseStage, BrainCaseStage.investigation);
        expect(controller.signalStrength, 89);
        expect(controller.caseStatus, contains("points to Broca's Area"));
      },
    );

    test('advanceCase loads the next reachable case after debrief', () {
      final controller = BrainExpeditionController();

      controller.selectRegion('prefrontal');
      controller.submitHypothesis();
      controller.completeSelectedMission(integrity: 0.88);
      controller.advanceCase();

      expect(controller.caseStage, BrainCaseStage.investigation);
      expect(controller.activeCase?.targetRegionId, 'broca');
      expect(controller.selectedRegion, isNull);
    });

    test('failed repair spends focus and keeps the region reachable', () {
      final controller = BrainExpeditionController();

      controller.selectRegion('prefrontal');
      controller.submitHypothesis();
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
      expect(controller.caseStage, BrainCaseStage.repair);
    });

    test('reset returns the expedition to the initial diagnostic state', () {
      final controller = BrainExpeditionController();

      controller.selectRegion('prefrontal');
      controller.submitHypothesis();
      controller.completeSelectedMission(integrity: 0.91);
      controller.reset();

      expect(controller.caseStage, BrainCaseStage.investigation);
      expect(controller.activeCase?.targetRegionId, 'prefrontal');
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
      expect(controller.selectedRegion, isNull);
    });
  });
}
