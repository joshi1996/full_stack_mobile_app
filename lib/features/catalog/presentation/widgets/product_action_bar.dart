import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    required this.onAddToCart,
    required this.onBuyNow,
    super.key,
  });

  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddToCart,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: FilledButton.icon(
            onPressed: onBuyNow,
            icon: const Icon(Icons.flash_on_outlined),
            label: const Text('Buy Now'),
          ),
        ),
      ],
    );
  }
}
