import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/domain/entities/product.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/widgets/product_gallery.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/widgets/product_information.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_state.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductDetailsStatus.initial:
          case ProductDetailsStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case ProductDetailsStatus.failure:
            return _ProductDetailsError(
              message: state.errorMessage,
              onRetry: () {
                // Retry will be connected in the next refinement.
              },
            );

          case ProductDetailsStatus.success:
            final product = state.product;

            if (product == null) {
              return const Scaffold(
                body: Center(child: Text('Product not found')),
              );
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Product Details')),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;

                  if (isDesktop) {
                    return _DesktopProductDetails(product: product);
                  }

                  return _MobileProductDetails(product: product);
                },
              ),
            );
        }
      },
    );
  }
}

class _DesktopProductDetails extends StatelessWidget {
  const _DesktopProductDetails({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: ProductGallery(
              images: product.images,
              productName: product.name,
            ),
          ),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(
            flex: 5,
            child: ProductInformation(
              product: product,
              onAddToCart: () => _addToCart(context),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(
      CartItemAdded(
        CartItem(
          productId: product.id,
          productName: product.name,
          imageUrl: product.images.isNotEmpty ? product.images.first : '',
          unitPrice: product.price,
          quantity: 1,
        ),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to cart')));
  }
}

class _MobileProductDetails extends StatelessWidget {
  const _MobileProductDetails({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductGallery(images: product.images, productName: product.name),
          const SizedBox(height: AppSpacing.xl),
          ProductInformation(
            product: product,
            onAddToCart: () => _addToCart(context),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(
      CartItemAdded(
        CartItem(
          productId: product.id,
          productName: product.name,
          imageUrl: product.images.isNotEmpty ? product.images.first : '',
          unitPrice: product.price,
          quantity: 1,
        ),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to cart')));
  }
}

class _ProductDetailsError extends StatelessWidget {
  const _ProductDetailsError({required this.onRetry, this.message});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Unable to load product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(message ?? 'Please try again.', textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
