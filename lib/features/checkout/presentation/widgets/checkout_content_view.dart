import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout.dart';

import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_state.dart';
import 'checkout_address_section.dart';
import 'checkout_items_section.dart';
import 'checkout_payment_section.dart';
import 'checkout_place_order_button.dart';
import 'checkout_pricing_section.dart';

class CheckoutContentView extends StatelessWidget {
  const CheckoutContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        switch (state.status) {
          case CheckoutStatus.initial:
          case CheckoutStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case CheckoutStatus.failure:
            return _CheckoutErrorView(
              message: state.errorMessage,
              onRetry: () {
                // Retry will be connected when checkout
                // becomes backend-driven.
              },
            );

          case CheckoutStatus.success:
            final checkout = state.checkout;

            if (checkout == null) {
              return const Center(
                child: Text('Checkout information unavailable'),
              );
            }

            if (checkout.items.isEmpty) {
              return const _EmptyCheckoutView();
            }

            return _CheckoutSuccessView(checkout: checkout);
        }
      },
    );
  }
}

class _CheckoutSuccessView extends StatelessWidget {
  const _CheckoutSuccessView({required this.checkout});

  final Checkout checkout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          CheckoutAddressSection(address: checkout.address),
                          const SizedBox(height: 16),
                          CheckoutItemsSection(items: checkout.items),
                          const SizedBox(height: 16),
                          CheckoutPaymentSection(
                            paymentMethod: checkout.paymentMethod,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          CheckoutPricingSection(pricing: checkout.pricing),
                          const SizedBox(height: 16),
                          CheckoutPlaceOrderButton(checkout: checkout),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CheckoutAddressSection(address: checkout.address),
              const SizedBox(height: 16),
              CheckoutItemsSection(items: checkout.items),
              const SizedBox(height: 16),
              CheckoutPaymentSection(paymentMethod: checkout.paymentMethod),
              const SizedBox(height: 16),
              CheckoutPricingSection(pricing: checkout.pricing),
              const SizedBox(height: 16),
              CheckoutPlaceOrderButton(checkout: checkout),
            ],
          ),
        );
      },
    );
  }
}

class _CheckoutErrorView extends StatelessWidget {
  const _CheckoutErrorView({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              message ?? 'Unable to load checkout.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _EmptyCheckoutView extends StatelessWidget {
  const _EmptyCheckoutView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64),
            SizedBox(height: 16),
            Text(
              'Your cart is empty.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
