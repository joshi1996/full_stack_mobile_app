import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/shared/widgets/app_network_image.dart';

void main() {
  group('AppNetworkImage', () {
    testWidgets('shows error icon when image fails to load', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: AppNetworkImage(imageUrl: 'invalid://image'),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });
  });
}
