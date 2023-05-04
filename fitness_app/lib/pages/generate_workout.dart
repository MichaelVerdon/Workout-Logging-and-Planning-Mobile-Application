import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fitness_app/model/testWorkoutList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../helpers/workoutGenerator.dart';
import '../model/workout.dart';

class GenerateWorkoutPage extends StatefulWidget {
  const GenerateWorkoutPage({super.key});

  @override
  State<GenerateWorkoutPage> createState() => _GenerateWorkoutPage();

}

class _GenerateWorkoutPage extends State<GenerateWorkoutPage>{

  bool questionZero = true;
  bool questionOne = false;
  bool questionTwo = false;
  bool questionTwoExtended = false;
  bool questionThree = false;

  // ignore: prefer_final_fields
  List<bool> _selectColor = [true, true, true, true, true, true, true];

  final List<String> _checked = [];

  List<String> equipmentList = ["Weight Plates", "Dumbbells", "Barbell", "Pullup Bar", "Dip Station",
  "Pulley", "Rings", "Bench"];

  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  List<int> workoutTime = [30, 60, 90, 120];

  late String experience;
  late String goal;
  late int accessLevel;
  late List<String> ownedEquipment;
  List<String> daysAvailable = [];
  int workoutTimeSelected = 30;

  void _onSelected(bool selected, String name){
    if (selected == true){
      setState(() {
        _checked.add(name);
      });
    } else{
      setState(() {
        _checked.remove(name);
      });
    }
  }

  void updateDaysList(bool notSelected, int index) {
    if(!notSelected){
      setState(() {
        daysAvailable.add(days[index]);
      });
    }
    else{
      setState(() {
        daysAvailable.remove(days[index]);
      });
    }

  }

  void generateWorkout() async {

    final _getExercises = await rootBundle.loadString("databases/exercises.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_getExercises);

    WorkoutGenerator generator = WorkoutGenerator(_listData, experience, goal, accessLevel
    , ownedEquipment, daysAvailable, workoutTimeSelected);

    List<Workout> generatedWorkouts = generator.generateWorkouts();
    saveWorkoutInfo(generatedWorkouts);

  }

  bool verifyEquipmentChecklist(){
    if(_checked.isEmpty){
      final snackBar = SnackBar(content: Text('Select at least one equipment'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  bool verifyDaysSelected(){
    if(daysAvailable.isEmpty){
      final snackBar = SnackBar(content: Text('Select at least one day'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
  }

  Future<File> get _myWorkoutsFile async {
  final path = await _localPath;
  return File('$path/myWorkouts.json');
  }

  Future<void> saveWorkoutInfo(List<Workout> generatedWorkouts) async {

    List<dynamic> workoutMaps = [];

    for(var workout in generatedWorkouts){

      var sb = StringBuffer();

      for (var exercises in workout.exercises) {
        sb.write(exercises.toParse());
      }

      String exerciseListToString = sb.toString();

      var tempMap= {
      "name": workout.name,
      "exercises": exerciseListToString,
      "timesDone": workout.timesDone,
      "day": workout.day
      };

      workoutMaps.add(tempMap);

    }


    final file = await _myWorkoutsFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);

    for(var map in workoutMaps){
      decodedContents.add(map);
    }
    
    String encodedWorkoutsInfo = jsonEncode(decodedContents);
    final myWorkoutsFile = await _myWorkoutsFile;

    myWorkoutsFile.writeAsString(encodedWorkoutsInfo);
  
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Visibility(
          visible: questionZero,
          child: Column(
            children: [
              //Question Zero
                Padding(padding: EdgeInsets.symmetric(vertical: 10),),

                Text(
                    "Your Experience",
                    style: TextStyle(
                      fontSize: 50,
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        child: Text("Beginner", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            experience = "Beginner";
                            questionZero = false; questionOne = true;
                          });
                        },
                      )
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      child: Text("Intermediate", style: TextStyle(fontSize: 25)),
                      onPressed: () {
                        setState(() {
                          experience = "Intermediate";
                          questionZero = false; questionOne = true;
                          });
                        },
                      )
                    )                   
                  ),

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        child: Text("Advanced", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            experience = "Advanced";
                            questionZero = false; questionOne = true;
                          });
                        },
                      )
                    )
                  ),
            ],
          )
        ),

        Visibility(
          visible: questionOne,
          child: Center(
            child: Column(
              children: [
                //Question 1
                Padding(padding: EdgeInsets.symmetric(vertical: 10),),

                Text(
                    "Your Goal",
                    style: TextStyle(
                      fontSize: 50,
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        child: Text("Build Muscle", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            goal = "Muscle";
                            questionOne = false; questionTwo = true;
                          });
                        },
                      )
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      child: Text("Build Strength", style: TextStyle(fontSize: 25)),
                      onPressed: () {
                        setState(() {
                          goal = "Strength";
                          questionOne = false; questionTwo = true;
                          });
                        },
                      )
                    )                   
                  ),

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        child: Text("Both", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            goal = "Both";
                            questionOne = false; questionTwo = true;
                          });
                        },
                      )
                    )
                  ), 
              ],
            )
          )
        ),

        Visibility(
          visible: questionTwo,
          child: Center(
            child: Column(
              children: [
                //Question 2
                Padding(padding: EdgeInsets.symmetric(vertical: 10),),

                Text(
                    "Your Access",
                    style: TextStyle(
                      fontSize: 50,
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 270,
                      height: 50,
                      child: TextButton(
                        child: Text("Gym", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            ownedEquipment = equipmentList;
                            accessLevel = 3;
                            questionTwo = false; questionThree = true;
                          });
                        },
                      )
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 270,
                      height: 50,
                      child: TextButton(
                        child: Text("Home/Equipment", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            accessLevel = 2;
                            questionTwo = false; questionTwoExtended = true;
                          });
                        },
                      )
                    )
                  ),

                Padding(padding: EdgeInsets.symmetric(vertical: 50),),

                Center(
                  child: SizedBox(
                      width: 270,
                      height: 50,
                      child: TextButton(
                        child: Text("Home/No Equipment", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          setState(() {
                            ownedEquipment = [];
                            accessLevel = 1;
                            questionTwo = false; questionThree = true;
                          });
                        },
                      )
                    )
                  ),                
              ],
            )
          )
        ),

        Visibility(
          visible: questionTwoExtended,
          child: Center(
            child: Column(
              children: [
                //Question 2.2
                Padding(padding: EdgeInsets.symmetric(vertical: 10),),

                Text(
                    "My Equipment",
                    style: TextStyle(
                      fontSize: 50,
                    )
                  ),
                

                Padding(padding: EdgeInsets.symmetric(vertical: 5),),

                SizedBox(
                  width: 400,
                  height: 500,
                  child: ListView.builder(
                    itemCount: equipmentList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index){
                      return CheckboxListTile(
                        title: Text(equipmentList[index],
                        style: TextStyle(
                          fontSize: 25
                        )),
                        value: _checked.contains(equipmentList[index]), 
                        onChanged: ((value) {
                          setState(() {
                            _onSelected(value!, equipmentList[index]);
                          });
                        })
                        );
                    }
                    )
                  ),

                Padding(padding: EdgeInsets.symmetric(vertical: 5),),

                Center(
                  child: SizedBox(
                      width: 260,
                      height: 50,
                      child: TextButton(
                        child: Text("Continue", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          if(verifyEquipmentChecklist()){
                            setState(() {
                            ownedEquipment = _checked;
                            questionTwoExtended = false; questionThree = true;
                            });
                          }                          
                        },
                      )
                    )
                  ),                      
                ],
              )
            )
          ),

        Visibility(
          visible: questionThree,
          child: Center(
            child: Column(
              children: [
                //Question 3
                Padding(padding: EdgeInsets.symmetric(vertical: 10),),

                Text(
                    "Availablility",
                    style: TextStyle(
                      fontSize: 50,
                    )
                  ),               

                Text(
                  "Select your workout days",
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),

                Padding(padding: EdgeInsets.symmetric(vertical: 20),),

                Scrollbar(
                  thumbVisibility: true,
                  child: SizedBox(
                    height: 100,
                    width: 500,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: ((context, index) {
                        return SizedBox(
                          width: 120,
                          height: 100,
                          child: Card(
                            color: _selectColor[index] ? Colors.white : Colors.blue[200],
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectColor[index] = !_selectColor[index];
                                  updateDaysList(_selectColor[index], index);
                                });
                              },
                              child: Center(
                                child: Text(days[index])
                              )
                            )
                          ),
                        );
                      })
                    )
                )),

                Padding(padding: EdgeInsets.symmetric(vertical: 20),),

                Text(
                    "Time per workout (minutes)",
                    style: TextStyle(
                      fontSize: 20,
                    )
                  ),   

                SizedBox(
                  width: 150,
                  height: 200,
                  child: 
                    ListWheelScrollView.useDelegate(
                        itemExtent: 52,
                        perspective: 0.01,
                        physics: FixedExtentScrollPhysics(),
                        useMagnifier: true,
                        magnification: 1.5,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            workoutTimeSelected = workoutTime[value];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: workoutTime.length,
                          builder: ((context, index) {
                            return Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(),
                              child: Text(
                                (workoutTime[index]).toString(),
                                style: TextStyle(
                                  fontSize: 35,                                 
                              ),
                              )
                          );
                        })
                      )
                    ),
                  
                ),
                
                Padding(padding: EdgeInsets.symmetric(vertical: 30),),

                Center(
                  child: SizedBox(
                      width: 260,
                      height: 50,
                      child: TextButton(
                        child: Text("Finish", style: TextStyle(fontSize: 25)),
                        onPressed: () {
                          if(verifyDaysSelected()){
                            generateWorkout();
                            FocusScope.of(context).unfocus();                                                        
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                      },
                    )
                  )
                ),                     
              ],
            )
          )
        ),
      ],
    )
  );
}