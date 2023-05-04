import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/exercise.dart';
import '../model/workout.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlertPage createState() => _AlertPage();

}

class _AlertPage extends State<AlertPage> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AlertDialog(
    title: Text("Caution"),
    content: Text("Are you sure you want to delete this workout?"),
    actions: [
      TextButton(
        child: Text("Yes"),
        onPressed:  () {
          Navigator.pop(context, true);
        },
      ),

      TextButton(
        child: Text("No"),
        onPressed:  () {
          Navigator.pop(context, false);
        },
      )
    ],
    )
  );

}

class EditWorkoutPage extends StatefulWidget {
  final Workout workout;
  const EditWorkoutPage({super.key, required this.workout});

  @override
  State<EditWorkoutPage> createState() => _EditWorkoutPage();

}

List<String> returnExerciseData(Exercise exercise, int index){
    List<String> formattedData = [];

    formattedData.add("Weight: ${exercise.weight}kg");
    formattedData.add("Sets: ${exercise.sets}");

    return formattedData;
    
  }

showAlertDialog(BuildContext context) {

  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed:  () {
      Navigator.of(context).pop(true);
    },
  );

  Widget noButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.of(context).pop(false);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Caution"),
    content: Text("Are you sure you want to delete this workout?"),
    actions: [
      yesButton,
      noButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}

class _EditWorkoutPage extends State<EditWorkoutPage>{

  Future<void> awaitAlertResponse() async{
    final delete = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AlertPage()));

    if(delete){
      deleteWorkout();
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }


  Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();

    return directory.path;
    }

  Future<File> get _myWorkoutsFile async {
    final path = await _localPath;
    return File('$path/myWorkouts.json');
  }

  Future<void> deleteWorkout() async {
    
    final file = await _myWorkoutsFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);

    for(var i = 0; i < decodedContents.length; i++){
      if(decodedContents[i]["name"] == widget.workout.name){
        String tempString = "";
        for(var element in widget.workout.exercises){
          tempString += element.toParse();
        }
        if(tempString == decodedContents[i]["exercises"]){
          decodedContents.removeAt(i);
          break;
        }
      }
    }

    String encodedWorkoutsInfo = jsonEncode(decodedContents);
    final myWorkoutsFile = await _myWorkoutsFile;

    file.writeAsString(encodedWorkoutsInfo);

  }

  Future<void> saveWorkoutInfo() async {

    for(var i = 0; i < widget.workout.exercises.length; i++){

      setState(() {
        widget.workout.exercises[i].weight = workoutDetails[i][0];
        widget.workout.exercises[i].sets = workoutDetails[i][1];
      });

    }

    var sb = StringBuffer();

    for (var element in widget.workout.exercises) {
      sb.write(element.toParse());
    }

    String exerciseListToString = sb.toString();


    var workoutMap={
      "name": _workoutNameController.text,
      "exercises": exerciseListToString,
      "timesDone": widget.workout.timesDone,
      "day": _dropdownValue
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

  List<List<dynamic>> workoutDetails = [];
  List<String> workoutDetailStrings = ["Weight:", "Sets:"];

  final TextEditingController _workoutNameController = TextEditingController();

  String? _dropdownValue;

  void populateWorkoutDetails(){

    setState(() {
      for(var exercise in widget.workout.exercises){

        List<dynamic> tempList = [];

        tempList.add(exercise.weight);
        tempList.add(exercise.sets);

        workoutDetails.add(tempList);

      }
    });
  }


  @override
  void initState(){

    super.initState();
    populateWorkoutDetails();
    _workoutNameController.text = widget.workout.name;
    _dropdownValue = widget.workout.day;

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
      final snackBar = SnackBar(content: Text('Workout name cannot be left blank'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    body: SingleChildScrollView( 
      child:Column(
        children: [
          
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Center(
            child: Text("EDIT WORKOUT",
            style: TextStyle(
              fontSize: 40,
                )
              )
            ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 15)),

              Center(
                child: SizedBox(
                width: 200,
                height: 50,
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
              height: 50,   
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

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Scrollbar(
          child: Card(
              elevation: 2,
              child: SizedBox(
                width: 380,
                height: 350,
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
                        itemCount: 2,
                        itemBuilder: ((context, index2) {
                          return ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            title: Text(
                              "${workoutDetailStrings[index2]} ${workoutDetails[index][index2]}",
                              style: TextStyle(fontSize: 20),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                height: 50,
                                child: Row(
                                  children: [

                                    IconButton(
                                      icon: Icon(Icons.remove, color: Colors.black,),
                                      onPressed: () {
                                        setState(() {

                                          if(workoutDetailStrings[index2] == "Weight:"){
                                            if(workoutDetails[index][0] == 0){
                                              final snackBar = SnackBar(content: Text('Weight cannot go below 0'),
                                              duration: Duration(seconds: 2));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                            else{
                                              workoutDetails[index][index2] -= 0.5;
                                            }
                                          }
                                          else{
                                            if(workoutDetails[index][1] == 0){
                                              final snackBar = SnackBar(content: Text('Sets cannot go below 0'),
                                              duration: Duration(seconds: 2));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                            else{
                                              workoutDetails[index][index2] -= 1;
                                            }
                                          }
                                          
                                        });
                                        
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(Icons.add, color: Colors.black,),
                                      onPressed: () {
                                        setState(() {

                                          if(workoutDetailStrings[index2] == "Weight:"){
                                            workoutDetails[index][index2] += 0.5;
                                          }
                                          else{
                                            workoutDetails[index][index2] += 1;
                                          }

                                        });
                                      },
                                    ),

                                  ],
                                )
                              )
                          );
                        })
                        ),
                        ]
                      );
                    },
                  )
                )
              ),
            ),

              Padding(padding: EdgeInsets.symmetric(vertical: 10)),

              Center(
                child: TextButton(
                  child: Text("Save",
                  style: TextStyle(
                    fontSize: 30
                    )
                  ),
                  onPressed: () {
                    if(verifyInputs()){
                      saveWorkoutInfo();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },                          
                )
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 10)),

              Center(
                  child: TextButton(
                    child: Text("Delete",
                    style: TextStyle(
                      fontSize: 30
                      )
                    ),
                    onPressed: () {
                      awaitAlertResponse();      
                    },                          
                  )
                ), 
        ],
      )
    )
  );
  
}