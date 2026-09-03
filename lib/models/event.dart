class EventRound {
  final String title;
  final String details;
  final String? time;
  final String? questions;

  const EventRound({
    required this.title,
    required this.details,
    this.time,
    this.questions,
  });
}

class Event {
  final String slug;
  final String name;
  final String category;
  final String icon;
  final String description;
  final List<String> rules;
  final int? maxTeamSize;
  final String? deadline;
  final String? coordinator;
  final List<EventRound> rounds;

  const Event({
    required this.slug,
    required this.name,
    required this.category,
    required this.icon,
    required this.description,
    required this.rules,
    this.maxTeamSize,
    this.deadline,
    this.coordinator,
    this.rounds = const [],
  });
}

const events = <Event>[
  Event(
    slug: 'ppt-presentation',
    name: 'PPT Presentation',
    category: 'Technical',
    icon: '📊',
    description: 'Present your innovative idea, research or project with confidence.',
    rules: [
      '1. Topic: Select a paper related to the given theme or technical field.',
      '2. Originality: Present original work and avoid copied content.',
      '3. Time Limit: Complete the presentation within the allotted 5 minutes.',
      '4. PPT Format: Use clear headings, diagrams, images, and key points.',
      '5. Slides: Keep the presentation concise, preferably within 10 slides.',
      '6. Team Size: Follow the specified team size of 1–4 members.',
      '7. Submission: Submit the paper/PPT before the given deadline.',
      '8. Language & Q&A: Present in English and answer judges’ questions confidently.',
      '9. References & Plagiarism: Include references and ensure the paper is plagiarism-free.',
      '10. Discipline & Decision: Maintain professional conduct; judges’ decision is final, and rule violations may lead to disqualification.',
      '11. Coordinator number - M.Mano - 9566976009 / R.Deepika - 9384206295',
    ],
    maxTeamSize: 4,


    rounds: [
      EventRound(title: 'Presentation', details: 'Present the selected technical topic with clear headings, diagrams, images and important points.', time: '5 minutes'),
      EventRound(title: 'Q&A', details: 'Participants answer questions asked by judges after the presentation.'),
    ],
  ),
  Event(
    slug: 'poster-presentation',
    name: 'Poster Presentation',
    category: 'Technical',
    icon: '🧬',
    description: 'Showcase your research through an attractive scientific poster.',
    rules: [
      '1. Maximum 3 members.',
      '2. Participants must use poster size from A3 to A1 for Hardcopy.',
      '3. Complete the presentation within time limit of 5 minutes.',
      '4. Coordinator number - R.Rahul - 7448665022 / Amutha - 9514070472.',
    ],
    maxTeamSize: 3,
    deadline: '15.08.2026',
    coordinator: 'R.Rahul - 7448665022 / Amutha - 9514070472.',
    rounds: [
      EventRound(title: 'Poster Presentation', details: 'Present the poster with title, introduction, objectives, methodology, results, applications and conclusion.', time: '5 minutes'),
    ],
  ),
  Event(
    slug: 'spot-to-solve',
    name: 'Spot to Solve',
    category: 'Technical',
    icon: '🧠',
    description: 'Think fast, solve smart and demonstrate technical problem-solving.',
    rules: [
      'Team Event - 3 to 4 members per team.',
      'Round 1 : Knowledge Knockout.',
      'Round 2 : Mystery Medical Box.',
      'Round 3 : Think About Case Study.',
      'Should not communicate with other team.',
      'Mobile phone necessary for first round.',
      'Coordinator number - 9363082703 / 75300 20522.',
    ],
    maxTeamSize: 4,
    rounds: [
      EventRound(title: 'Round 1 – Knowledge Knockout', details: 'Diseases & Medical Equipment – Missing Words. Participants identify missing words.', questions: '20', time: '1 minute per question'),
      EventRound(title: 'Round 2 – Mystery Medical Box', details: 'Medical Equipment Clue Challenge. Participants identify equipment from clues.', questions: '5', time: '45 sec'),
      EventRound(title: 'Round 3 – Think About the Case Study', details: 'Disease-based case studies requiring identification of disease, appropriate equipment, diagnosis and treatment.', questions: '5', time: '2 minutes'),
    ],
  ),
  Event(
    slug: 'medicomind',
    name: 'Medicomind',
    category: 'Technical',
    icon: '💡',
    description: 'Challenge your medical knowledge, logic and awareness.',
    rules: [
      'Round 1 – Memory Blast.',
      'Round 2 – Clue Connect.',
      'Round 3 – Ultimate Mind Lock.',
      '1. Time Limit: Each round must be completed within the given time.',
      '2. No Cheating: Mobile phones, internet, or outside assistance are not allowed.',
      '3. Follow the Challenge: Participants must follow the instructions given by event coordinators for each round.',
      '4. Points: Correct answers and successful completion earn points. The team with the highest overall score will be declared the winner.',
      'Winner Announcement: Auditorium.',
      'Team Size: 3–4 Members per Team.',
      'Contact: 6379840842 / 9176394047.',
    ],
    maxTeamSize: 4,
    rounds: [
      EventRound(title: 'Round 1 – Memory Blast', details: 'Observe 15–20 medical/general objects or pictures for 30 seconds, then identify as many as possible.', time: '10–15 minutes'),
      EventRound(title: 'Round 2 – Clue Connect', details: 'Connect medical and general clues to identify the correct answer.', time: '15–20 minutes'),
      EventRound(title: 'Round 3 – Ultimate Mind Lock', details: 'Solve jumbled words, logic puzzles, number clues and medical clues in sequence to reveal the final code.', time: '25–30 minutes'),
    ],
  ),
  Event(
    slug: 'cinephoria-short-film',
    name: 'Cinephoria & Short Film',
    category: 'Non-Technical',
    icon: '🎬',
    description: 'Bring storytelling, creativity and cinematic vision to the screen.',
    rules: [
      'Each Team Has 4 Members (Max).',
      'Strictly Smartphone Not Allowed.',
      'Winners Will Move To Next Round.',
      'Contact: 9344032349.',
    ],
    maxTeamSize: 4,
    rounds: [
      EventRound(title: 'Round 1 – Guess the Movie by 4 Clues', details: 'Identify the movie from four clues.', time: 'Easy'),
      EventRound(title: 'Round 2 – Guess the Actor, Actress, Director & Song', details: 'Identify the actor, actress, director or song associated with the movie/clues.', time: 'Moderate'),
      EventRound(title: 'Round 3 – Guess the Movie by Frame', details: 'Identify a movie from a frame of a popular scene.', time: 'Moderate'),
      EventRound(title: 'Round 4 – Find the Song by Acting', details: 'One participant acts out a song without speaking while teammates identify it.', time: 'Hard'),
      EventRound(title: 'Optional – Cine Auction', details: 'Teams receive ₹1,000 virtual/event points and bid strategically on movie-related categories.'),
      EventRound(title: 'Optional – Guess the Movie by Emoji', details: 'Identify a movie from a sequence of emojis.'),
    ],
  ),
  Event(
    slug: 'minutes-to-win',
    name: 'Minutes to Win',
    category: 'Non-Technical',
    icon: '⏱️',
    description: 'Fast challenges, quick decisions and maximum fun.',
    rules: [
      'Round 1 – Fake or Fact.',
      'Round 2 – Think Tank.',
      'Round 3 – Sketch & Guess.',
      '1. Time Limit: Each challenge must be completed within the given time.',
      '2. No Cheating: No discussion, mobile phones, or outside help is allowed.',
      '3. Follow the Challenge: Participants must follow the rules and instructions given for each round.',
      '4. Points: Correct completion earns points.',
      'Contact: 8072583996 / 8667564780.',
    ],
    maxTeamSize: 4,
    rounds: [
      EventRound(title: 'Round 1 – Fake or Fact', details: 'Identify whether each historical, general knowledge or funny statement is Fact or Fake.'),
      EventRound(title: 'Round 2 – Think Tank', details: 'Two teams bid how many answers they can give in a category; the highest valid bidder must answer that many correctly within 30 seconds.', time: '30 seconds'),
      EventRound(title: 'Round 3 – Sketch & Guess', details: 'One member draws a secret word without speaking while a teammate guesses it.', time: '1 minute'),
    ],
  ),
  Event(
    slug: 'team-building-activity',
    name: 'Team Building Activity',
    category: 'Non-Technical',
    icon: '🤝',
    description: 'Collaborate, communicate and complete exciting team challenges.',
    rules: [
      '3 Members per Team | 4 Games | Timed Rounds.',
      '1. Catch the Ball – One hand only; ball drops = game over. 40 sec.',
      '2. Cup Pyramid Challenge – No hands; use mouth only. 2–3 min.',
      '3. Ball & Pen Challenge – Handle the ball using only a pen. 1 min 30 sec.',
      '4. Balloon Cup Pyramid – Build the pyramid while keeping the balloon in the air. 1 min 30 sec.',
      '5. Winner: Overall performance & timing will decide the winner.',
      'Note: No elimination; may be introduced only if participation is very high.',
      'Contact - 9025792732 / 6379762101.',
    ],
    maxTeamSize: 3,
    rounds: [
      EventRound(title: 'Game 1 – Catch the Ball', details: 'Use only one hand. If the ball falls, the game ends immediately.', time: '40 seconds'),
      EventRound(title: 'Game 2 – Make a Cup Pyramid Using a Balloon', details: 'Construct a cup pyramid with a balloon. Hands must not be used; use the mouth/blowing technique.', time: '2–3 minutes'),
      EventRound(title: 'Game 3 – Handle the Ball with a Pen', details: 'Control/handle the ball using only a pen.', time: '1 minute 30 seconds'),
      EventRound(title: 'Game 4 – Form a Cup Pyramid While Keeping the Balloon in the Air', details: 'Build a cup pyramid while continuously keeping the balloon in the air.', time: '1 minute 30 seconds'),
    ],
  ),
  Event(
    slug: 'squad-wars',
    name: 'Squad-Wars',
    category: 'Non-Technical',
    icon: '⚔️',
    description: 'Compete as a squad through exciting collaborative challenges.',
    rules: [
      '1. Team Event – 4 members per team, full map.',
      '2. No hacks. NO EMOTE.',
    ],
    maxTeamSize: 4,
    rounds: [
      EventRound(title: 'Team Event', details: '4 members per team, full map.'),
    ],
  ),
  Event(
    slug: 'workshop',
    name: 'Workshop',
    category: 'Workshop',
    icon: '🛠️',
    description: 'Learn practical concepts through an interactive hands-on session.',
    rules: [
      'Title : Advanced respiratory care equipment hands-on training and technology.',
      '1. Hands-on Equipment Training – Practical training on modern respiratory care devices and their operation.',
      '2. Mechanical Ventilation – Learn the basics of ventilators, ventilation modes, and patient monitoring.',
      '3. Respiratory Monitoring – Understand pulse oximetry, capnography, and other respiratory monitoring technologies.',
      '4. Clinical Application & Safety – Practice proper equipment handling, troubleshooting, infection control, and patient safety.',
    ],
    maxTeamSize: 1,
    rounds: [
      EventRound(title: 'Program Details', details: 'Advanced respiratory care equipment hands-on training and technology.'),
    ],
  ),
];
