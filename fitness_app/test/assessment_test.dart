import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/helpers/assessPerformance.dart';

void main() {
  testWidgets("Goal Met", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: assessPerformance([8,8,8], 8)));
    expect(find.byWidgetPredicate(
      (widget) => widget is Icon &&
                   widget.icon == Icons.arrow_circle_up_outlined &&
                   widget.color == Colors.green &&
                   widget.size == 30.0
    ), findsOneWidget);
  });

  testWidgets("No Progress", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: assessPerformance([9,9,9], 10)));
    expect(find.byWidgetPredicate(
      (widget) => widget is Icon &&
                   widget.icon == Icons.arrow_circle_right_outlined &&
                   widget.color == Colors.black &&
                   widget.size == 30.0
    ), findsOneWidget);
  });

  testWidgets("Below last results", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: assessPerformance([12,12,12], 14)));
    expect(find.byWidgetPredicate(
      (widget) => widget is Icon &&
                   widget.icon == Icons.arrow_circle_down_outlined &&
                   widget.color == Colors.red &&
                   widget.size == 30.0
    ), findsOneWidget);
  });
}