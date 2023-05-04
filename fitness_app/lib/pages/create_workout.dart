import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fitness_app/model/exercise.dart';
import 'package:path_provider/path_provider.dart';

import 'find_exercise.dart';


class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();

}

class _CreateWorkoutPageState extends State<CreateWorkoutPage>{


  final List<Exercise> newWorkout = [];

  String? _dropdownValue;

  final TextEditingController _workoutNameController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  void dropDownCallback(String? selectedValue){ //For dropdown menu
    if (selectedValue is String){
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  bool verifyInputs(){
    if(_workoutNameController.text.isEmpty){
      final snackBar = SnackBar(content: Text('You must give the workout a name'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    if(newWorkout.isEmpty){
      final snackBar = SnackBar(content: Text('You must add at least one exercise'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    if(_dropdownValue == null){
      final snackBar = SnackBar(content: Text('You must set a day for the workout'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }


  void addExerciseToList(Exercise exercise){
    setState(() {
      newWorkout.add(exercise);
    });
  }

  String returnString(List<String> list, int index) => list[index];

  Future<void> _findExercise(BuildContext context) async {
    final Exercise selectedExercise = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FindExercisePage())
    );
    setState(() {
      newWorkout.add(selectedExercise);
    });
    
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

    for (var element in newWorkout) {
      sb.write(element.toParse());
    }

    String exerciseListToString = sb.toString();

    var workoutMap={
      "name":_workoutNameController.text,
      "exercises":exerciseListToString,
      "timesDone":0,
      "day":_dropdownValue
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

  @override
  Widget build(BuildContext context) => Scaffold(

    body: SingleChildScrollView(
      child: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10),),

        Center(
          child: Text("CREATE WORKOUT",
              style: TextStyle(
                fontSize: 40,
                )
              )
            ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Row(
          children: [

            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

            Center(
              child: SizedBox(
              width: 200,
              height: 75,
              child: TextField(
                controller: _workoutNameController,
                maxLength: 20,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Workout name",
                  hintStyle: TextStyle(fontSize: 20),
                  counterText: "",
                ),
              )
            )
          ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

          SizedBox(
            width: 120,
            height: 75,   
            child: DropdownButtonFormField(
              alignment: Alignment.center,
              decoration: InputDecoration(
              hintText: "Day",
            ),
            
              items: const [
                DropdownMenuItem(value: "Mon", child: Text("Monday")),
                DropdownMenuItem(value: "Tue", child: Text("Tuesday")),
                DropdownMenuItem(value: "Wed", child: Text("Wednesday")),
                DropdownMenuItem(value: "Thu", child: Text("Thursday")),
                DropdownMenuItem(value: "Fri", child: Text("Friday")),
                DropdownMenuItem(value: "Sat", child: Text("Saturday")),
                DropdownMenuItem(value: "Sun", child: Text("Sunday")),
              
              ],
              onChanged: dropDownCallback,
              value: _dropdownValue                                          
              )    
            ),
          ],
        ),

        Center(
          child: SizedBox(
            width: 300,
            height: 50,
            child: TextButton(
              child: Text("Add Exercise",
              style: TextStyle(fontSize:25)),
              onPressed: () {
                _findExercise(context);
              },
            ),
          ),
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
       
        Scrollbar(child: Card(
            shape: RoundedRectangleBorder(           
            ),
            
            elevation: 2,
            child: SizedBox(
              width: 400,
              height: 350,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: newWorkout.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                    ListTile(
                      title: Text(
                        newWorkout[index].name,
                        style: TextStyle(fontSize: 25)
                        ),
                      minVerticalPadding: 5,
                      subtitle: Text(
                        "Rep Range: ${newWorkout[index].repRange[0]}-${newWorkout[index].repRange[1]}     Sets: ${newWorkout[index].sets}",
                        style: TextStyle(
                          fontSize: 17
                        )
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.black
                          ),
                        onPressed: () {
                          setState(() {
                            newWorkout.removeAt(index);
                          });
                        },
                      ),
                    )
                  ]
                );
              },
            )
          )
        ),
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: SizedBox(
            width: 300,
            height: 50,
            child: TextButton(
              child: Text("Save & Exit",
              style: TextStyle(fontSize:25)),
              onPressed: () {
                if(verifyInputs()){
                  saveWorkoutInfo();
                  Navigator.of(context).popUntil(
                    ((route) => route.isFirst)
                  );
                } 
              },
            ),
          ),
        )

        ],
      )
    )
  );
}