import 'package:flutter/material.dart';

class CustomerPlaceholderPage extends StatelessWidget {
  const CustomerPlaceholderPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
