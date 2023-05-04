import 'package:fitness_app/helpers/workoutGenerator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data.dart';

class TestData{
  List<List<dynamic>> list = [
    ["Flat Bench Press","Chest/Triceps/Shoulders","Intermediate",2,"Dumbbells+Bench",3],
    ["Barbell Rows","Back/Biceps","Intermediate",2,"Barbell+Weight Plates",3],
    ["Hanging Leg Raises","Abdominals","Intermediate",2,"Pullup Bar",1],
    ["Calf Press","Calves","Beginner",3,"Gym",1],
  ];
  
  List<List<dynamic>> returnList(){
    return list;
  }
}


void main() {

  List<List<dynamic>> _listData = TestData().returnList();
  test('Can filter by experience level', () async {

    WorkoutGenerator workoutGenerator = WorkoutGenerator(_listData, 'Beginner', 'Both', 2, [], ['Mon', 'Wed', 'Fri'], 60);
    List<List<dynamic>> filteredExercises = workoutGenerator.filterByExperience(_listData);
    expect(filteredExercises, [
      ["Calf Press","Calves","Beginner",3,"Gym",1],
    ]);
  });
  test('Can filter by access level', () async {
    WorkoutGenerator workoutGenerator = WorkoutGenerator(_listData, 'Intermediate', 'Both', 2, ["Barbell", "Weight Plates"], ['Mon', 'Wed', 'Fri'], 60);
    List<List<dynamic>> filteredExercises = workoutGenerator.filterByAccess(_listData);
    expect(filteredExercises, [
      ['Barbell Rows', 'Back/Biceps', 'Intermediate', 2, 'Barbell+Weight Plates', 3],
    ]);
  });
}