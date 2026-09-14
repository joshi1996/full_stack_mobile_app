import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart.dart';

import 'cart_item_card.dart';
import 'cart_summary.dart';

class CartContentView extends StatelessWidget {
  const CartContentView({
    required this.cart,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onClearCart,
    required this.onCheckout,
    super.key,
  });

  final Cart cart;
  final ValueChanged<CartItemQuantityChange> onQuantityChanged;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearCart;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _buildDesktop(context);
        }

        return _buildMobile(context);
      },
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildItems(context)),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: CartSummary(cart: cart, onCheckout: onCheckout),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _buildItems(context),
          const SizedBox(height: AppSpacing.lg),
          CartSummary(cart: cart, onCheckout: onCheckout),
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${cart.totalItems} items',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            TextButton(onPressed: onClearCart, child: const Text('Clear Cart')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...cart.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: CartItemCard(
              item: item,
              onQuantityChanged: (quantity) {
                onQuantityChanged(
                  CartItemQuantityChange(
                    productId: item.productId,
                    quantity: quantity,
                  ),
                );
              },
              onRemove: () => onRemove(item.productId),
            ),
          ),
        ),
      ],
    );
  }
}

class CartItemQuantityChange {
  const CartItemQuantityChange({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;
}
