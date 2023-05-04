import 'package:fitness_app/pages/my_workouts_page.dart';
import 'package:flutter/material.dart';
import 'featured_workouts_page.dart';
import 'generate_workout.dart';
import 'get_started_page.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();

}

class _WorkoutPageState extends State<WorkoutPage> {
  
  @override
  Widget build(BuildContext context) => Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [

          Padding(padding: EdgeInsets.symmetric(vertical: 30)),

          Container(
            width: 400,
            height: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyWorkoutsPage()));
              },
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                shadowColor: Colors.black,
                elevation: 5,
                child: Image.asset("assets/images/my_workouts.png",
                fit: BoxFit.cover,
                isAntiAlias: true,
                ),
                

            ))
          ),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Center(child:Container(
            width: 400,
            height: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeaturedWorkoutsPage()));
              },
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                shadowColor: Colors.black,
                elevation: 5,
                child: Image.asset("assets/images/featured_workouts.png",
                fit: BoxFit.cover,
                isAntiAlias: true,
                ),
                

            ))
          ),),

          Padding(padding: EdgeInsets.symmetric(vertical: 10)),

          Container(
            width: 400,
            height: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GenerateWorkoutPage()));
              },
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                shadowColor: Colors.black,
                elevation: 5,
                child: Image.asset("assets/images/get_started.png",
                fit: BoxFit.cover,
                isAntiAlias: true,
                ),
                

              )
            )
          ),         
        ],
      ),
  ));
}