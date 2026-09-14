import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../cart/domain/entities/cart.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../widgets/checkout_content_view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({required this.cart, super.key});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CheckoutBloc>()..add(CheckoutStarted(cart)),
      child: const Scaffold(
        appBar: _CheckoutAppBar(),
        body: CheckoutContentView(),
      ),
    );
  }
}

class _CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CheckoutAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Checkout'));
  }
}
