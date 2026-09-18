import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_radius.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart_item.dart';
import 'package:full_stack_mobile_app/shared/widgets/app_network_image.dart';
import 'package:full_stack_mobile_app/shared/widgets/price_text.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildDetails(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AppNetworkImage(
      imageUrl: item.imageUrl,
      width: 96,
      height: 96,
      borderRadius: BorderRadius.circular(AppRadius.md),
      fit: BoxFit.cover,
      semanticLabel: item.productName,
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PriceText(price: item.unitPrice),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _QuantityButton(
              icon: Icons.remove,
              onPressed: item.quantity > 1
                  ? () => onQuantityChanged(item.quantity - 1)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                '${item.quantity}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _QuantityButton(
              icon: Icons.add,
              onPressed: () => onQuantityChanged(item.quantity + 1),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Remove',
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          side: BorderSide(color: Theme.of(context).dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
    );
  }
}
