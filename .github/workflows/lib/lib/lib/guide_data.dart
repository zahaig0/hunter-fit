// ------------------------- CALISTHENICS GUIDE -------------------------
class Ex {
  final String name;
  final String prescription;
  final String tip;
  final int minRank;
  const Ex(this.name, this.prescription, this.tip, this.minRank);
}

const Map<String, List<Ex>> kGuide = {
  'Chest': [
    Ex('Knee Push-ups', '3 x 10', 'Keep body in a straight line, elbows ~45 deg.', 0),
    Ex('Push-ups', '4 x 15', 'Chest touches the floor, full lockout.', 1),
    Ex('Diamond Push-ups', '4 x 12', 'Hands form a diamond, hits triceps and inner chest.', 2),
    Ex('Archer Push-ups', '4 x 8 / side', 'Shift weight to one arm, other arm stays straight.', 3),
    Ex('Decline Push-ups', '4 x 15', 'Feet elevated for upper chest.', 3),
    Ex('Clap Push-ups', '4 x 10', 'Explosive push, land softly.', 4),
    Ex('Pseudo Planche Push-ups', '4 x 8', 'Lean forward, hands by the hips.', 5),
    Ex('One-Arm Push-ups', '5 x 5 / side', 'Wide feet, brace core.', 6),
    Ex('Planche Push-ups', '5 x 5', 'Elite strength. Master the tuck planche first.', 7),
  ],
  'Back': [
    Ex('Superman Hold', '3 x 30s', 'Lift arms and legs, squeeze glutes.', 0),
    Ex('Inverted Rows', '4 x 12', 'Use a low bar or table, pull chest to bar.', 0),
    Ex('Pull-ups', '4 x 8', 'Full hang to chin over bar.', 1),
    Ex('Chin-ups', '4 x 10', 'Underhand grip, also hits biceps.', 2),
    Ex('Wide Pull-ups', '4 x 10', 'Wider grip for lats.', 3),
    Ex('L-sit Pull-ups', '4 x 8', 'Legs straight forward while pulling.', 4),
    Ex('Archer Pull-ups', '4 x 6 / side', 'Pull toward one hand.', 5),
    Ex('Muscle-ups', '5 x 5', 'Explosive pull, transition, press out.', 6),
    Ex('One-Arm Pull-up', '5 x 3 / side', 'Slow negatives first.', 7),
  ],
  'Shoulders': [
    Ex('Pike Push-ups', '3 x 10', 'Hips high, head moves between hands.', 0),
    Ex('Wall Walks', '3 x 5', 'Walk feet up the wall into handstand.', 1),
    Ex('Wall Handstand Hold', '4 x 30s', 'Stack wrists, shoulders, hips.', 2),
    Ex('Elevated Pike Push-ups', '4 x 12', 'Feet on a chair.', 3),
    Ex('Handstand Push-ups (wall)', '4 x 8', 'Head touches the floor lightly.', 4),
    Ex('Freestanding Handstand', '5 x 30s', 'Fingers control balance.', 5),
    Ex('Freestanding HSPU', '5 x 5', 'Elite control.', 7),
  ],
  'Arms': [
    Ex('Bench Dips', '3 x 12', 'Keep back close to the bench.', 0),
    Ex('Close-grip Push-ups', '4 x 15', 'Elbows tucked.', 1),
    Ex('Parallel Bar Dips', '4 x 12', 'Lean slightly forward.', 2),
    Ex('Bar Curl Rows', '4 x 10', 'Underhand inverted row for biceps.', 3),
    Ex('Korean Dips', '4 x 8', 'Bar behind your back, advanced shoulder prep.', 5),
    Ex('Ring Dips', '5 x 8', 'Unstable = more muscle.', 6),
  ],
  'Abs': [
    Ex('Crunches', '3 x 20', 'Slow and controlled.', 0),
    Ex('Plank', '3 x 45s', 'Squeeze glutes and abs.', 0),
    Ex('Leg Raises', '4 x 15', 'Lower back stays on the floor.', 1),
    Ex('Russian Twists', '4 x 30', 'Rotate through the torso.', 1),
    Ex('Hanging Knee Raises', '4 x 12', 'No swinging.', 2),
    Ex('Hanging Leg Raises', '4 x 12', 'Legs straight, toes to bar.', 3),
    Ex('Dragon Flag Negatives', '4 x 6', 'Lower slowly with a straight body.', 4),
    Ex('L-sit', '5 x 20s', 'Hold legs parallel to the floor.', 5),
    Ex('Dragon Flag', '5 x 6', 'Full control from shoulders down.', 6),
    Ex('Front Lever', '5 x 10s', 'Body horizontal under the bar.', 7),
  ],
  'Legs': [
    Ex('Bodyweight Squats', '4 x 20', 'Hips below knees.', 0),
    Ex('Lunges', '4 x 12 / leg', 'Keep your front knee over your ankle.', 0),
    Ex('Bulgarian Split Squats', '4 x 10 / leg', 'Rear foot on a chair.', 2),
    Ex('Jump Squats', '4 x 15', 'Soft landing.', 2),
    Ex('Calf Raises', '4 x 25', 'Pause at the top.', 1),
    Ex('Shrimp Squats', '4 x 6 / leg', 'Hold rear foot, slow descent.', 4),
    Ex('Pistol Squats', '5 x 6 / leg', 'Heel down, chest up.', 5),
    Ex('Nordic Curls', '4 x 6', 'Hamstring killer.', 6),
    Ex('Dragon Squats', '4 x 5 / leg', 'Mobility plus strength.', 7),
  ],
  'Full Body': [
    Ex('Jumping Jacks', '3 x 40', 'Warm-up classic.', 0),
    Ex('Burpees', '4 x 12', 'Chest to floor, jump at the top.', 1),
    Ex('Mountain Climbers', '4 x 40', 'Fast knees, flat back.', 1),
    Ex('Bear Crawl', '4 x 20m', 'Knees hover off the floor.', 2),
    Ex('Burpee Pull-ups', '4 x 10', 'Burpee then jump into a pull-up.', 4),
    Ex('Human Flag Practice', '5 x 10s', 'Side body strength.', 6),
    Ex('Planche Hold', '5 x 10s', 'Legend tier.', 7),
  ],
};

// banner image for each category
const Map<String, int> kCatPic = {
  'Chest': 7,
  'Back': 9,
  'Shoulders': 8,
  'Arms': 1,
  'Abs': 4,
  'Legs': 17,
  'Full Body': 10,
};
