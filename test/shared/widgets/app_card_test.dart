import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/shared/widgets/app_card.dart';

void main() {
  testWidgets('AppCard renders its child', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AppCard(child: Text('Product'))),
      ),
    );

    expect(find.text('Product'), findsOneWidget);
  });

  testWidgets('AppCard calls onTap when tapped', (tester) async {
    var wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppCard(
            onTap: () {
              wasTapped = true;
            },
            child: const Text('Product'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Product'));
    await tester.pump();

    expect(wasTapped, isTrue);
  });

  testWidgets('AppCard does not require onTap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppCard(child: Text('Product'))),
      ),
    );

    expect(find.text('Product'), findsOneWidget);
  });
}
