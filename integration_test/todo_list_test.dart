// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';

const timeoutFindWidgets = 10;

void main() {
  testWidgets('Add todo test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    var tfToDoName = find.bySemanticsLabel('Add a new to-do item');
    expect(tfToDoName, findsOneWidget);
    await tester.enterText(tfToDoName, 'Test add');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('+'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Test add'), findsOneWidget);
  });

  testWidgets('Search test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsWidgets);
    await tester.enterText(find.bySemanticsLabel('Search'), 'Morning');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Search & delete test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsWidgets);
    await tester.enterText(find.bySemanticsLabel('Search'), 'Test add');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Search & add test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'abc');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsNothing);
    await tester.enterText(
        find.bySemanticsLabel('Add a new to-do item'), 'abc');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('+'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsNWidgets(1));
    await tester.tap(find.byIcon(Icons.delete));
  });

  testWidgets('Test show done', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'Buy');
    await tester.pump(const Duration(milliseconds: 100));
    var textStrikeThrough = find.byWidgetPredicate((widget) =>
        widget is Text &&
        widget.style?.decoration == TextDecoration.lineThrough);
    expect(textStrikeThrough, findsOneWidget);
  });

  testWidgets('Test show undone', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'Work');
    await tester.pump(const Duration(milliseconds: 100));
    var textStrikeThrough = find.byWidgetPredicate((widget) =>
        widget is Text &&
        widget.style?.decoration == TextDecoration.lineThrough);
    expect(textStrikeThrough, findsNothing);
  });

  testWidgets('Test trigger to done', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'Work');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.check_box_outline_blank));
    await tester.pump(const Duration(milliseconds: 100));
    var textStrikeThrough = find.byWidgetPredicate((widget) =>
        widget is Text &&
        widget.style?.decoration == TextDecoration.lineThrough);
    expect(textStrikeThrough, findsOneWidget);
  });

  testWidgets('Test trigger to undone', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'Work');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.check_box));
    await tester.pump(const Duration(milliseconds: 100));
    var textStrikeThrough = find.byWidgetPredicate((widget) =>
        widget is Text &&
        widget.style?.decoration == TextDecoration.lineThrough);
    expect(textStrikeThrough, findsNothing);
  });

  testWidgets('Test open details screen & edit', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'Work');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Work on mobile app for 2 hours'));
    await delay(100);
    expect(find.widgetWithText(TextField, 'Work on mobile app for 2 hours'),
        findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextField, 'Work on mobile app for 2 hours'),
        'Work on mobile app for 3 hours');
    await delay(100);
    await tester.tap(find.byIcon(Icons.done));
    expect(find.text('Work on mobile app for 3 hours'), findsOneWidget);
  });
}

Future delay(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}