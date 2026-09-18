import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_content_view.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_error_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CartView();
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CartStatus.failure) {
            return CartErrorView(
              message: state.errorMessage ?? 'Unable to load cart.',
              onRetry: () {
                context.read<CartBloc>().add(const CartStarted());
              },
            );
          }

          if (state.cart.isEmpty) {
            return CartEmptyView(
              onContinueShopping: () {
                context.goNamed(RouteNames.explore);
              },
            );
          }

          return CartContentView(
            cart: state.cart,
            onQuantityChanged: (change) {
              context.read<CartBloc>().add(
                CartQuantityUpdated(
                  productId: change.productId,
                  quantity: change.quantity,
                ),
              );
            },
            onRemove: (productId) {
              context.read<CartBloc>().add(CartItemRemoved(productId));
            },
            onClearCart: () {
              context.read<CartBloc>().add(const CartCleared());
            },
            onCheckout: () {
              context.pushNamed(RouteNames.checkout, extra: state.cart);
            },
          );
        },
      ),
    );
  }
}
