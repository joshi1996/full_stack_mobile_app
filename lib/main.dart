import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/app.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  registerAuthDependencies();
  registerHomeDependencies();
  registerCatalogDependencies();

  final authBloc = getIt<AuthBloc>();

  runApp(
    BlocProvider.value(value: authBloc..checkAuthStatus(), child: const App()),
  );
}
