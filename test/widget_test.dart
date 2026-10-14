import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_task_priority_predictor/app.dart';

void main() {
  testWidgets('App loads home screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SmartTaskApp());
    await tester.pumpAndSettle();
    expect(find.text('Smart Task Priority'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
