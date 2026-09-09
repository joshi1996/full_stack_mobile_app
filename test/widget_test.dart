import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/core/responsive/responsive_layout.dart';

Widget buildTestWidget() {
  return const Directionality(
    textDirection: TextDirection.ltr,
    child: ResponsiveLayout(
      mobile: Text('Mobile Layout'),
      tablet: Text('Tablet Layout'),
      desktop: Text('Desktop Layout'),
    ),
  );
}

void main() {
  testWidgets('renders mobile layout', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Mobile Layout'), findsOneWidget);
  });

  testWidgets('renders tablet layout', (tester) async {
    tester.view.physicalSize = const Size(1000, 1000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Tablet Layout'), findsOneWidget);
  });

  testWidgets('renders desktop layout', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Desktop Layout'), findsOneWidget);
  });
}
