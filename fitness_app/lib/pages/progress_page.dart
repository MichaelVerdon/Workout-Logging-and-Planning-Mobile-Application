import 'package:fitness_app/pages/todays_stats_page.dart';
import 'package:fitness_app/pages/workout_history.dart';
import 'package:flutter/material.dart';

import 'gallery_page.dart';
import 'graph_page.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();

}

class _ProgressPageState extends State<ProgressPage> {

  
   
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),

          Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),

              Container(
                width: 150,
                height: 250,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TodaysStatsPage()));
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Image.asset("assets/images/todays_stats.png",
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    ),                
                  )
                )
              ),

              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

              Container(
              width: 150,
              height: 250,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GraphPage()));
                },
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Image.asset("assets/images/view_graphs.png",
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  ),
                  

                )
              )
            ),  
          ],
        ),

        Padding(padding: EdgeInsets.symmetric(vertical: 20)),

        Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),

              Container(
                width: 150,
                height: 250,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkoutHistoryPage()));
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Image.asset("assets/images/workout_history.png",
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    ),                
                  )
                )
              ),

              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

              Container(
              width: 150,
              height: 250,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GalleryPage()));
                },
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: Image.asset("assets/images/gallery.png",
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  ),
                  

                )
              )
            ),  
          ],
        ),

          

          
      ],
    )
  );
}