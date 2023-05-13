import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:fitness_app/pages/me_page.dart';
import 'package:fitness_app/pages/progress_page.dart';
import 'package:fitness_app/pages/workouts_page.dart';
import 'package:fitness_app/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Fitness App',

      theme: ThemeData(

        //primaryColor: Color.fromARGB(255, 51, 255, 85),
        scaffoldBackgroundColor: Colors.grey[100],
        //scaffoldBackgroundColor: Colors.white,

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            //backgroundColor: Color.fromARGB(255, 71, 59, 240),
            backgroundColor: Colors.blue[100],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          )
        ),


        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Color.fromARGB(255, 0, 0, 0),
          displayColor: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'Inter'
        ),

        //Text sizes
        //Header 1: 40
        //Header 2: 30


      ),

      home: SplashPage(),

    );

  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState(){
    super.initState();
    //resetFiles();
    initStepCounter();
    handleSaving();
  }

  //Step counting continues as long as app is running
  bool debounce = false;
  double accell = 0;
  int stepCount = 0;
  int tempStepCount = 0;
  double distanceCount = 0;

  void handleSaving() async {

    while(true){
      await Future.delayed(Duration(seconds: 10));
      if(tempStepCount >= 45){
         updateCalorieInfo();
      }
      saveStepsInfo();
      savedistanceInfo();
    }

  }

  void initStepCounter() async {

    userAccelerometerEvents.listen((UserAccelerometerEvent event) async {

      var x = event.x;
      var z = event.z;

      accell = sqrt(pow(x, 2) + pow(z, 2));

      if(!debounce && accell > 2){
        // accell = 2
        debounce = true;

        setState(() {
        stepCount++;
        tempStepCount++;
        distanceCount += 0.74;
        });

        await Future.delayed(Duration(milliseconds: 450));
        debounce = false;

      }

    },);
  }

  Future<String> get _localPath async {

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;

  }

  Future<File> get _caloriesFile async {
    final path = await _localPath;
    return File('$path/caloriesBurned.json');
  }

  Future<void> updateCalorieInfo() async {

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

    num totalCalories = (tempStepCount/45).round();
    setState(() {
      tempStepCount -= 45;
    });

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

  Future<File> get _stepsFile async {
    final path = await _localPath;
    return File('$path/steps.json');
  }

  Future<void> saveStepsInfo() async {

    final file = await _stepsFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _stepsFile;
      file.writeAsString("[]");
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);

    final contents = await file.readAsString();

    if(contents == null){
      file.writeAsString("[]");
    }

    List<dynamic> decodedContents = await jsonDecode(contents);

    int steps = stepCount;
    setState(() {
      stepCount = 0;
    });

    var map={
      "date":formattedDate,
      "steps":"0"
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
        int currentSteps = int.parse(decodedContents[i]["steps"]);
        decodedContents[i]["steps"] = (currentSteps + steps).toString();
      }
    }

    String encodedStepsInfo = jsonEncode(decodedContents);
    final stepsFile = await _stepsFile;

    stepsFile.writeAsString(encodedStepsInfo);

    print("steps saved");
    print("encoded info: ${encodedStepsInfo}");
  
  }

  Future<File> get _distanceFile async {
    final path = await _localPath;
    return File('$path/distance.json');
  }

  //For debugging
  Future<void> resetFiles() async{
    final file1 = await _distanceFile;
    final file2 = await _stepsFile;
    final file3 = await _caloriesFile;
    file1.writeAsString("[]");
    file2.writeAsString("[]");
    file3.writeAsString("[]");
  }

  Future<void> savedistanceInfo() async {

    final file = await _distanceFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _stepsFile;
      file.writeAsString("[]");
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);

    final contents = await file.readAsString();

    if(contents == null){
      file.writeAsString("[]");
    }

    List<dynamic> decodedContents = await jsonDecode(contents);

    double distance = distanceCount;
    setState(() {
      distanceCount = 0;
    });

    var map={
      "date":formattedDate,
      "distance":"0"
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
        int currentDistance = int.parse(decodedContents[i]["distance"]);
        decodedContents[i]["distance"] = (currentDistance + distance.round()).toString();
      }
    }

    String encodedDistanceInfo = jsonEncode(decodedContents);
    final distanceFile = await _distanceFile;

    distanceFile.writeAsString(encodedDistanceInfo);

    print("distance saved");
    print("encoded info: ${encodedDistanceInfo}");
  
  }

  int currentPage = 1;

  final screens = [
    WorkoutPage(),
    MePage(),
    ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold (

    body: screens[currentPage],
    bottomNavigationBar: NavigationBar(
      height: 60,
      elevation: 20,
      backgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 1000),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: currentPage,
      onDestinationSelected: (currentPage) => setState( () => this.currentPage = currentPage), 
      destinations: [
        NavigationDestination(
          icon: SizedBox(width: 40, height: 40, child: SvgPicture.asset("assets/images/dumbbell.svg")),
          label: "Workouts",
        ),
        NavigationDestination(
          icon: SizedBox(width: 40, height: 40, child: SvgPicture.asset("assets/images/person.svg")),
          label: "Me",
        ),
        NavigationDestination(
          icon: SizedBox(width: 40, height: 40, child: SvgPicture.asset("assets/images/graph.svg")),
          label: "Progress"
        ),
      ],
    ),   
  );
}

