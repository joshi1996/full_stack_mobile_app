import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/shared/widgets/discount_badge.dart';
import 'package:full_stack_mobile_app/shared/widgets/price_text.dart';
import 'package:full_stack_mobile_app/shared/widgets/rating_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(
              imageUrl: imageUrl,
              discountPercentage: discountPercentage,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (rating != null)
                    RatingView(rating: rating!, reviewCount: reviewCount),
                  const SizedBox(height: AppSpacing.sm),
                  PriceText(price: price, originalPrice: originalPrice),
                  if (onAddToCart != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onAddToCart,
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, this.discountPercentage});

  final String imageUrl;
  final int? discountPercentage;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(Icons.image_not_supported_outlined),
                );
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          if (discountPercentage != null)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: DiscountBadge(percentage: discountPercentage!),
            ),
        ],
      ),
    );
  }
}
