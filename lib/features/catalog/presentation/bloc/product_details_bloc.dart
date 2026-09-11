import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/catalog_repository.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc(this.repository) : super(const ProductDetailsState()) {
    on<ProductDetailsStarted>(_onProductDetailsStarted);
  }

  final CatalogRepository repository;

  Future<void> _onProductDetailsStarted(
    ProductDetailsStarted event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(status: ProductDetailsStatus.loading, errorMessage: null),
    );

    final result = await repository.getProductById(event.productId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (product) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
