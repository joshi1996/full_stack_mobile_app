import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/price_text.dart';
import '../../../../shared/widgets/rating_view.dart';
import '../../domain/entities/product.dart';
import 'product_action_bar.dart';

class ProductInformation extends StatelessWidget {
  const ProductInformation({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrand(theme),
        const SizedBox(height: AppSpacing.sm),

        _buildProductName(theme),
        const SizedBox(height: AppSpacing.md),

        _buildRating(),
        const SizedBox(height: AppSpacing.lg),

        _buildPricing(theme),
        const SizedBox(height: AppSpacing.xl),

        _buildAvailability(theme),
        const SizedBox(height: AppSpacing.xl),

        _buildDescription(theme),
        const SizedBox(height: AppSpacing.xl),

        ProductActionBar(
          onAddToCart: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add to Cart will be connected soon.'),
              ),
            );
          },
          onBuyNow: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Buy Now will be connected soon.')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrand(ThemeData theme) {
    return Text(
      product.brand,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProductName(ThemeData theme) {
    return Text(
      product.name,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildRating() {
    return RatingView(rating: product.rating, reviewCount: product.reviewCount);
  }

  Widget _buildPricing(ThemeData theme) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        PriceText(price: product.price, originalPrice: product.originalPrice),
        if (product.discountPercentage != null)
          Text(
            '${product.discountPercentage}% OFF',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }

  Widget _buildAvailability(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Available',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this product',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product.description,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
