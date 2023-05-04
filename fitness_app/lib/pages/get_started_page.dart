import 'package:fitness_app/pages/workout_history.dart';
import 'package:flutter/material.dart';
//import 'package:getwidget/getwidget.dart';

import 'generate_workout.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPage();

}

class _GetStartedPage extends State<GetStartedPage>{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text("GETTING STARTED",
          style: TextStyle(fontSize: 40))
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: 450,
                  height: 300,
                  child: Card(
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Center(
                          child: Text("GENERATE A PLAN",
                          style: TextStyle(fontSize: 30)),
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),

                        Container(
                          width: 375,
                          height: 50,                 
                          child: Text("lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll")                        
                        ),

                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                        Center(
                          child: TextButton(
                            child: Text("Create a Plan",
                              style: TextStyle(
                              fontSize: 30
                                )
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GenerateWorkoutPage()));
                            },                          
                          )
                        ),

                      ],
                    )
                  )
                )
              ],
            )
          ),
        
      ],
    ),
  );
}