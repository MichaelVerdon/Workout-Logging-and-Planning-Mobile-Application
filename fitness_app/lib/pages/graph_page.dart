import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPage();

}

class _GraphPage extends State<GraphPage>{

  String? _timeDropdownValue;
  String? _metricDropdownValue;
  String? _periodDropdownValue;

  void timeDropDownCallback(String? selectedValue){ //For dropdown menu
    if (selectedValue is String){
      setState(() {
        _timeDropdownValue = selectedValue;
      });
    }
  }

  void metricDropDownCallback(String? selectedValue){ //For dropdown menu
    if (selectedValue is String){
      setState(() {
        _metricDropdownValue = selectedValue;
      });
    }
  }

  void periodDropDownCallback(String? selectedValue){ //For dropdown menu
    if (selectedValue is String){
      setState(() {
        _periodDropdownValue = selectedValue;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
        Center(
          child: Text("Graph View",
          style: TextStyle(
            fontSize: 40,
            decoration: TextDecoration.underline,
              )
            )
          ),


          Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

              Text("Time Interval:",
              style: TextStyle(fontSize: 20)),

              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),

              SizedBox(
              width: 120,
              height: 50,             
    
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Interval",              
                ),
              
                items: const [
                  DropdownMenuItem(value: "Daily", child: Text("Daily")),
                  DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                  DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                
                ],
                onChanged: timeDropDownCallback,
                value: _timeDropdownValue
                                       
              ) 
            )
            ],
          ),

          Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

              Text("Metric:",
              style: TextStyle(fontSize: 20)),

              Padding(padding: EdgeInsets.symmetric(horizontal: 50)),

              SizedBox(
              width: 120,
              height: 50,             
    
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Metric",              
                ),
              
                items: const [
                  DropdownMenuItem(value: "Calories", child: Text("Calories")),
                  DropdownMenuItem(value: "Steps", child: Text("Steps")),
                  DropdownMenuItem(value: "Distance", child: Text("Distance")),
                  DropdownMenuItem(value: "Weight", child: Text("Weight")),
                
                ],
                onChanged: metricDropDownCallback,
                value: _metricDropdownValue
                                       
              ) 
            )

            ],
          ),

          Row(
            children: [

              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),

              Text("Time Period:",
              style: TextStyle(fontSize: 20)),

              Padding(padding: EdgeInsets.symmetric(horizontal:25)),

              SizedBox(
              width: 120,
              height: 50,             
    
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Period",              
                ),
              
                items: const [
                  DropdownMenuItem(value: "Week", child: Text("Week")),
                  DropdownMenuItem(value: "Month", child: Text("Month")),
                  DropdownMenuItem(value: "Quarter", child: Text("Quarter")),
                  DropdownMenuItem(value: "Half Year", child: Text("Half Year")),
                  DropdownMenuItem(value: "Year", child: Text("Year")),
                
                ],
                onChanged: periodDropDownCallback,
                value: _periodDropdownValue
                                       
              ) 
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal:5)),

            TextButton(
              onPressed: (){
                  setState(() => {});
                }, child: Text("Create"),
              ),
            
            ],
          ),

          //Histogram for steps and distance
          //Add Axis Names
          SizedBox(
            width: 500,
            height: 200,
            child:LineChart(  
              LineChartData(
                maxX: 8,
                maxY: 8,
                minX: 0,
                minY: 0,
                lineBarsData: [
                 LineChartBarData(
                    spots: [
                      const FlSpot(0, 1),
                      const FlSpot(2, 3),
                      const FlSpot(4, 5),
                      const FlSpot(6, 7),

                  ]
                )
              ]
            )
          )
        )        
      ],
    )
  );
}