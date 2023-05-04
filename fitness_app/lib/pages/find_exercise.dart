import 'package:csv/csv.dart';
import 'package:fitness_app/model/testWorkoutList.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/model/muscle_groups.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/exercise.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FiltersPage createState() => _FiltersPage();

}

class _FiltersPage extends State<FiltersPage>{

  final List<String> _checked = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text("Select Muscle Groups",
        style: TextStyle(
          fontSize: 25,
        )),
        content: Column(                              
          children: [
            
            SizedBox(
              width: 250,
              height: 450,
              child: Card(
                elevation: 2,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: muscleGroups.length,
                    itemBuilder: (context, index){
                      return CheckboxListTile(
                        title: Text(muscleGroups[index],
                        style: TextStyle(
                          fontSize: 15
                        )),
                        value: _checked.contains(muscleGroups[index]), 
                        onChanged: ((value) {
                          setState(() {
                            _onSelected(value!, muscleGroups[index]);
                          });
                        })
                      );
                    }
                  )   
                )
              )
            ),
          
            TextButton(
              child: Text("Submit",
              style: TextStyle(
                fontSize: 20
              )
              ),
              onPressed: () {
                Navigator.pop(context, _checked);
              },
            ),
          ],
        ))
    );
  }

}

class FindExercisePage extends StatefulWidget {
  const FindExercisePage({super.key});

  @override
  State<FindExercisePage> createState() => _FindExercisePage();

}

class _FindExercisePage extends State<FindExercisePage>{

  List<String> activeFilters = [];
  Iterable<List<dynamic>> exercises = [];
  String selectedExercise = '';

  // ignore: prefer_final_fields
  List<bool> _selectColor = [];

  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  RangeValues rangeValues = const RangeValues(3,20);

  bool validateInputs(){
    // ignore: unnecessary_null_comparison
    if(selectedExercise.isEmpty){
      final snackBar = SnackBar(content: Text('Make sure an exercise is selected'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else if(!RegExp(r'^[0-9]+$').hasMatch(_setsController.text)){
      final snackBar = SnackBar(content: Text('Input a valid number of sets'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else if(!RegExp(r'^(\d*\.)?\d+$').hasMatch(_weightController.text)){
      final snackBar = SnackBar(content: Text('Input a valid weight in kilograms'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }


  @override
  void initState(){
    super.initState();
  
    getExerciseData();
  }

  void getExerciseData() async{

    final _getExercises = await rootBundle.loadString("databases/exercises.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_getExercises);

    if(activeFilters.isNotEmpty){

      List<List<dynamic>> newExercisesList = [];

      for(var data in _listData){
        for(var filter in activeFilters){
          if(data[1].contains(filter)){
            newExercisesList.add(data);
            break;
          }
        }
      }

      for(var i in _listData){
        _selectColor.add(true);
      }

      setState(() {
        exercises = newExercisesList;
      });
    }

    else{

      for(var i in _listData){
        _selectColor.add(true);
      }
      setState(() {
        exercises = _listData;
      });
    }
  }

  void nullifySelections(int index){
    setState(() {
      for(var i = 0; i < _selectColor.length; i++){
        _selectColor[i] = true;
      }
    });
  }

  Future<void> _findExercise(BuildContext context) async {
    List<String> selectedFilters = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FiltersPage())
    );
    setState(() {
      activeFilters = selectedFilters;
      getExerciseData();
    });
    
  }

  void searchExercise(String search){
    setState(() {
      exercises = exercises.where((element) => element[0]!.toString().toLowerCase().contains(search.toLowerCase()));
    });
  }

  Exercise createExercise(){
      
      List<int> repRanges = [];
      repRanges.add(rangeValues.start.round());
      repRanges.add(rangeValues.end.round());
      Exercise exercise = Exercise(
        selectedExercise, double.parse(_weightController.text),
         repRanges[0], int.parse(_setsController.text), repRanges
      );

      return exercise;
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(child:Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text(
            "Search Exercise",
            style: TextStyle(
              fontSize: 40
            )
          ),
        ),

        SizedBox(
            width: 400,
            height: 550,
            child: Card(
              child: Column(
                children: [

                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                  Row(
                    children: [

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      SizedBox(
                        width: 250,
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          textAlignVertical: TextAlignVertical.bottom,
                          style: TextStyle(
                            fontSize: 20
                          ),
                          onChanged: (value) {
                            setState(() {
                              if(value != ""){
                              searchExercise(value);
                              }
                            else {
                              getExerciseData();
                            }
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search by name",
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                          ),
                        )
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),

                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextButton(
                          child: Text("Filter",
                          style: TextStyle(
                            fontSize: 20
                          )),
                          onPressed: () {
                            _findExercise(context);
                          }                                                                         
                        ),
                      )
                    ],
                  ),

                  Padding(padding: EdgeInsets.symmetric(vertical: 0)),

                  SizedBox(
                    width: 400,
                    height: 300, 
                    child: Scrollbar(
                      thumbVisibility: true,                                    
                        child: ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: ((context, index) {
                          return Card(
                            color: _selectColor[index] ? Colors.grey[100] : Colors.blue[200],
                            child: ListTile(
                            title: Text(exercises.elementAt(index)[0],
                            style: TextStyle(fontSize: 20)
                            ),
                            trailing: Text(exercises.elementAt(index)[1],
                            style: TextStyle(fontSize: 12)
                            ),
                            onTap: () {
                              nullifySelections(index);
                              setState(() {
                                _selectColor[index] = !_selectColor[index];
                                selectedExercise = exercises.elementAt(index)[0];
                              });
                            },
                          )
                        );                         
                      }
                    )
                  )                    
                )
              ),

              Center(
                child: 

                  Column(
                    children: [
                      Text("Rep-Range",
                      style: TextStyle(
                        fontSize: 25
                        )
                      ),

                      SizedBox(
                        width: 400,
                        height: 30,
                        child:
                          RangeSlider(
                            max: 20,
                            min: 3,
                            values: rangeValues,
                            divisions: 17,
                            labels: RangeLabels(
                              rangeValues.start.round().toString(),
                              rangeValues.end.round().toString(),

                            ),
                            onChanged: (value) {
                              setState(() {
                                rangeValues = value;
                              });
                            },
                      )
                    ),                                           
                  ],
                ),
              ),

              Row(
                children: [

                  Padding(padding: EdgeInsets.symmetric(horizontal: 20)),

                  Column(
                    children: [
                      Text("Sets",
                      style: TextStyle(
                        fontSize: 25
                        )
                        ),

                      SizedBox(
                        width: 70,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          controller: _setsController,
                          keyboardType: TextInputType.datetime,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          decoration: InputDecoration(
                            hintText: "Sets",
                            counterText: "",
                            
                          ),

                        ),
                      )
                    ],
                  ),

                  Padding(padding: EdgeInsets.symmetric(horizontal: 50)),

                  Column(
                    children: [
                      Text("Weight(kg)",
                      style: TextStyle(
                        fontSize: 25
                        )
                        ),

                      SizedBox(
                        width: 85,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          controller: _weightController,
                          keyboardType: TextInputType.datetime,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          decoration: InputDecoration(
                            hintText: "kg",
                            counterText: "",
                            
                          ),

                        ),
                      )
                    ],
                  ),

                ]
              ),                                     
            ],                         
          ),    
        )
      ),

          Center(
          child: IconButton(
            icon: Icon(Icons.add_circle_outline),
            iconSize: 50,
            onPressed: () {
              if(validateInputs()){

              }
              createExercise();
              Navigator.of(context).pop(createExercise());
            },
          ),
        ),

        ],
      ),
    )
  );
}