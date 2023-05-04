import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/pages/workout_started.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/model/workout.dart';
import 'package:fitness_app/model/exercise.dart';
import 'package:path_provider/path_provider.dart';

class FeaturedWorkoutSelectedPage extends StatefulWidget {

  final Workout workout;
  const FeaturedWorkoutSelectedPage({super.key, required this.workout});

  @override
  State<FeaturedWorkoutSelectedPage> createState() => _FeaturedWorkoutSelectedPageState();
}

class _FeaturedWorkoutSelectedPageState extends State<FeaturedWorkoutSelectedPage> {

  List<int> goalReps = [];

  void populateGoalReps(int index){
    for(int i = 0; i < index ; i++){
      goalReps.add(widget.workout.exercises[i].reps+1);
    }
  }

  //Formatting exercise data
  //Create function to adjust reps and sets and weight
  List<String> returnExerciseData(Exercise exercise, int index){
    List<String> formattedData = [];

    formattedData.add("Weight: ${exercise.weight}kg");
    formattedData.add("Sets: ${exercise.sets}");
    formattedData.add("Rep Range: ${exercise.repRange[0]} - ${exercise.repRange[1]}");
    formattedData.add("Reps: ${exercise.reps}");
    formattedData.add("Goal Reps: ${goalReps[index]}");

    return formattedData;
    
  }

  Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();

    return directory.path;
    }

  Future<File> get _myWorkoutsFile async {
    final path = await _localPath;
    return File('$path/myWorkouts.json');
  }

  Future<void> saveWorkoutInfo() async {

    var sb = StringBuffer();

    for (var element in widget.workout.exercises) {
      sb.write(element.toParse());
    }

    String exerciseListToString = sb.toString();

    var workoutMap={
      "name":widget.workout.name,
      "exercises":exerciseListToString,
      "timesDone":0,
      "day":widget.workout.day
    };

    final file = await _myWorkoutsFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);
    decodedContents.add(workoutMap);

    String encodedWorkoutsInfo = jsonEncode(decodedContents);
    final myWorkoutsFile = await _myWorkoutsFile;

    myWorkoutsFile.writeAsString(encodedWorkoutsInfo);
  
  }

  //Initiate goal rep values and increment weight if reps last performed == rep range max.
  @override
  void initState() {
    super.initState();
    populateGoalReps(widget.workout.exercises.length);
  } 

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        
        Center(
          child: Text(widget.workout.name,
          style: TextStyle(
            fontSize: 50,
              )
            )
          ),

        Center(
          child: Text("Exercises",
          style: TextStyle(fontSize: 40))
          ),  

        Padding(padding: EdgeInsets.symmetric(vertical:5)),

        Scrollbar(
          child:Card(
              elevation: 2,
              child: SizedBox(
                width: 380,
                height: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.workout.exercises.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                      ListTile(
                        title: Text(
                          widget.workout.exercises[index].name,
                          style: TextStyle(fontSize: 30)
                          ),
                        minVerticalPadding: 5,
                        tileColor: Colors.blue[100],
                          ),
                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: returnExerciseData(widget.workout.exercises[index], index).length,
                        itemBuilder: ((context, index2) {
                          return ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            title: Text(
                              returnExerciseData(widget.workout.exercises[index], index)[index2],
                              style: TextStyle(fontSize: 20),
                              ),
                          );
                        })
                        ) 
                        ]
                      );
                    },
                  )
                )
              ),
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 15)),

            Center(
              child: TextButton(
                child: Text("Add to Workouts",
                style: TextStyle(
                  fontSize: 30
                  )
                ),
                onPressed: () {
                  saveWorkoutInfo();
                  Navigator.of(context).popUntil(
                  ((route) => route.isFirst)
                );
                },                          
              )
            ),

      ],
    )
  );
  
}