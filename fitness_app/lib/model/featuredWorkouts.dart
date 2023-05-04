import 'workout.dart';
import 'exercise.dart';

List<int> hypertrophyRange = [8,12];
List<int> balancedRange = [8,12];
List<int> explosiveRange = [3,6];

List<Exercise> pushDayList = [
  Exercise("Dips", 10, 5, 3, explosiveRange),
  Exercise("DB Incline Bench", 40, 8, 3, balancedRange),
  Exercise("DB Shoulder Press", 20, 3, 3, balancedRange),
  Exercise("DB Skullcrushers", 10, 8, 3, balancedRange),
  Exercise("Backpack Pushups", 5, 10, 3, hypertrophyRange),
];

List<Exercise> pullDayList = [
  Exercise("Pullups", 5, 4, 3, explosiveRange),
  Exercise("Seated Rows", 45, 8, 3, balancedRange),
  Exercise("Chinups", 0, 8, 3, balancedRange),
  Exercise("DB Rows", 16, 8, 3, hypertrophyRange),
  Exercise("Rear Delt Rows", 10, 8, 3, hypertrophyRange),
];

List<Exercise> legDayList = [
  Exercise("Bulgarian Split Squats", 8, 8, 3, balancedRange),
  Exercise("DB Romanian Deadlifts", 20, 8, 3, balancedRange),
  Exercise("One Leg Hip Thrusts", 20, 8, 3, hypertrophyRange),
  Exercise("DB Calf Raises", 20, 8, 3, [10,14]),
  Exercise("Lunges", 8, 8, 3, balancedRange),
];

List<Exercise> armDayList = [
  Exercise("Close Grip Chin Ups", 0, 8, 3, balancedRange),
  Exercise("Hammer Curls", 12, 8, 3, balancedRange),
  Exercise("Lateral Raises", 10, 8, 3, balancedRange),
  Exercise("Preacher Curls", 12, 8, 3, balancedRange),
];

List <Exercise> beginnerAtHomeList = [
  Exercise("Pushups", 0, 10, 3, [1,20]),
  Exercise("Squats", 0, 10, 3, [1,20]),
  Exercise("Supermans", 0, 10, 3, [1,20]),
  Exercise("Situps", 0, 10, 3, [1,20]),
];

List<Exercise> beginnersAtGym = [
  Exercise("Dumbbell Bench Press", 10, 6, 3, [6,12]),
  Exercise("Dumbbell Squats", 10, 6, 3, [6,12]),
  Exercise("Dumbbell Rows", 10, 6, 3, [6,12]),
  Exercise("Lateral Raises", 4, 6, 2, [6,12]),
  Exercise("Situps", 0, 10, 2, [1,20]),
];

List<Workout> featuredList = [
  Workout("Devs Push Day", pushDayList, 0, "Mon"),
  Workout("Devs Pull Day", pullDayList, 0, "Wed"),
  Workout("Devs Leg Day", armDayList, 0, "Sat"),
  Workout("Devs Arm Day", legDayList, 0, "Fri"),
];

List<Workout> forBeginners = [
  Workout("Full Body Home", beginnerAtHomeList, 0, "Mon"),
  Workout("Full Body Gym", beginnersAtGym, 0, "Mon"),
];

List<String> featuredListAsset = [
  "assets/images/devs_push_day.png",
  "assets/images/devs_pull_day.png",
  "assets/images/devs_leg_day.png",
  "assets/images/devs_arm_day.png",
];

List<String> featuredBeginnersAsset = [
  "assets/images/full_body_at_home.png",
  "assets/images/full_body_at_gym.png",
];