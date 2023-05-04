import 'package:fitness_app/helpers/BMR.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Male output", (){
    BMRCalculator calc = BMRCalculator(
      22, "Male", 174, 67.4);
    int result = calc.getBMR();
    expect(result, 2001);
  });
  test("Female output", (){
    BMRCalculator calc = BMRCalculator(
      29, "Female", 163, 60);
    int result = calc.getBMR();
    expect(result, 1682);
  });
  test("Other output", (){
    BMRCalculator calc = BMRCalculator(
      24, "Other", 190, 70);
    int result = calc.getBMR();
    expect(result, 1991);
  });
}