import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/pages/edit_workout_page.dart';
import 'package:fitness_app/pages/workout_selected.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/model/workout.dart';

import 'package:path_provider/path_provider.dart';
import '../model/exercise.dart';
import 'create_workout.dart';

class MyWorkoutsPage extends StatefulWidget {
  const MyWorkoutsPage({super.key});

  @override
  State<MyWorkoutsPage> createState() => _MyWorkoutsPage();

}

class _MyWorkoutsPage extends State<MyWorkoutsPage>{

  List<Workout> myWorkouts = [];

  @override
  void initState(){
    super.initState();
    readMyWorkoutsFile();
    //resetFile();
  }

  //File handling for workouts
  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
  }

  Future<File> get _myWorkoutsFile async {
  final path = await _localPath;
  return File('$path/myWorkouts.json');
  }

  ///////////////////////For Debugging//////////////////////////
  Future<void> resetFile() async{
    final file = await _myWorkoutsFile;
    file.writeAsString("[]");
  }
  ///////////////////////For Debugging//////////////////////////
  
  List<Exercise> stringToExerciseList(String string){

    List<Exercise> decodedList = [];

    List<String> stringList = string.split("&");
    List<List<String>> seperatedExercises = [];
    for(var string in stringList){
      seperatedExercises.add(string.split("/"));
    }
    seperatedExercises.removeAt(0);

    for(var exercise in seperatedExercises){
      
      String name = exercise[0];
      double weight = double.parse(exercise[1]);
      int reps = int.parse(exercise[2]);
      int sets = int.parse(exercise[3]);
      List<int> repRange = exercise[4].replaceAll('[', '').replaceAll(']', '')
      .split(',').map<int>((e) {
      return int.parse(e);
      }).toList();

      Exercise tempExercise = Exercise(name, weight, reps, sets, repRange);
      decodedList.add(tempExercise);     
    }
    return decodedList;
  }

  Future<void> readMyWorkoutsFile() async {
  try {
    final file = await _myWorkoutsFile;

    // Read the file
    final contents = await file.readAsString();
    dynamic decodedContents = await jsonDecode(contents);

    List<Workout> tempList = [];

    for(var item in decodedContents){
      Workout tempWorkout = Workout(
        item["name"], stringToExerciseList(item["exercises"]),
        item["timesDone"], item["day"]
      );
      tempList.add(tempWorkout);
    }

    setState(() {
      myWorkouts = tempList;
    });

    } catch (e) {
      final file = await _myWorkoutsFile;
      file.writeAsString("[]");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    body: SingleChildScrollView( child: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text("MY WORKOUTS",
          style: TextStyle(
            fontSize: 40,
              )
            )
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Card(
            shape: RoundedRectangleBorder(),
            
            elevation: 2,
            child: SizedBox(
              width: 400,
              height: 500,
                child: ListView.builder(
                  itemCount: myWorkouts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      child: ListTile(
                        leading: SizedBox(
                          width: 85,
                          height: 70,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 187, 222, 251),
                            ),
                            child: Center(
                              child: Text(
                                myWorkouts[index].day,
                                style: TextStyle(
                                  fontSize: 30
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(myWorkouts[index].name,
                        style: TextStyle(
                          fontSize: 30
                        ),
                        ),
                        subtitle: Text("Times done: ${myWorkouts[index].timesDone}",
                        style: TextStyle(
                          fontSize: 20
                        )
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.settings,
                          color: Colors.black
                          ),
                          iconSize: 35,
                          onPressed: () {
                            Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditWorkoutPage(workout: myWorkouts[index])));
                          }
                          
                        ),
                        minVerticalPadding: 5,
                        onTap: () {
                          Workout workoutSelected = myWorkouts[index];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WorkoutSelectedPage(workout: workoutSelected)));
                        },
                      ) 
                    );
                  },
                )
              )
            ),
    

            Padding(padding: EdgeInsets.symmetric(vertical: 5)),

            IconButton(
              icon: Icon(Icons.add_circle_outline),
              iconSize: 50,
              onPressed: () {
                Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateWorkoutPage()));    
              },
            ),
      ],
    ),
  ));
}