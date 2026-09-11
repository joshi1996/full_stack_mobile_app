import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../domain/entities/product.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';

class CatalogProductGrid extends StatelessWidget {
  const CatalogProductGrid({
    required this.products,
    this.isRefreshing = false,
    super.key,
  });

  final List<Product> products;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<CatalogBloc>();

        bloc.add(const CatalogRefreshed());

        await bloc.stream.firstWhere((state) => state.isRefreshing);

        await bloc.stream.firstWhere((state) => !state.isRefreshing);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final crossAxisCount = width < 600
              ? 2
              : width < 900
              ? 3
              : width < 1200
              ? 4
              : 5;

          final horizontalPadding = width < 600
              ? AppSpacing.md
              : width < 1200
              ? AppSpacing.lg
              : AppSpacing.xl;

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(horizontalPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCard(
                name: product.name,
                imageUrl: product.images.first,
                price: product.price,
                originalPrice: product.originalPrice,
                discountPercentage: product.discountPercentage,
                rating: product.rating,
                reviewCount: product.reviewCount,
                onTap: () {},
                onAddToCart: () {},
              );
            },
          );
        },
      ),
    );
  }
}
