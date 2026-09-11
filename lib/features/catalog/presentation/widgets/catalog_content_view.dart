import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_event.dart';

import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_state.dart';
import 'catalog_empty_view.dart';
import 'catalog_error_view.dart';
import 'catalog_product_grid.dart';
import 'catalog_skeleton.dart';

class CatalogContentView extends StatelessWidget {
  const CatalogContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        switch (state.status) {
          case CatalogStatus.initial:
          case CatalogStatus.loading:
            return const CatalogSkeleton();

          case CatalogStatus.failure:
            return CatalogErrorView(
              message: state.errorMessage,
              onRetry: () {
                context.read<CatalogBloc>().add(const CatalogStarted());
              },
            );

          case CatalogStatus.success:
            if (state.products.isEmpty) {
              return const CatalogEmptyView();
            }

            return CatalogProductGrid(
              products: state.products,
              isRefreshing: state.isRefreshing,
            );
        }
      },
    );
  }
}
