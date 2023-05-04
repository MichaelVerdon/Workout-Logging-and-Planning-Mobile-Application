import 'package:fitness_app/model/featuredWorkouts.dart';
import 'package:fitness_app/pages/workout_selected.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/model/workout.dart';
import 'package:fitness_app/model/testWorkoutList.dart';

import 'featured_workout_selected.dart';

class FeaturedWorkoutsPage extends StatefulWidget {
  const FeaturedWorkoutsPage({super.key});

  @override
  State<FeaturedWorkoutsPage> createState() => _FeaturedWorkoutsPage();

}

class _FeaturedWorkoutsPage extends State<FeaturedWorkoutsPage>{

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
            child: Text("Featured Workouts",
            style: TextStyle(
              fontSize: 40,
              )
            )
          ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        SizedBox(
          height: 200,
          width: 500,
          child: Scrollbar(
            thumbVisibility: true,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredList.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FeaturedWorkoutSelectedPage(workout: featuredList[index])));
                },
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Image.asset(featuredListAsset[index],
                      fit: BoxFit.cover,
                      isAntiAlias: true,
                    ),
                  )
                )
              );
            }))
          )
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
            child: Text("For Beginners",
            style: TextStyle(
              fontSize: 40,
              )
            )
          ),

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        SizedBox(
          height: 200,
          width: 500,
          child: Scrollbar(
            thumbVisibility: true,
          
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forBeginners.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FeaturedWorkoutSelectedPage(workout: forBeginners[index])));
                },
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Image.asset(featuredBeginnersAsset[index],
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    )
                  )
                )
              );
            }))
          )
        ),
      ],
    ),
  );
}