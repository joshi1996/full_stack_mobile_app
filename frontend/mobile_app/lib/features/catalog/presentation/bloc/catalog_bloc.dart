import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/catalog_repository.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc(this.repository) : super(const CatalogState()) {
    on<CatalogStarted>(_onCatalogStarted);
    on<CatalogRefreshed>(_onCatalogRefreshed);
  }

  final CatalogRepository repository;

  Future<void> _onCatalogStarted(
    CatalogStarted event,
    Emitter<CatalogState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        isRefreshing: false,
        errorMessage: null,
      ),
    );

    final result = await repository.getProducts();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CatalogStatus.failure,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (products) {
        final filteredProducts = state.categoryId == null
            ? products
            : products
                  .where((product) => product.categoryId == state.categoryId)
                  .toList();

        emit(
          state.copyWith(
            status: CatalogStatus.success,
            products: filteredProducts,
            categoryId: event.categoryId,
            isRefreshing: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onCatalogRefreshed(
    CatalogRefreshed event,
    Emitter<CatalogState> emit,
  ) async {
    if (state.products.isEmpty) {
      add(CatalogStarted(categoryId: state.categoryId));
      return;
    }

    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    final result = await repository.getProducts();

    result.fold(
      (failure) {
        emit(
          state.copyWith(isRefreshing: false, errorMessage: failure.message),
        );
      },
      (products) {
        final filteredProducts = state.categoryId == null
            ? products
            : products
                  .where((product) => product.categoryId == state.categoryId)
                  .toList();

        emit(
          state.copyWith(
            status: CatalogStatus.success,
            products: filteredProducts,
            isRefreshing: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
