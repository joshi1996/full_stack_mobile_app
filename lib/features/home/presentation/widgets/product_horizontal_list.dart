import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../domain/entities/product_preview.dart';

class ProductHorizontalList extends StatelessWidget {
  const ProductHorizontalList({required this.products, super.key});

  final List<ProductPreview> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = _getCardWidth(constraints.maxWidth);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < products.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    right: index == products.length - 1 ? 0 : AppSpacing.md,
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: ProductCard(
                      name: products[index].name,
                      imageUrl: products[index].imageUrl,
                      price: products[index].price,
                      originalPrice: products[index].originalPrice,
                      discountPercentage: products[index].discountPercentage,
                      rating: products[index].rating,
                      reviewCount: products[index].reviewCount,
                      onTap: () {
                        context.pushNamed(
                          RouteNames.productDetails,
                          pathParameters: {'productId': products[index].id},
                        );
                      },
                      onAddToCart: () {},
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  double _getCardWidth(double availableWidth) {
    if (availableWidth < AppBreakpoints.mobile) {
      return availableWidth * 0.72;
    }

    if (availableWidth < AppBreakpoints.tablet) {
      return availableWidth * 0.42;
    }

    return availableWidth * 0.28;
  }
}
