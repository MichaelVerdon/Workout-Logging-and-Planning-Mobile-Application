import 'exercise.dart';

class Workout{

  String name;
  List<Exercise> exercises;
  int timesDone;
  String day;

  Workout(this.name, this.exercises, this.timesDone, this.day);

  //exercise stuff
  addExercise(Exercise exercise){
    exercises.add(exercise);
  }

  removeExercise(Exercise exercise){
    exercises.remove(exercise);
  }

  workoutDone(){
    timesDone++;
  }

}