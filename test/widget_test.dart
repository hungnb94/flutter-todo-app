// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';

void main() {
  testWidgets('Add todo test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    var tfToDoName = find.bySemanticsLabel('Add a new todo item');
    expect(tfToDoName, findsOneWidget);
    await tester.enterText(tfToDoName, 'Test add');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('+'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Test add'), findsOneWidget);
  });

  testWidgets('Search test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byType(ListTile), findsWidgets);
    await tester.enterText(find.bySemanticsLabel('Search'), 'Morning');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Search & delete test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byType(ListTile), findsWidgets);
    await tester.enterText(find.bySemanticsLabel('Search'), 'Morning');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Search & add test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.bySemanticsLabel('Search'), 'abc');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ListTile), findsNothing);
    await tester.enterText(find.bySemanticsLabel('Add a new todo item'), 'abc');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('+'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.bySemanticsLabel('Add a new todo item'), 'abc');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('+'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListTile), findsNWidgets(2));
  });
}
