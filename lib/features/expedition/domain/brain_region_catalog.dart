import 'brain_region.dart';

const String seedRegionId = 'prefrontal';

const List<BrainRegion> brainRegionCatalog = <BrainRegion>[
  BrainRegion(
    id: 'prefrontal',
    name: 'Prefrontal Cortex',
    shortLabel: 'Prefrontal',
    summary:
        'Handles planning, inhibition, and flexible decision making. It is the best first hub because it naturally branches into multiple systems.',
    discipline: BrainRegionDiscipline.planning,
    positionX: 0.18,
    positionY: 0.33,
    radiusFactor: 0.072,
    connections: <String>['broca', 'motor', 'hippocampus'],
    challengePrompt:
        'A movement goal appears, but the route is noisy. Which signal should fire first?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Sequence the plan before committing the action',
        feedback:
            'Planning wins. The prefrontal cortex stabilizes once intent is ordered before movement.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Push emotion to maximum and let reflexes decide',
        feedback:
            'That floods the network with urgency instead of control. The signal remains unstable.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Wait for visual cortex to finish every detail first',
        feedback:
            'Vision helps, but the executive signal still has to choose and prioritize next steps.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Executive scaffolding restored. Future missions can branch into speech, motion, and memory with less noise.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'broca',
    name: "Broca's Area",
    shortLabel: 'Broca',
    summary:
        'Transforms structured thoughts into speech production patterns and tightly coordinates with motor planning.',
    discipline: BrainRegionDiscipline.language,
    positionX: 0.29,
    positionY: 0.56,
    radiusFactor: 0.062,
    connections: <String>['motor', 'amygdala'],
    challengePrompt:
        'The player wants to warn the team quickly. Which route best turns intention into speech?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Build an articulation pattern and hand it to motor systems',
        feedback:
            "Correct. Broca's Area stabilizes when language plans are converted into coordinated speech output.",
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Store the message silently in long-term memory first',
        feedback:
            'Useful for retention, but not for immediate speech production.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Trigger visual edge detection to sharpen the sentence',
        feedback: 'Visual processing does not assemble articulation commands.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Language routing online. Spoken mission cues can now propagate with less delay.',
    rewardInsight: 2,
  ),
  BrainRegion(
    id: 'motor',
    name: 'Motor Cortex',
    shortLabel: 'Motor',
    summary:
        'Executes voluntary movement by translating planned actions into body-specific motor commands.',
    discipline: BrainRegionDiscipline.movement,
    positionX: 0.42,
    positionY: 0.34,
    radiusFactor: 0.065,
    connections: <String>['parietal', 'cerebellum'],
    challengePrompt:
        'A precise reach is needed to capture a drifting signal. Which command best fits the motor cortex?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Send body-mapped output to the muscles in sequence',
        feedback:
            'Correct. Movement becomes stable when muscle groups receive ordered motor instructions.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Tag the target with emotional urgency instead',
        feedback:
            'Urgency adds salience, but it does not execute the movement.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Convert the reach into a visual memory loop',
        feedback: 'The task still needs outgoing motor commands, not replay.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Voluntary movement restored. Physical interaction challenges can now be layered into future missions.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'parietal',
    name: 'Parietal Cortex',
    shortLabel: 'Parietal',
    summary:
        'Combines touch, spatial awareness, and body positioning into a usable map of the environment.',
    discipline: BrainRegionDiscipline.sensory,
    positionX: 0.58,
    positionY: 0.29,
    radiusFactor: 0.062,
    connections: <String>['visual', 'hippocampus'],
    challengePrompt:
        'Signals from touch and position disagree. What stabilizes the body map?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Fuse the sensory streams into a single spatial estimate',
        feedback:
            'Correct. The parietal cortex resolves conflict by integrating sensory evidence into one map.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Strip away all motion and trust language alone',
        feedback: 'Language cannot replace the body-in-space estimate.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Store each signal separately and compare them later',
        feedback:
            'The region must resolve the estimate in real time, not postpone it.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Spatial synthesis restored. Navigation and aiming loops have a reliable sensory frame again.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'hippocampus',
    name: 'Hippocampus',
    shortLabel: 'Hippocampus',
    summary:
        'Encodes context, episodes, and navigational memory. It works well as the mid-run progression gate.',
    discipline: BrainRegionDiscipline.memory,
    positionX: 0.53,
    positionY: 0.63,
    radiusFactor: 0.06,
    connections: <String>['amygdala', 'visual'],
    challengePrompt:
        'A clue must be remembered with place and timing intact. Which operation fits the hippocampus?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Bind the event to context so it can be recalled later',
        feedback:
            'Correct. The hippocampus stabilizes when it links the moment to location and sequence.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Convert the clue into a muscle rehearsal loop',
        feedback:
            'That supports procedural learning, not episodic memory binding.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Reduce the clue to pure threat detection',
        feedback:
            'Threat tagging belongs elsewhere. The memory trace still needs context.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Memory indexing restored. Route-based missions and recall challenges can now span multiple regions.',
    rewardInsight: 4,
  ),
  BrainRegion(
    id: 'amygdala',
    name: 'Amygdala',
    shortLabel: 'Amygdala',
    summary:
        'Evaluates salience and emotional urgency. It adds stakes to the exploration loop without replacing control.',
    discipline: BrainRegionDiscipline.emotion,
    positionX: 0.43,
    positionY: 0.73,
    radiusFactor: 0.056,
    connections: <String>['cerebellum'],
    challengePrompt:
        'A sudden stimulus appears. What is the amygdala supposed to do?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label:
            'Tag the stimulus with emotional salience for the rest of the network',
        feedback:
            'Correct. The amygdala stabilizes once the network knows which signals deserve urgency.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Translate the threat directly into spoken grammar',
        feedback:
            'Speech can report the event, but emotional tagging happens first.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Ignore it until memory completes long-form encoding',
        feedback: 'That is too slow. Salience has to be assigned immediately.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Emotional weighting restored. Dynamic tension systems can now modulate otherwise static puzzles.',
    rewardInsight: 2,
  ),
  BrainRegion(
    id: 'visual',
    name: 'Visual Cortex',
    shortLabel: 'Visual',
    summary:
        'Processes contrast, edges, motion, and shape into visual features that the rest of the game can exploit.',
    discipline: BrainRegionDiscipline.vision,
    positionX: 0.81,
    positionY: 0.47,
    radiusFactor: 0.066,
    connections: <String>['cerebellum'],
    challengePrompt:
        'A hidden pathway flickers on the far side of the map. Which operation restores visual clarity?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Decode edges and motion into a usable scene',
        feedback:
            'Correct. Visual cortex stability comes from turning raw input into structured features.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Force the muscles to mirror the signal pattern',
        feedback: 'Motor output does not reconstruct the scene.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Suppress detail until only emotion remains',
        feedback:
            'That removes the information needed to perceive the pathway.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Visual reconstruction online. Future missions can add hidden-object, tracing, and contrast-based mechanics.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'cerebellum',
    name: 'Cerebellum',
    shortLabel: 'Cerebellum',
    summary:
        'Fine-tunes timing, balance, and corrective feedback. It serves as the final stabilizer in the opening network.',
    discipline: BrainRegionDiscipline.coordination,
    positionX: 0.77,
    positionY: 0.74,
    radiusFactor: 0.068,
    connections: <String>[],
    challengePrompt:
        'The whole network is online but sloppy. What makes the movement loop feel precise?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Apply rapid error correction to timing and force',
        feedback:
            'Correct. The cerebellum closes the loop by smoothing timing and precision errors.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Replace planning with instinct and stop correcting',
        feedback: 'Precision drops fast without corrective feedback.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Convert the signal entirely into visual contrast',
        feedback: 'Seeing the error is not the same as correcting it.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Coordination stabilized. The first brain circuit is complete and ready for deeper mission layers.',
    rewardInsight: 4,
  ),
];
