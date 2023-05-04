import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

class TodaysStatsPage extends StatefulWidget {
  const TodaysStatsPage({super.key});

  @override
  State<TodaysStatsPage> createState() => _TodaysStatsPage();

}

class _TodaysStatsPage extends State<TodaysStatsPage>{

  @override
  void initState(){
    super.initState();
    //setState(() {
    //  stepsController.text = steps;
    //  caloriesController.text = caloriesBurned;
    //  distanceController.text = distance;
    //});
    readCalories();
    readStepsFile();
    readDistanceFile();
  }

  String steps = "0";
  String caloriesBurned = "0";
  String distance = "0 m";

  TextEditingController stepsController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  Future<String> get _localPath async {
    
      final directory = await getApplicationDocumentsDirectory();

      return directory.path;
    }

  Future<File> get _caloriesFile async {
    final path = await _localPath;
    return File('$path/caloriesBurned.json');
  }

  Future<void> readCalories() async{

    final file = await _caloriesFile;

    
    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _caloriesFile;
      file.writeAsString("[]");
    }

    try{
      final file = await _caloriesFile;
      final contents = await file.readAsString();
      List<dynamic> decodedContents = await jsonDecode(contents);
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month);
      String formattedDate = date.toString().substring(0,10);

      for(var i = 0; i <= decodedContents.length; i++){
        if(decodedContents[i]["date"] == formattedDate){

          setState(() {
            caloriesController.text = decodedContents[i]["calories"].toString();
          });          
          
        }
      }
    }
    // ignore: empty_catches
    catch(e){
      print("wtf");
    }


  }

  Future<File> get _stepsFile async {
    final path = await _localPath;
    return File('$path/steps.json');
  }

  Future<void> readStepsFile() async{

    try{
      final file = await _stepsFile;
      final contents = await file.readAsString();
      List<dynamic> decodedContents = await jsonDecode(contents);

      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month);
      String formattedDate = date.toString().substring(0,10);

      for(var i = 0; i <= decodedContents.length; i++){
        if(decodedContents[i]["date"] == formattedDate){

          setState(() {
            stepsController.text = decodedContents[i]["steps"];
          });          
          
        }
      }
    }
    // ignore: empty_catches
    catch(e){
      print("wtf");
    }

  }

  Future<File> get _distanceFile async {
    final path = await _localPath;
    return File('$path/distance.json');
  }

  Future<void> readDistanceFile() async{

    final file = await _distanceFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _distanceFile;
      file.writeAsString("[]");
    }

    try{
      final file = await _distanceFile;
      final contents = await file.readAsString();
      List<dynamic> decodedContents = await jsonDecode(contents);

      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month);
      String formattedDate = date.toString().substring(0,10);

      for(var i = 0; i <= decodedContents.length; i++){
        if(decodedContents[i]["date"] == formattedDate){

          setState(() {
            distanceController.text = decodedContents[i]["distance"];
          });          
          
        }
      }
    }
    // ignore: empty_catches
    catch(e){
      print("wtf");
    }

  }
  

  @override
  Widget build(BuildContext context) => Scaffold(

    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        
        Center(
          child: Text("TODAY'S STATS",
          style: TextStyle(
            fontSize: 40,
              )
            )
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: 375,
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text("Total Calories Burned",
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text(caloriesController.text,
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                        Icon(CupertinoIcons.flame_fill, size: 40,)

                      ],
                    )
                  )
                )
              ],
            )
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: 375,
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text("Steps",
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text(stepsController.text,
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                        Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset("assets/images/steps.svg")
                          )
                        )
                        

                      ],
                    )
                  )
                )
              ],
            )
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: 375,
                  height: 150,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text("Distance Travelled",
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text("${distanceController.text} m",
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                        Icon(Icons.directions_walk, size: 40,)

                      ],
                    )
                  )
                )
              ],
            )
          ),

      ],
    )
  );
}