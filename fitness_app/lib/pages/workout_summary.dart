import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/helpers/assessPerformance.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/workout.dart';

class WorkoutSummaryPage extends StatefulWidget {
  final Workout workout;
  final List<int> goalReps;
  final List<List<int>> repCounts;
  final int caloriesBurned;
  const WorkoutSummaryPage({super.key, required this.workout,
   required this.goalReps, required this.repCounts, required this.caloriesBurned});

  @override
  State<WorkoutSummaryPage> createState() => _WorkoutSummaryPage();

}

class _WorkoutSummaryPage extends State<WorkoutSummaryPage>{

  Future<void> resetFile() async{
    final file = await _caloriesFile;
    final contents = await file.readAsString();
    file.writeAsString("[]");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _workoutHistoryFile async {
    final path = await _localPath;
    return File('$path/workoutHistory.json');
  }

  Future<void> updateWorkoutHistory() async {

    final file = await _workoutHistoryFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _workoutHistoryFile;
      file.writeAsString("[]");

    }

    final contents = await file.readAsString();

    if(contents.isEmpty){
      file.writeAsString("[]");
    }

    List<dynamic> decodedContents = await jsonDecode(contents);

    //format date
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);

    var map = {
      "date":formattedDate,
      "workout":widget.workout.name
    };

    bool dateInSave = false;

    if(decodedContents.isEmpty){
      decodedContents.insert(0, map);
    }
    else{
      for(var element in decodedContents){
        if(element["date"] == formattedDate){
          dateInSave = true;
        }
        if(!dateInSave){
          decodedContents.insert(0, map);
        }
      }
    }

    for(var i = 0; i < decodedContents.length; i++){
      if(decodedContents[i]["date"] == formattedDate){
        decodedContents[i] = map;
      }
    }

    print(decodedContents);

    String encodedCalorieInfo = jsonEncode(decodedContents);
    final workoutHistoryFile = await _workoutHistoryFile;

    workoutHistoryFile.writeAsString(encodedCalorieInfo);

  }

  Future<File> get _caloriesFile async {
    final path = await _localPath;
    return File('$path/caloriesBurned.json');
  }

  Future<void> updateCalorieInfo() async {

    try{
      final file = await _caloriesFile;
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _caloriesFile;
      file.writeAsString("[]");
    }

    final file = await _caloriesFile;

    final contents = await file.readAsString();

    if(contents.isEmpty){
      file.writeAsString("[]");
    }

    List<dynamic> decodedContents = await jsonDecode(contents);

    //format date
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);

    var map = {
      "date":formattedDate,
      "calories":0
    };

    bool dateInSave = false;

    if(decodedContents.isEmpty){
      decodedContents.add(map);
    }
    else{
      for(var element in decodedContents){
        if(element["date"] == formattedDate){
          dateInSave = true;
        }
        if(!dateInSave){
          decodedContents.add(map);
        }
      }
    }

    num totalCalories = widget.caloriesBurned;

    for(var element in decodedContents){
      if(element["date"] == formattedDate){
        totalCalories += element["calories"];
      }
    }

    for(var i = 0; i < decodedContents.length; i++){
      if(decodedContents[i]["date"] == formattedDate){
        decodedContents[i]["calories"] = totalCalories;
      }
    }

    String encodedCalorieInfo = jsonEncode(decodedContents);
    final caloriesFile = await _caloriesFile;

    caloriesFile.writeAsString(encodedCalorieInfo);

    print("final: $encodedCalorieInfo");
    
  }

  Future<File> get _myWorkoutsFile async {
    final path = await _localPath;
    return File('$path/myWorkouts.json');
  }

  Future<void> updateWorkoutInfo() async {

    widget.workout.exercises = updateReps(widget.workout.exercises, widget.repCounts);

    var sb = StringBuffer();

    for (var element in widget.workout.exercises) {
      sb.write(element.toParse());
    }

    String exerciseListToString = sb.toString();

    setState(() {
      widget.workout.workoutDone();
    });

    var workoutMap={
      "name":widget.workout.name,
      "exercises":exerciseListToString,
      "timesDone":widget.workout.timesDone,
      "day":widget.workout.day
    };

    final file = await _myWorkoutsFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);

    for(var i = 0; i < decodedContents.length; i++){
      if(decodedContents[i]["name"] == widget.workout.name){
        decodedContents[i] = workoutMap;
      }
    }

    String encodedWorkoutsInfo = jsonEncode(decodedContents);
    final myWorkoutsFile = await _myWorkoutsFile;

    myWorkoutsFile.writeAsString(encodedWorkoutsInfo);
    
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text("Summary",
          style: TextStyle(fontSize: 40)
          )
        ),

        Scrollbar(
          child: Card(
            child: SizedBox(
              width: 400,
              height: 450,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.workout.exercises.length,
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      ListTile(
                        title: Text("${widget.workout.exercises[index].name} - ${widget.workout.exercises[index].weight}kg",
                          style: TextStyle(fontSize: 30)),
                        tileColor: Colors.blue[100],),

                      ListTile(
                        title: Text("Goal reps per set: ${widget.goalReps[index]}",
                        style: TextStyle(fontSize: 20))
                      ),

                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.repCounts[index].length,
                        itemBuilder: ((context, index2) {
                          return ListTile(
                            title: Text("Set ${index2+1}: ${widget.repCounts[index][index2].toString()}",
                            style: TextStyle(fontSize: 20)),
                            
                          );
                        })),

                      ListTile(
                        title: Text("Performance:",
                        style: TextStyle(fontSize: 20)),
                        trailing: assessPerformance(widget.repCounts[index], widget.goalReps[index])
                      ),
                    ],
                  ); 
                }
              )
            )
          )
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
            child: Text(
              "Calories Burned: ${widget.caloriesBurned}",
              style: TextStyle(
                fontSize: 30,
              )
            ),
          ),

      Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        TextButton(
          child: Text("Exit",
          style: TextStyle(fontSize: 30),),
          onPressed: () {
            //resetFile();
            updateWorkoutInfo();
            updateCalorieInfo();
            updateWorkoutHistory();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    ),
  );
}