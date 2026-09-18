import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class PriceText extends StatelessWidget {
  const PriceText({required this.price, this.originalPrice, super.key});

  final double price;
  final double? originalPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        Text(
          '₹${price.toStringAsFixed(0)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (originalPrice != null)
          Text(
            '₹${originalPrice!.toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
