import 'package:flutter/material.dart';

import '../model/exercise.dart';

Widget assessPerformance(List<int> repsDone, int goalReps){

  int totalReps = repsDone.reduce((value, element) => value + element,);
  int totalGoalReps = goalReps * repsDone.length;

  if(totalReps >= totalGoalReps){
    return Icon(Icons.arrow_circle_up_outlined, color: Colors.green, size: 30);
  }
  else if(totalReps == totalGoalReps-(repsDone.length)){
    return Icon(Icons.arrow_circle_right_outlined, color: Colors.black, size: 30);
  }
  else{
    return Icon(Icons.arrow_circle_down_outlined, color: Colors.red, size: 30);
  }

  
}

List<Exercise> updateReps(List<Exercise> exercises, List<List<int>> repsDone){

  //List<int> totalRepsList = repsDone.reduce((value, element) => value + element,);

  for(var i = 0; i < exercises.length; i++){
    exercises[i].reps = (repsDone[i].reduce((value, element) => value + element,)/exercises[i].sets).round();
    exercises[i].checkWeightIncrement();
  }

  return exercises;

}
