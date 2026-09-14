import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/app.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_event.dart';

void main() {
  registerAuthDependencies();
  registerHomeDependencies();
  registerCatalogDependencies();
  registerCartDependencies();
  registerCheckoutDependencies();
  registerAddressDependencies();
  registerOrderDependencies();

  final authBloc = getIt<AuthBloc>();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc..checkAuthStatus()),
        BlocProvider(
          create: (_) => getIt<CartBloc>()..add(const CartStarted()),
        ),
      ],
      child: const App(),
    ),
  );
}
