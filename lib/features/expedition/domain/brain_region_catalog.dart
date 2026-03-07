import 'brain_region.dart';

const String seedRegionId = 'prefrontal';

const List<BrainRegion> brainRegionCatalog = <BrainRegion>[
  BrainRegion(
    id: 'prefrontal',
    name: 'Prefrontal Cortex',
    shortLabel: 'PFC',
    summary:
        'Handles planning, inhibition, flexible decision making, and the ability to hold a goal long enough to act on it.',
    primaryRole:
        'Keeps goals stable, suppresses distractions, and sequences actions before they leave for movement or speech systems.',
    failurePattern:
        'Actions fragment, priorities collapse, and behavior becomes reactive instead of deliberate.',
    networkRole:
        'Acts as an executive hub that coordinates language, memory, and motor plans.',
    everydayExample:
        'Planning the steps to make coffee while ignoring distractions from other tasks.',
    quickFacts: <String>[
      'Supports working memory and inhibition.',
      'Helps compare options before committing.',
      'Often acts before movement systems ever fire.',
    ],
    discipline: BrainRegionDiscipline.planning,
    positionX: 0.16,
    positionY: 0.3,
    radiusFactor: 0.062,
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
        'Transforms structured thoughts into speech production patterns and coordinates tightly with motor planning.',
    primaryRole:
        'Builds articulation sequences so internal language can become spoken output.',
    failurePattern:
        'The person knows what they want to say, but speech becomes effortful, sparse, and broken into fragments.',
    networkRole:
        'Bridges executive intention and motor speech execution.',
    everydayExample:
        'Turning a clear thought into a fluent spoken sentence during conversation.',
    quickFacts: <String>[
      'Commonly linked to expressive aphasia.',
      'Works with motor systems for articulation.',
      'Usually affects output more than comprehension.',
    ],
    discipline: BrainRegionDiscipline.language,
    positionX: 0.24,
    positionY: 0.55,
    radiusFactor: 0.052,
    connections: <String>['motor', 'insula', 'wernicke'],
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
    shortLabel: 'M1',
    summary:
        'Executes voluntary movement by translating planned actions into body-specific motor commands.',
    primaryRole:
        'Sends organized output to the muscles once a movement plan is chosen.',
    failurePattern:
        'The person knows the target and the plan, but the outgoing command is weak, delayed, or misdirected.',
    networkRole:
        'Converts selected actions into physical body movement.',
    everydayExample:
        'Reaching to a specific point on a screen without overshooting.',
    quickFacts: <String>[
      'Contains body-mapped motor representation.',
      'Works downstream of planning systems.',
      'Damage often disrupts voluntary control more than intention.',
    ],
    discipline: BrainRegionDiscipline.movement,
    positionX: 0.39,
    positionY: 0.31,
    radiusFactor: 0.055,
    connections: <String>['somatosensory', 'basal_ganglia', 'cerebellum'],
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
    id: 'somatosensory',
    name: 'Somatosensory Cortex',
    shortLabel: 'S1',
    summary:
        'Registers touch, pressure, body position, and the location of sensation across the body map.',
    primaryRole:
        'Turns raw touch and proprioception into a stable sense of where the body is being contacted.',
    failurePattern:
        'The patient feels something happened, but cannot place or interpret the body signal accurately.',
    networkRole:
        'Feeds spatial and motor systems with body-state data.',
    everydayExample:
        'Knowing where your hand is resting without looking at it.',
    quickFacts: <String>[
      'Maps the body surface across cortex.',
      'Works closely with parietal integration areas.',
      'Important for closed-loop correction.',
    ],
    discipline: BrainRegionDiscipline.sensory,
    positionX: 0.49,
    positionY: 0.21,
    radiusFactor: 0.048,
    connections: <String>['parietal', 'thalamus'],
    challengePrompt:
        'A tap lands on the forearm, but the network cannot localize it. Which operation belongs here?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Translate touch and proprioception into a body map',
        feedback:
            'Correct. Somatosensory cortex stabilizes when incoming sensation is mapped to body position.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Convert the signal into fluent speech commands',
        feedback:
            'Speech production does not localize touch on the body surface.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Promote the cue to emotional urgency first',
        feedback:
            'Urgency can matter later, but sensation must be located accurately first.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Body-surface mapping restored. Tactile clues and proprioceptive guidance can now drive richer cases.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'basal_ganglia',
    name: 'Basal Ganglia',
    shortLabel: 'BG',
    summary:
        'Selects, gates, and scales actions so the intended movement or habit can begin while competing patterns stay suppressed.',
    primaryRole:
        'Helps initiate chosen actions and dampens unwanted movement patterns.',
    failurePattern:
        'Actions start too slowly, repeat unnecessarily, or become hard to switch away from once engaged.',
    networkRole:
        'Sits between cortical plans and action initiation circuits.',
    everydayExample:
        'Starting a smooth walking rhythm without freezing or repeating the wrong action.',
    quickFacts: <String>[
      'Deep structure rather than outer cortex.',
      'Important for action selection and habit loops.',
      'Commonly discussed in Parkinsonian motor symptoms.',
    ],
    discipline: BrainRegionDiscipline.movement,
    positionX: 0.34,
    positionY: 0.46,
    radiusFactor: 0.05,
    connections: <String>['thalamus', 'insula'],
    challengePrompt:
        'Several movement plans compete at once. Which basal ganglia operation best stabilizes the system?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Gate the chosen action and suppress competing ones',
        feedback:
            'Correct. Basal ganglia stability comes from selecting the intended action while damping rivals.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Store the action as episodic memory before moving',
        feedback:
            'Memory encoding does not solve immediate action selection.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Route all signals directly to visual cortex',
        feedback:
            'Visual parsing is not the main bottleneck in action gating.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Action gating restored. Cases can now distinguish between planning a movement and releasing it cleanly.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'parietal',
    name: 'Parietal Cortex',
    shortLabel: 'PPC',
    summary:
        'Combines touch, spatial awareness, and body positioning into a usable map of the environment.',
    primaryRole:
        'Fuses multiple signals into one coherent model of space and body position.',
    failurePattern:
        'The body can move, but the spatial estimate guiding it drifts or conflicts with touch.',
    networkRole:
        'Turns raw body and sensory data into navigation and targeting guidance.',
    everydayExample:
        'Reaching into a bag without looking and still locating the right object.',
    quickFacts: <String>[
      'Important for spatial attention.',
      'Works with somatosensory and visual systems.',
      'Guides aiming and navigation.',
    ],
    discipline: BrainRegionDiscipline.sensory,
    positionX: 0.6,
    positionY: 0.26,
    radiusFactor: 0.053,
    connections: <String>['visual', 'wernicke', 'hippocampus'],
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
    id: 'wernicke',
    name: "Wernicke's Area",
    shortLabel: 'Wern.',
    summary:
        'Maps heard or read language onto meaning so speech can be understood as structured content.',
    primaryRole:
        'Turns incoming language into semantic interpretation.',
    failurePattern:
        'Speech sounds fluent and complex, but meaning is lost or incoming language is poorly understood.',
    networkRole:
        'Anchors comprehension before language flows into memory or response planning.',
    everydayExample:
        'Understanding a spoken instruction quickly enough to respond appropriately.',
    quickFacts: <String>[
      'Often contrasted with Broca’s area.',
      'More tied to comprehension than articulation.',
      'Can affect meaningful language mapping.',
    ],
    discipline: BrainRegionDiscipline.language,
    positionX: 0.61,
    positionY: 0.49,
    radiusFactor: 0.05,
    connections: <String>['thalamus', 'visual'],
    challengePrompt:
        'A spoken instruction reaches the system, but the words are not resolving into meaning. Which operation belongs here?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Convert incoming language into semantic representation',
        feedback:
            "Correct. Wernicke's area stabilizes when sound patterns map cleanly to meaning.",
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Route the words directly into muscle commands',
        feedback:
            'Motor output should not bypass comprehension when the meaning is still unclear.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Promote every phrase into a threat signal',
        feedback:
            'Urgency does not restore the semantic meaning of language.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Language comprehension restored. Cases can now contrast understanding speech with producing it.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'thalamus',
    name: 'Thalamus',
    shortLabel: 'Thal.',
    summary:
        'Routes and filters large streams of sensory and cortical information so the right signals reach the right targets.',
    primaryRole:
        'Acts as a relay hub and attention gate for incoming and outgoing information.',
    failurePattern:
        'Signals arrive late, noisy, or in the wrong priority order, making many higher systems look unstable at once.',
    networkRole:
        'Connects deep relay traffic with cortex-wide processing.',
    everydayExample:
        'Separating a useful cue from background input quickly enough to act on it.',
    quickFacts: <String>[
      'Often described as a sensory relay center.',
      'Influences attention and signal prioritization.',
      'Can affect many systems at once because of its routing role.',
    ],
    discipline: BrainRegionDiscipline.relay,
    positionX: 0.57,
    positionY: 0.57,
    radiusFactor: 0.048,
    connections: <String>['visual', 'insula', 'cerebellum'],
    challengePrompt:
        'Multiple incoming streams compete for attention. Which thalamic operation best stabilizes the network?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Relay and prioritize the right signals to cortex',
        feedback:
            'Correct. Thalamic stability depends on routing the right information to the right targets at the right time.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Translate every signal into episodic memory first',
        feedback:
            'Memory storage is not the first priority when routing itself is noisy.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Bypass relay and commit all input directly to movement',
        feedback:
            'Movement systems need filtered information, not raw uncontrolled traffic.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Relay control restored. Broader multi-system cases can now hinge on routing quality instead of isolated cortical failure.',
    rewardInsight: 4,
  ),
  BrainRegion(
    id: 'insula',
    name: 'Insula',
    shortLabel: 'Insula',
    summary:
        'Tracks internal body state and helps integrate visceral sensation with feeling, awareness, and decision making.',
    primaryRole:
        'Links interoception to conscious feeling and salience.',
    failurePattern:
        'The person misreads their internal state or cannot integrate bodily cues into judgment and emotion cleanly.',
    networkRole:
        'Bridges body-state awareness with emotional and executive systems.',
    everydayExample:
        'Noticing your heartbeat and tension before deciding whether stress is rising.',
    quickFacts: <String>[
      'Strongly tied to interoception.',
      'Participates in salience networks.',
      'Often discussed in emotion, craving, and body awareness.',
    ],
    discipline: BrainRegionDiscipline.interoception,
    positionX: 0.46,
    positionY: 0.56,
    radiusFactor: 0.047,
    connections: <String>['amygdala', 'cerebellum'],
    challengePrompt:
        'The body sends strong internal cues, but they are not reaching awareness in a useful way. Which operation belongs here?',
    challengeOptions: <ChallengeOption>[
      ChallengeOption(
        label: 'Integrate internal body signals into conscious state',
        feedback:
            'Correct. The insula stabilizes when visceral cues become a coherent, usable sense of internal state.',
        isCorrect: true,
      ),
      ChallengeOption(
        label: 'Convert the cues directly into semantic grammar',
        feedback:
            'Language processing does not replace interoceptive awareness.',
        isCorrect: false,
      ),
      ChallengeOption(
        label: 'Strip the cues away until no salience remains',
        feedback:
            'The goal is useful awareness, not total suppression of body state.',
        isCorrect: false,
      ),
    ],
    codexEntry:
        'Interoceptive awareness restored. The game can now teach how body-state signals shape decision and emotion.',
    rewardInsight: 3,
  ),
  BrainRegion(
    id: 'hippocampus',
    name: 'Hippocampus',
    shortLabel: 'Hipp.',
    summary:
        'Encodes context, episodes, and navigational memory. It works well as the mid-run progression gate.',
    primaryRole:
        'Binds events to place, time, and sequence so they can be recalled later.',
    failurePattern:
        'The moment is recognized, but it falls apart when the person tries to keep it attached to route or context.',
    networkRole:
        'Indexes experience so it can be recovered with situational detail.',
    everydayExample:
        'Remembering where you left your keys and the last place you handled them.',
    quickFacts: <String>[
      'Important for episodic memory.',
      'Helps with route and place encoding.',
      'Distinct from motor habit learning.',
    ],
    discipline: BrainRegionDiscipline.memory,
    positionX: 0.5,
    positionY: 0.68,
    radiusFactor: 0.052,
    connections: <String>['amygdala', 'thalamus'],
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
    shortLabel: 'Amyg.',
    summary:
        'Evaluates salience and emotional urgency. It adds stakes to the exploration loop without replacing control.',
    primaryRole:
        'Marks stimuli as urgent, threatening, or emotionally charged for the wider network.',
    failurePattern:
        'Neutral or familiar cues get amplified into system-wide urgency or fear.',
    networkRole:
        'Adjusts network tone by weighting emotional relevance.',
    everydayExample:
        'Instantly noticing a possible threat before deciding whether it really matters.',
    quickFacts: <String>[
      'Strongly tied to salience and threat learning.',
      'Interacts with memory and interoception.',
      'Can bias attention and action rapidly.',
    ],
    discipline: BrainRegionDiscipline.emotion,
    positionX: 0.38,
    positionY: 0.74,
    radiusFactor: 0.047,
    connections: <String>['insula', 'cerebellum'],
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
    shortLabel: 'V1',
    summary:
        'Processes contrast, edges, motion, and shape into visual features that the rest of the game can exploit.',
    primaryRole:
        'Extracts usable visual structure from raw incoming signals.',
    failurePattern:
        'The scene arrives, but it stays noisy and hard to parse into actionable features.',
    networkRole:
        'Feeds route finding, recognition, and action guidance from visual data.',
    everydayExample:
        'Separating a moving object from a busy background at a glance.',
    quickFacts: <String>[
      'Early visual feature processing hub.',
      'Supports edge, contrast, and motion analysis.',
      'Feeds higher visual interpretation systems.',
    ],
    discipline: BrainRegionDiscipline.vision,
    positionX: 0.8,
    positionY: 0.43,
    radiusFactor: 0.055,
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
    shortLabel: 'Cereb',
    summary:
        'Fine-tunes timing, balance, and corrective feedback. It serves as the final stabilizer in the opening network.',
    primaryRole:
        'Corrects timing and force errors while movement is already in progress.',
    failurePattern:
        'Movements begin, but wobble, overshoot, and timing drift keep compounding instead of shrinking.',
    networkRole:
        'Closes the correction loop after main commands have launched.',
    everydayExample:
        'Adjusting your hand smoothly while catching a ball or balancing on a narrow edge.',
    quickFacts: <String>[
      'Important for motor refinement and timing.',
      'Works after the main action command has started.',
      'Supports precise error correction.',
    ],
    discipline: BrainRegionDiscipline.coordination,
    positionX: 0.76,
    positionY: 0.75,
    radiusFactor: 0.06,
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
