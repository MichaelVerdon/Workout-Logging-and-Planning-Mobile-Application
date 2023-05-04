import 'dart:math';
import '../model/exercise.dart';
import '../model/workout.dart';

class WorkoutGenerator{

  List<List<dynamic>> csvFile;
  String experience;
  String goal;
  int access;
  List<String> ownEquipment;
  List<String> days;
  int workoutTime;

  WorkoutGenerator(this.csvFile, this.experience, this.goal, this.access,
  this.ownEquipment, this.days, this.workoutTime);

  List<Workout> generateWorkouts(){

    //Get all parameters to generate workouts.
    List<List<dynamic>> filteredExercises = filterExercisesList(); //Exercises available to user
    int numberOfWorkouts = getWorkoutAmount(); //1-5
    List<List<int>> repRanges = getRepRanges(); //Rep Ranges to use in split
    int exercisesPerWorkout = getExercisesPerWorkout(); //Exercises for each workout
    List<String> workoutSplit = decideSplit(numberOfWorkouts); //Workout split to be used

    List<Workout> generatedWorkouts = [];

    for(var i = 0; i < workoutSplit.length; i++){
      generatedWorkouts.add(
        generateWorkout(
          filteredExercises, repRanges, exercisesPerWorkout, workoutSplit[i], i));
    }

    return generatedWorkouts;
  }

  Workout generateWorkout(List<List<dynamic>> exercises, List<List<int>> repRanges,
  int exercisesPerWorkout, String workoutType, int dayIndex){

    //Initial variables to put into workout.
    String workoutName = "Gen: $workoutType Day";
    String workoutDay = days[dayIndex].substring(0, 3);
    List<Exercise> exercisesList = [];

    //Filter exercises by musclegroups
    List<List<dynamic>> filteredExercises = filterByMuscleGroup(workoutType, exercises);

    List<List<dynamic>> exercisesToAdd = [];
    List<List<int>> repRangesToAdd = [];

      //Select workouts with more intense exercises first weaning down.
      //Try catch clauses in case the filtered list of potential exercises.
      //is not long enough.
      for(var i = 0; i < exercisesPerWorkout; i++){
        if(i == 0 || i == 1){
          try{
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 3));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[0]);
          }
          catch(e){
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 2));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[0]);
          }
        }
        else if(i == 2 || i == 3){
          try{
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 2));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[1]);
          }
          catch(e){
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 1));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[1]);
          }
        }
        else{
          try{
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 1));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[2]);
          }
          catch(e){
            exercisesToAdd.add(selectRandomExercise(filteredExercises, 2));
            filteredExercises.remove(exercisesToAdd[i]);
            repRangesToAdd.add(repRanges[2]);
          }
        }
      }

      //Make Exercise Classes for each exercise in workout and add rep range.
      for(var i = 0; i < exercisesToAdd.length; i++){
        if(exercisesToAdd[i].isEmpty){
          exercisesToAdd.removeAt(i);
        }
        else{
          exercisesList.add(Exercise(exercisesToAdd[i][0], 10.0,
         repRangesToAdd[i][0], 3, repRangesToAdd[i]));
        }
      }

    return Workout(workoutName, exercisesList, 0, workoutDay);

  }

  List<dynamic> selectRandomExercise(List<List<dynamic>> data, int intensity){
    List<List<dynamic>> tempList = [];

    for(var exercise in data){
      if(exercise[5] == intensity){
        tempList.add(exercise);
      }
    }
    if(tempList.isEmpty){
      return [];
    }
    int random = Random().nextInt(tempList.length);
    return tempList[random];
  }

  List<List<dynamic>> filterByIntensity(int intensity, List<List<dynamic>> data){

    List<List<dynamic>> newList = [];

    for(var exercise in data){
      if(exercise[5] == intensity){
        newList.add(exercise);
      }
    }

    return newList;

  }

  List<List<dynamic>> filterByMuscleGroup(String group, List<List<dynamic>> data){

    List<String> muscleGroups = [];
    List<List<dynamic>> newList = [];

    switch(group){

      case "Push":
      muscleGroups = ["Chest", "Triceps", "Shoulders"];
      break;

      case "Pull":
      muscleGroups = ["Back", "Biceps"];
      break;

      case "Core":
      muscleGroups = ["Abdominals"];
      break;

      case "Upper Body":
      muscleGroups = ["Chest", "Triceps", "Shoulders", "Back", "Biceps"];
      break;

      case "Lower Body":
      muscleGroups = ["Quadriceps", "Hamstrings", "Glutes", "Calves"];
      break;

      case "Arms":
      muscleGroups = ["Biceps", "Triceps", "Shoulders", "Forearms"];
      break;

      case "Full Body":
      return data;

      case "Legs":
      muscleGroups = ["Quadriceps", "Hamstrings", "Glutes", "Calves"];
      break;

      default:
      return data;
    }

    for(var exercise in data){
      List<String> tempGroups = exercise[1].split("/");
      if(tempGroups.toSet().any(muscleGroups.contains)){
        newList.add(exercise);
      }
    }

    return newList;

  }

  List<List<dynamic>> filterExercisesList() {
    List<List<dynamic>> exercises = csvFile;

    List<List<dynamic>> filteredExercises = filterByExperience(exercises);
    filteredExercises = filterByAccess(filteredExercises);

    return filteredExercises;
    
  }

  List<List<dynamic>> filterByExperience(List<List<dynamic>> data){

    List<List<dynamic>> filteredList = [];

    switch(experience){
      case "Beginner":
      for(var info in data){
        if(info.contains("Beginner")){
          filteredList.add(info);
        }
      }
      break;
      case "Intermediate":
      for(var info in data){
        if(info.contains("Beginner") || info.contains("Intermediate")){
          filteredList.add(info);
        }
      }
      break;
      case "Advanced":
      for(var info in data){
        if(info.contains("Intermediate") || info.contains("Advanced")){
          filteredList.add(info);
        }
      }
      break;
      default:
      break;
    }

    return filteredList;

  }

  //Filter workouts by access level or equipment owned.
  List<List<dynamic>> filterByAccess(List<List<dynamic>> data){

    List<List<dynamic>> filteredList = [];

    if(access == 1){
      for(var exercise in data){
        if(exercise[3] == 1){
          filteredList.add(exercise);
        }
      }
    }
    else if(access == 3){
      for(var exercise in data){
        if(exercise[3] == 2 || exercise[3] == 3){
          filteredList.add(exercise);
        }
      }
    }
    else{
      for(var exercise in data){
        List<String> tempEquipList = exercise[4].split("+"); //Index for equipment alts.

        if(Set.of(ownEquipment).containsAll(tempEquipList) || tempEquipList.contains("Home")){
          filteredList.add(exercise);
        }
      }
    }

    return filteredList;

  }

  List<List<int>> getRepRanges(){

    List<List<int>> repRanges = [];

    switch(goal){
      case "Muscle":
      repRanges = [[6, 10], [8, 12], [10, 14]];
      break;
      case "Strength":
      repRanges = [[3, 6], [6, 10], [8, 12]];
      break;
      case "Both":
      repRanges = [[3, 6], [8, 12], [10, 14]];
      break;
    }

    if(access == 1){
      repRanges = [[1, 99]];
    }

    return repRanges;

  }

  int getWorkoutAmount(){
    return days.length;
  }

  int getExercisesPerWorkout(){
    switch(workoutTime){
      case 30:
      return 4;
      case 60:
      return 5;
      case 90:
      return 6;
      case 120:
      return 7;
      default:
      return 5;
    }
  }
  
  List<String> decideSplit(int numberOfWorkouts) {
    
    switch(numberOfWorkouts){
      
      case 1:
      return ["Full Body"];

      case 2:
      List<List<String>> twoDaySplits = [["Upper Body", "Legs"],
       ["Full Body", "Full Body"]];
      int random = Random().nextInt(2);
      return twoDaySplits[random];

      case 3:
      List<List<String>> threeDaySplits = [["Push", "Pull", "Legs"],
       ["Upper Body", "Core", "Legs"]];
      int random = Random().nextInt(2);
      return threeDaySplits[random];

      case 4:
      List<List<String>> fourDaySplits = [["Push", "Pull", "Legs", "Core"],
       ["Push", "Pull", "Legs", "Arms"]];
      int random = Random().nextInt(2);
      return fourDaySplits[random];

      case 5:
      List<List<String>> fiveDaySplits = [["Push", "Pull", "Legs", "Push", "Pull"],
       ["Push", "Pull", "Legs", "Core", "Arms"]];
      int random = Random().nextInt(2);
      return fiveDaySplits[random];

      default:
      return ["Push", "Pull", "Legs"];
    }
  }
}