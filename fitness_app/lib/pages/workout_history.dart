import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPage();

}

class _WorkoutHistoryPage extends State<WorkoutHistoryPage>{

  @override
  void initState(){
    super.initState();
    populateContent();
  }

  List<dynamic> historyContent = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _workoutHistoryFile async {
    final path = await _localPath;
    return File('$path/workoutHistory.json');
  }

  Future<void> populateContent() async {

    final file = await _workoutHistoryFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      file.writeAsString("[]");
    }

    final contents = await file.readAsString();

    List<dynamic> decodedContents = await jsonDecode(contents);

    print(decodedContents);

    setState(() {
      historyContent = decodedContents;
    });
    

  }

  String formatDate(var date){
    List<String> dateElements = date.split("-");
    return "${dateElements[2]} ${dateElements[1]} ${dateElements[0]}";
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text("WORKOUT HISTORY",
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
                  itemCount: historyContent.length,
                  itemBuilder:(context, index) {
                    return Card(
                      color: Colors.grey[100],
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          formatDate(historyContent[index]["date"]),
                          style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                        trailing: Text(
                          historyContent[index]["workout"],
                          style: TextStyle(
                                  fontSize: 30
                                ),
                          ),
                      )
                    );
                  },
            )
          )
        )
      ],
    )
  );
}