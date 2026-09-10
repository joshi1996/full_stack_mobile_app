import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../domain/entities/product_preview.dart';

class ProductHorizontalList extends StatelessWidget {
  const ProductHorizontalList({required this.products, super.key});

  final List<ProductPreview> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 405,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final product = products[index];

          return SizedBox(
            width: 245,
            child: ProductCard(
              name: product.name,
              imageUrl: product.imageUrl,
              price: product.price,
              originalPrice: product.originalPrice,
              discountPercentage: product.discountPercentage,
              rating: product.rating,
              reviewCount: product.reviewCount,
              onTap: () {},
              onAddToCart: () {},
            ),
          );
        },
      ),
    );
  }
}
