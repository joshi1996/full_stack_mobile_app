import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/widgets/product_details_content.dart';

import '../../../../core/di/injection.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_event.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductDetailsBloc>()..add(ProductDetailsStarted(productId)),
      child: const ProductDetailsContent(),
    );
  }
}
