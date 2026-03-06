import 'brain_case_file.dart';

const List<BrainCaseFile> brainCaseCatalog = <BrainCaseFile>[
  BrainCaseFile(
    id: 'case_prefrontal',
    caseCode: 'Case 01',
    title: 'Frozen Plan',
    presentingProblem:
        'A patient wants to reach for a cup, but keeps restarting the sequence before movement even really begins.',
    observationSummary:
        'Goal recognition is intact, but the action plan does not hold together long enough to execute cleanly.',
    targetRegionId: 'prefrontal',
    observationNotes: <String>[
      'The patient can describe the goal out loud.',
      'Strength is available once someone else cues each step.',
      'Self-directed attempts stall and reset before commitment.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Goal selection',
        impairedValue: 'Intent present but unstable',
        restoredValue: 'Intent held and prioritized',
      ),
      CaseSceneMetric(
        label: 'Action sequencing',
        impairedValue: 'Steps fragment before launch',
        restoredValue: 'Steps chain in order',
      ),
      CaseSceneMetric(
        label: 'Movement output',
        impairedValue: 'Available only with guidance',
        restoredValue: 'Self-directed movement starts cleanly',
      ),
    ],
    hypothesisPrompt:
        'Which region would fail here if planning is breaking before force and articulation are even engaged?',
    repairObjective:
        'Reinforce the executive route that holds the plan together before it fans out into movement and memory.',
    validationSummary:
        'The patient now keeps the goal online long enough to begin the reach in the right order.',
    explanation:
        'The prefrontal cortex stabilizes goals, inhibits competing impulses, and sequences actions before movement starts.',
    differentialNote:
        'the main failure is planning the action, not producing force or detecting the target',
  ),
  BrainCaseFile(
    id: 'case_broca',
    caseCode: 'Case 02',
    title: 'Words Stuck in Assembly',
    presentingProblem:
        'A patient understands a warning and knows what they want to say, but speech comes out halting and effortful.',
    observationSummary:
        'Comprehension is preserved, but turning thought into fluent articulation keeps breaking down.',
    targetRegionId: 'broca',
    observationNotes: <String>[
      'The patient follows instructions correctly.',
      'They become frustrated because the message is clear in their head.',
      'Speech output is sparse and slow rather than meaningless.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Comprehension',
        impairedValue: 'Mostly intact',
        restoredValue: 'Still intact',
      ),
      CaseSceneMetric(
        label: 'Speech planning',
        impairedValue: 'Articulation pattern collapses',
        restoredValue: 'Speech pattern stays ordered',
      ),
      CaseSceneMetric(
        label: 'Verbal output',
        impairedValue: 'Short, effortful bursts',
        restoredValue: 'Fluent phrase assembly',
      ),
    ],
    hypothesisPrompt:
        'Which language region fits a production deficit when comprehension is still mostly working?',
    repairObjective:
        'Restore the route that converts an internal sentence plan into an articulation sequence the motor system can execute.',
    validationSummary:
        'The warning now comes out as a connected phrase instead of broken fragments.',
    explanation:
        "Broca's area helps assemble and sequence speech output. Damage here disrupts expression more than comprehension.",
    differentialNote:
        'the patient knows the message already; the breakdown is in producing speech, not understanding it',
  ),
  BrainCaseFile(
    id: 'case_motor',
    caseCode: 'Case 03',
    title: 'Command Without Clean Output',
    presentingProblem:
        'A patient knows exactly where to tap, but voluntary movement launches weakly and drifts off target.',
    observationSummary:
        'The plan and target are intact, yet the outgoing body command is unstable once execution begins.',
    targetRegionId: 'motor',
    observationNotes: <String>[
      'The patient can point to the intended target on a diagram.',
      'They report what movement they are trying to perform.',
      'The actual reach is underpowered and badly directed.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Target knowledge',
        impairedValue: 'Correct target identified',
        restoredValue: 'Still correct',
      ),
      CaseSceneMetric(
        label: 'Voluntary command',
        impairedValue: 'Weak and poorly mapped',
        restoredValue: 'Body map drives the right muscles',
      ),
      CaseSceneMetric(
        label: 'Reach accuracy',
        impairedValue: 'Misses despite clear intent',
        restoredValue: 'Reaches the target directly',
      ),
    ],
    hypothesisPrompt:
        'Which region is most likely failing when intention is intact but the outgoing command to the body is not?',
    repairObjective:
        'Re-establish the body-mapped command channel so voluntary movement can leave planning networks and reach the muscles cleanly.',
    validationSummary:
        'The patient now sends a direct, usable motor command and reaches the target instead of wavering off line.',
    explanation:
        'The motor cortex converts selected actions into muscle-specific output. When it is unstable, intent does not become clean movement.',
    differentialNote:
        'the person knows what to do and where to do it; the deficit is in executing the command itself',
  ),
  BrainCaseFile(
    id: 'case_parietal',
    caseCode: 'Case 04',
    title: 'Body Map Drift',
    presentingProblem:
        'A patient can move, but keeps misplacing their hand because touch, position, and space are not lining up.',
    observationSummary:
        'The body is active, yet the internal map of where the body is in space keeps slipping.',
    targetRegionId: 'parietal',
    observationNotes: <String>[
      'The patient reports that the target feels farther away than it looks.',
      'Touch feedback arrives, but it does not settle the estimate.',
      'Correcting mid-reach only partly helps.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Touch feedback',
        impairedValue: 'Present but not integrated',
        restoredValue: 'Feeds one spatial estimate',
      ),
      CaseSceneMetric(
        label: 'Body-in-space map',
        impairedValue: 'Conflicted and drifting',
        restoredValue: 'Aligned across inputs',
      ),
      CaseSceneMetric(
        label: 'Targeting',
        impairedValue: 'Overshoots and re-corrects',
        restoredValue: 'Moves with spatial confidence',
      ),
    ],
    hypothesisPrompt:
        'Which region would break if the body can still move but spatial awareness and sensory fusion are compromised?',
    repairObjective:
        'Restore the sensory integration lane so touch and position converge into one stable spatial estimate.',
    validationSummary:
        'The patient now knows where their hand is relative to the target and stops overshooting.',
    explanation:
        'The parietal cortex integrates sensory and spatial information into a usable body map. Without it, aiming and navigation drift.',
    differentialNote:
        'the output muscles still work; the broken part is the spatial estimate that guides them',
  ),
  BrainCaseFile(
    id: 'case_hippocampus',
    caseCode: 'Case 05',
    title: 'Route That Evaporates',
    presentingProblem:
        'A patient finds a clue, turns away for a moment, and cannot retain where it belonged or when it happened.',
    observationSummary:
        'Experience is being registered, but the episode is not sticking to context, place, and sequence.',
    targetRegionId: 'hippocampus',
    observationNotes: <String>[
      'The clue is recognized in the moment.',
      'A minute later, the patient cannot place it back into the route.',
      'Threat detection and movement remain otherwise usable.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Immediate recognition',
        impairedValue: 'Works in the moment',
        restoredValue: 'Still works',
      ),
      CaseSceneMetric(
        label: 'Context binding',
        impairedValue: 'Place and sequence fall apart',
        restoredValue: 'Event anchors to route and time',
      ),
      CaseSceneMetric(
        label: 'Recall',
        impairedValue: 'Clue cannot be relocated',
        restoredValue: 'Clue returns with context',
      ),
    ],
    hypothesisPrompt:
        'Which region fits a failure to bind events to place and sequence rather than a failure to see or speak about them?',
    repairObjective:
        'Reinforce the memory-indexing path that binds a clue to where and when it occurred.',
    validationSummary:
        'The clue now comes back with its route context instead of feeling like an isolated fragment.',
    explanation:
        'The hippocampus helps encode experiences into contextual memory so they can be recalled with place and timing intact.',
    differentialNote:
        'the clue is noticed initially; what fails is keeping it attached to context after the moment passes',
  ),
  BrainCaseFile(
    id: 'case_amygdala',
    caseCode: 'Case 06',
    title: 'Every Signal Feels Critical',
    presentingProblem:
        'A patient reacts to a neutral cue like it is a threat, flooding the whole system with urgency.',
    observationSummary:
        'Salience tagging is overfiring, so ordinary signals keep hijacking attention and action.',
    targetRegionId: 'amygdala',
    observationNotes: <String>[
      'The cue itself is mild and familiar.',
      'The patient still perceives it accurately.',
      'The reaction is disproportionate and immediate.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Cue detection',
        impairedValue: 'Accurate',
        restoredValue: 'Accurate',
      ),
      CaseSceneMetric(
        label: 'Threat weighting',
        impairedValue: 'Everything marked urgent',
        restoredValue: 'Salience scaled to the cue',
      ),
      CaseSceneMetric(
        label: 'Network tone',
        impairedValue: 'Overloaded and reactive',
        restoredValue: 'Responsive but selective',
      ),
    ],
    hypothesisPrompt:
        'Which region should you suspect when the stimulus is perceived correctly but its emotional weight is far too high?',
    repairObjective:
        'Calibrate the urgency filter so salient cues stay tagged without turning every signal into an alarm.',
    validationSummary:
        'The patient now notices the cue without letting it trigger a full threat cascade.',
    explanation:
        'The amygdala assigns emotional salience and urgency. When it overfires, neutral input can dominate the whole network.',
    differentialNote:
        'the core problem is emotional weighting, not seeing the cue or forming the words to describe it',
  ),
  BrainCaseFile(
    id: 'case_visual',
    caseCode: 'Case 07',
    title: 'Pathway Hidden in Plain Sight',
    presentingProblem:
        'A patient stares at a flickering escape route but cannot extract stable edges and motion from the scene.',
    observationSummary:
        'The world is arriving at the eyes, yet the visual features needed to parse the route are not resolving.',
    targetRegionId: 'visual',
    observationNotes: <String>[
      'The patient can still orient toward the scene.',
      'They describe it as a blur of movement without useful structure.',
      'Motor output improves if someone else points out the path.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Scene exposure',
        impairedValue: 'Incoming but noisy',
        restoredValue: 'Incoming and structured',
      ),
      CaseSceneMetric(
        label: 'Edge and motion parsing',
        impairedValue: 'Unstable features',
        restoredValue: 'Stable route cues',
      ),
      CaseSceneMetric(
        label: 'Path detection',
        impairedValue: 'Cannot isolate the corridor',
        restoredValue: 'Pathway stands out clearly',
      ),
    ],
    hypothesisPrompt:
        'Which region fits a failure to parse features from vision when the person can still orient and move once guided?',
    repairObjective:
        'Restore the feature-extraction route so edges, contrast, and motion resolve into a usable scene.',
    validationSummary:
        'The escape route now separates cleanly from the background and becomes actionable.',
    explanation:
        'The visual cortex reconstructs meaningful features from incoming signals. Without it, scenes remain noisy and hard to interpret.',
    differentialNote:
        'the environment is present, but the visual features never organize into a clear scene',
  ),
  BrainCaseFile(
    id: 'case_cerebellum',
    caseCode: 'Case 08',
    title: 'Movement Without Refinement',
    presentingProblem:
        'A patient can initiate movement, but timing, correction, and smoothness collapse as the action unfolds.',
    observationSummary:
        'The main motor command is present, but fine-grained error correction is too weak to keep the motion precise.',
    targetRegionId: 'cerebellum',
    observationNotes: <String>[
      'The patient starts the action on purpose.',
      'The first pass is close, but wobble grows instead of shrinking.',
      'Repeated corrections overshoot in both directions.',
    ],
    sceneMetrics: <CaseSceneMetric>[
      CaseSceneMetric(
        label: 'Movement initiation',
        impairedValue: 'Present',
        restoredValue: 'Present',
      ),
      CaseSceneMetric(
        label: 'Timing correction',
        impairedValue: 'Late and uneven',
        restoredValue: 'Rapid and precise',
      ),
      CaseSceneMetric(
        label: 'Motion quality',
        impairedValue: 'Jerky with overshoot',
        restoredValue: 'Smooth and accurate',
      ),
    ],
    hypothesisPrompt:
        'Which region should you target if the action begins correctly but fine adjustment and timing keep collapsing?',
    repairObjective:
        'Restore the corrective loop that smooths timing and force once movement is already underway.',
    validationSummary:
        'The patient now fine-tunes the action in flight instead of wobbling past the target.',
    explanation:
        'The cerebellum refines timing, balance, and error correction. It makes movement precise after the main command has started.',
    differentialNote:
        'the command exists already; what fails is the fast correction that makes it accurate',
  ),
];
