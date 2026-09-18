import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/shared/widgets/app_loader.dart';

void main() {
  testWidgets('AppLoader displays CircularProgressIndicator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppLoader())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppLoader uses the provided size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AppLoader(size: 48))),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

    expect(sizedBox.width, 48);
    expect(sizedBox.height, 48);
  });
}
