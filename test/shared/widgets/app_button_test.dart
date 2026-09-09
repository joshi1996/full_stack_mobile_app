import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/shared/widgets/app_button.dart';

void main() {
  testWidgets('AppButton displays label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(label: 'Login', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('AppButton calls onPressed when tapped', (tester) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Login',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(wasPressed, isTrue);
  });

  testWidgets('AppButton shows loader while loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(label: 'Login', isLoading: true, onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Login'), findsNothing);
  });

  testWidgets('AppButton does not call onPressed while loading', (
    tester,
  ) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Login',
            isLoading: true,
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(wasPressed, isFalse);
  });
}
