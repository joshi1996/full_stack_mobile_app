import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= AppBreakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        }

        if (width >= AppBreakpoints.tablet) {
          return tablet ?? mobile;
        }

        return mobile;
      },
    );
  }
}
