import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/routing/app_router.dart';
import 'package:full_stack_mobile_app/core/theme/app_theme.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Full Stack Mobile App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.createRouter(getIt<AuthBloc>()),
    );
  }
}
