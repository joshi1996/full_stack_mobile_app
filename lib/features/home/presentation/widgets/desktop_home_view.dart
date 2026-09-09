import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:go_router/go_router.dart';

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(RouteNames.login);
          },
          child: const Text('Go to Login'),
        ),
      ),
    );
  }
}
