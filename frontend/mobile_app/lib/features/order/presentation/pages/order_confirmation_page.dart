import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Order Confirmed'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 90,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        Text(
                          'Order Placed Successfully!',
                          style: AppTextStyles.headingLarge,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          'Thank you for shopping with us.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        _InfoTile(title: 'Order ID', value: order.id),

                        _InfoTile(
                          title: 'Amount Paid',
                          value: '₹${order.pricing.total.toStringAsFixed(2)}',
                        ),

                        _InfoTile(
                          title: 'Payment Method',
                          value: order.paymentMethod.name.toUpperCase(),
                        ),

                        _InfoTile(
                          title: 'Delivery To',
                          value: order.address.recipientName,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              context.goNamed(RouteNames.orders);
                            },
                            child: const Text('View My Orders'),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              context.goNamed(RouteNames.home);
                            },
                            child: const Text('Continue Shopping'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
