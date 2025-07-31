import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fuelapp_by_joil/main.dart';

void main() {
  testWidgets('FuelApp starts and shows MaterialApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify app title
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'FuelApp');
  });
}