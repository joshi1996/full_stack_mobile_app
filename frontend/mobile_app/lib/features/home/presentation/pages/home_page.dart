import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/responsive/responsive_layout.dart';

import '../widgets/desktop_home_view.dart';
import '../widgets/mobile_home_view.dart';
import '../widgets/tablet_home_view.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
      child: const ResponsiveLayout(
        mobile: MobileHomeView(),
        tablet: TabletHomeView(),
        desktop: DesktopHomeView(),
      ),
    );
  }
}
