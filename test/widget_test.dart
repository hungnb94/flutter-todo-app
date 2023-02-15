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
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Test add'), findsOneWidget);
  });
}
