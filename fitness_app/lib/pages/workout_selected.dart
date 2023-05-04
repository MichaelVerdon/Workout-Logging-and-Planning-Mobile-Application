import 'package:fitness_app/pages/workout_started.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/model/workout.dart';
import 'package:fitness_app/model/exercise.dart';

class WorkoutSelectedPage extends StatefulWidget {

  final Workout workout;
  const WorkoutSelectedPage({super.key, required this.workout});

  @override
  State<WorkoutSelectedPage> createState() => _WorkoutSelectedPageState();
}

class _WorkoutSelectedPageState extends State<WorkoutSelectedPage> {

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
            fontSize: 40,
              )
            )
          ),

        Center(
          child: Text("Exercises",
          style: TextStyle(fontSize: 30))
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
                child: Text("Start",
                style: TextStyle(
                  fontSize: 30
                  )
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkoutStartedPage(workout: widget.workout, goalReps: goalReps,)));
                },                          
              )
            ),
      ],
    )
  );
}