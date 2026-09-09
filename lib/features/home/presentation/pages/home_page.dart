import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/responsive/responsive_layout.dart';
import '../widgets/desktop_home_view.dart';
import '../widgets/mobile_home_view.dart';
import '../widgets/tablet_home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const MobileHomeView(),
      tablet: const TabletHomeView(),
      desktop: const DesktopHomeView(),
    );
  }
}
