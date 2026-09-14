import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import '../../domain/entities/checkout_pricing.dart';

class CheckoutPricingSection extends StatelessWidget {
  const CheckoutPricingSection({required this.pricing, super.key});

  final CheckoutPricing pricing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            _PriceRow(label: 'Subtotal', value: pricing.subtotal),
            _PriceRow(label: 'Discount', value: -pricing.discount),
            _PriceRow(label: 'Delivery', value: pricing.deliveryFee),
            _PriceRow(label: 'Tax', value: pricing.tax),
            const Divider(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  '₹${pricing.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final prefix = value < 0 ? '- ' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$prefix₹${value.abs().toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
