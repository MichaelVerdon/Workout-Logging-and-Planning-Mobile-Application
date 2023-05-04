import 'workout.dart';
import 'exercise.dart';

List<int> range = [8,12];
List<Exercise> exerciseList = [
  Exercise("Bench Press", 70, 12, 4, range),
  Exercise("Military Press", 40, 9, 3, range),
  Exercise("Incline Bench", 50, 3, 5, range),
];

List<Workout> workoutList = [
  Workout("Chest Day", exerciseList, 2, "Mon"),
  Workout("Chest Day1", exerciseList, 3, "Wed"),
  Workout("Chest Day2", exerciseList, 4, "Fri"),
  Workout("Chest Day3", exerciseList, 5, "Sat"),
];
