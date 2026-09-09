import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/shared/widgets/app_text_field.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('AppTextField displays label and hint', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            label: 'Email',
            hint: 'Enter your email',
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
  });

  testWidgets('AppTextField accepts user input', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(controller: controller, label: 'Email'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'amit@example.com');

    expect(controller.text, 'amit@example.com');
  });

  testWidgets('AppTextField calls onChanged', (tester) async {
    String? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            label: 'Email',
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'hello@example.com');

    expect(changedValue, 'hello@example.com');
  });

  testWidgets('AppTextField validates input', (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              label: 'Email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }

                return null;
              },
            ),
          ),
        ),
      ),
    );

    final isValid = formKey.currentState!.validate();

    await tester.pump();

    expect(isValid, isFalse);
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('AppTextField hides password when obscureText is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            label: 'Password',
            obscureText: true,
          ),
        ),
      ),
    );

    final textField = tester.widget<EditableText>(find.byType(EditableText));

    expect(textField.obscureText, isTrue);
  });
}
