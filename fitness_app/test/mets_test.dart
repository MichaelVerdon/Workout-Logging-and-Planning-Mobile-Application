
import 'package:fitness_app/helpers/exerciseCalorieCounter.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Exercise 1", (){
    ExerciseCalorieCounter counter = ExerciseCalorieCounter([8,7,6],
    3, 67.5);
    int toAdd = counter.exerciseFinished();
    expect(toAdd, 52);
  });
  test("Exercise 2", (){
    ExerciseCalorieCounter counter = ExerciseCalorieCounter([12,12,12],
    3, 80);
    int toAdd = counter.exerciseFinished();
    expect(toAdd, 72);
  });
  test("Exercise 3", (){
    ExerciseCalorieCounter counter = ExerciseCalorieCounter([5,5,5,5],
    4, 70);
    int toAdd = counter.exerciseFinished();
    expect(toAdd, 68);
  });
}