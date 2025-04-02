import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testable_form/main.dart';
import 'package:testable_form/test/testable_form_field.dart';

void main() {

  testWidgets('Fill in the form with errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder number1Finder = find.byKey(Key('number-1-field'));
    expect(number1Finder, findsOneWidget);
    expect(tester.widget(number1Finder), isA<TestableFormField<int?>>());
    TestableFormField<int?> number1FormField = tester.widget(number1Finder);

    expect(number1FormField.getValue(), isNull);

    final Finder sumButtonFinder = find.byKey(Key('sum-btn'));
    expect(number1Finder, findsOneWidget);
    await tester.tap(sumButtonFinder);
    await tester.pump();

    expect(find.text('Please enter a number'), findsOneWidget);
    expect(find.textContaining('Result'), findsNothing);

  });

  testWidgets('Fill in the form and check result', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder number1Finder = find.byKey(Key('number-1-field'));
    expect(number1Finder, findsOneWidget);
    expect(tester.widget(number1Finder), isA<TestableFormField<int?>>());
    TestableFormField<int?> number1FormField = tester.widget(number1Finder);

    final Finder number2Finder = find.byKey(Key('number-2-field'));
    expect(number2Finder, findsOneWidget);
    expect(tester.widget(number2Finder), isA<TestableFormField<double>>());
    TestableFormField<double> number2FormField = tester.widget(number2Finder);

    number1FormField.setValue(5);
    number2FormField.setValue(3);

    final Finder sumButtonFinder = find.byKey(Key('sum-btn'));
    expect(number1Finder, findsOneWidget);
    await tester.tap(sumButtonFinder);
    await tester.pump();

    expect(find.text('Please enter a number'), findsNothing);
    expect(find.text('Result: 8'), findsOneWidget);

  });
}
