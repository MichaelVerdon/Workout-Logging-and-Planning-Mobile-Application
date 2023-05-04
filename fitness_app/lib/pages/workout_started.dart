import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/helpers/exerciseCalorieCounter.dart';
import 'package:fitness_app/pages/workout_summary.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../model/workout.dart';

class WorkoutStartedPage extends StatefulWidget {
  final Workout workout;
  final List<int> goalReps;
  const WorkoutStartedPage({super.key, required this.workout, required this.goalReps});

  @override
  State<WorkoutStartedPage> createState() => _WorkoutStartedPage();

}

class _WorkoutStartedPage extends State<WorkoutStartedPage>{

  @override
  void initState() {
    super.initState();
    initTextFieldControllers(widget.workout.exercises[0].sets);
    readWeightFile();
  } 

  int caloriesBurned = 0;

  int exerciseCounter = 0;

  TextEditingController bodyWeight = TextEditingController();

  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();

  List<TextEditingController> repFieldControllers = [];
  List<List<int>> repCounts = [];

  void initTextFieldControllers(int sets){
    repFieldControllers = List.generate(sets, (index) => TextEditingController());
  }
  
  void clearControllers(){
    for(int i = 0; i < repFieldControllers.length; i++){
      // ignore: list_remove_unrelated_type
      repFieldControllers.remove(i);
    }
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
  }

  Future<File> get _localWeightFile async {
  final path = await _localPath;
  return File('$path/weightInfo.json');
  }

  Future<void> readWeightFile() async {
  try {
    final file = await _localWeightFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);

    setState(() {
      bodyWeight.text = decodedContents[decodedContents.length-1]["weight"];
      
    });
    
    } catch (e) {
    // If encountering an error, return 0
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Center(
            child: Text(
              widget.workout.exercises[exerciseCounter].name,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),

          Center(
            child: Text(
              "Weight: ${widget.workout.exercises[exerciseCounter].weight}kg",
              style: TextStyle(
                fontSize: 30,
              )
            ),
          ),

          Center(
            child: Text(
              "Calories Burned: $caloriesBurned",
              style: TextStyle(
                fontSize: 30,
              )
            ),
          ),

          Scrollbar(
            controller: controllerOne,
            thumbVisibility: true,
            child:Card(
              shape: RoundedRectangleBorder(           
              ),
              
              elevation: 2,
              child:SizedBox(
                width: 400,
                height: 300,
                child: ListView.builder(
                  itemCount: widget.workout.exercises[exerciseCounter].sets,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(
                        "Set ${index+1}:",
                        style: TextStyle(
                        fontSize: 30,
                      ),
                    ),

                  subtitle: Text(
                    "Goal reps: ${widget.goalReps[exerciseCounter]}",
                    style: TextStyle(
                      fontSize: 20
                    ),
                    ),

                  trailing: SizedBox(
                    width: 100,
                    height: 30,
                    child: TextField(
                      controller: repFieldControllers[index],
                      enabled: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(
                        fontSize: 30
                      ),
                      decoration: InputDecoration(
                          hintText: "Reps done",
                          hintStyle: TextStyle(
                            fontSize: 15
                          )
                        
                        ),
                      ),  
                    )
                  
              );}))
            ),
          ),
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 5)),

          Center(
            child: Text("Too heavy or too light?", style: TextStyle(fontSize: 20))
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          
          Center(
            child: Scrollbar(
              controller: controllerTwo,
              thumbVisibility: true,
                child: Container(
                  height: 60,
                  width: 400,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    
                    children: [

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("-10kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight -= 10;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("-2.5kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight -= 2.5;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("-0.5kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight -= 0.5;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("+0.5kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight += 0.5;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("+2.5kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight += 2.5;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      TextButton(
                        child: Text("+10kg", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            widget.workout.exercises[exerciseCounter].weight += 10;
                          });
                        },
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      
                    ],
                  )
                )
              )
            ),
          

          Padding(padding: EdgeInsets.symmetric(vertical: 20)),

          Center(
            child: TextButton(
              child: Text("Next",
              style: TextStyle(
                fontSize: 30,
              )
              ),
              onPressed: () {

                print("1");

                try{
                  setState(() {
                  repCounts.add(List.generate(repFieldControllers.length, (int index) => int.parse(repFieldControllers[index].text)));
                  });
                }
                catch(e){
                  final snackBar = SnackBar(content: Text('Make sure all fields are entered and in numbers'),
                  duration: Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                

                ExerciseCalorieCounter counter = ExerciseCalorieCounter(repCounts[exerciseCounter],
                 widget.workout.exercises[exerciseCounter].sets, double.parse(bodyWeight.text));

                int toAdd = counter.exerciseFinished();

                setState(() {
                  caloriesBurned += toAdd;
                });

                if(exerciseCounter == widget.workout.exercises.length - 1){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => WorkoutSummaryPage(workout: widget.workout, goalReps: widget.goalReps,
                   repCounts: repCounts, caloriesBurned: caloriesBurned,)));
                }
                else{

                  setState(() {
                    clearControllers();
                    exerciseCounter++;
                    initTextFieldControllers(widget.workout.exercises[exerciseCounter].sets);
                  });

                }
              },
            ),
          ),        
        ],
      )
    )
  ); 
}