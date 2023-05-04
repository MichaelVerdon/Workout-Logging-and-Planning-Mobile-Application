import 'package:collection/collection.dart';

class ExerciseCalorieCounter{

  List<int> reps;
  int sets;
  double bodyWeight;


  static const double METvalue = 6.0; // Mets formula
  static const double repTime = 5/3600; // 2 seconds per rep in hours
  static const double restTime = 1/30; // 2 mins rest time in hours

  ExerciseCalorieCounter(this.reps, this.sets, this.bodyWeight);

  int exerciseFinished(){

    double duration = getExerciseDuration();
    double burned = METvalue * bodyWeight * duration;

    return burned.round(); // For display when working out

  }

  getExerciseDuration() => (reps.sum * repTime) + (sets * restTime);

}