import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';
import 'package:full_stack_mobile_app/features/catalog/domain/entities/product.dart';
import 'package:full_stack_mobile_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_state.dart';

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository(this.result);

  final Either<Failure, List<Product>> result;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    return result;
  }

  @override
  Future<Either<Failure, Product>> getProductById(String productId) async {
    throw UnimplementedError();
  }
}

const products = [
  Product(
    id: 'product-1',
    name: 'Test Product',
    description: 'Test product description',
    brand: 'Test Brand',
    categoryId: 'electronics',
    images: ['https://example.com/product.jpg'],
    price: 999,
    originalPrice: 1299,
    discountPercentage: 23,
    rating: 4.5,
    reviewCount: 100,
  ),
];

void main() {
  group('CatalogBloc', () {
    blocTest<CatalogBloc, CatalogState>(
      'emits loading then success when products load successfully',
      build: () => CatalogBloc(FakeCatalogRepository(const Right(products))),
      act: (bloc) => bloc.add(const CatalogStarted()),
      expect: () => [
        const CatalogState(status: CatalogStatus.loading),
        const CatalogState(status: CatalogStatus.success, products: products),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'emits loading then failure when products fail to load',
      build: () => CatalogBloc(
        FakeCatalogRepository(
          Left(FailureMapper.fromException(Exception('Catalog failed'))),
        ),
      ),
      act: (bloc) => bloc.add(const CatalogStarted()),
      expect: () => [
        const CatalogState(status: CatalogStatus.loading),
        isA<CatalogState>()
            .having((state) => state.status, 'status', CatalogStatus.failure)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Exception: Catalog failed',
            ),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'emits refreshing then success when refresh succeeds',
      build: () => CatalogBloc(FakeCatalogRepository(const Right(products))),
      seed: () =>
          const CatalogState(status: CatalogStatus.success, products: products),
      act: (bloc) => bloc.add(const CatalogRefreshed()),
      expect: () => [
        const CatalogState(
          status: CatalogStatus.success,
          products: products,
          isRefreshing: true,
        ),
        const CatalogState(
          status: CatalogStatus.success,
          products: products,
          isRefreshing: false,
        ),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'preserves existing products when refresh fails',
      build: () => CatalogBloc(
        FakeCatalogRepository(
          Left(FailureMapper.fromException(Exception('Refresh failed'))),
        ),
      ),
      seed: () =>
          const CatalogState(status: CatalogStatus.success, products: products),
      act: (bloc) => bloc.add(const CatalogRefreshed()),
      expect: () => [
        const CatalogState(
          status: CatalogStatus.success,
          products: products,
          isRefreshing: true,
        ),
        isA<CatalogState>()
            .having((state) => state.status, 'status', CatalogStatus.success)
            .having((state) => state.products, 'products', products)
            .having((state) => state.isRefreshing, 'isRefreshing', false)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Exception: Refresh failed',
            ),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'loads products normally when refresh is triggered without products',
      build: () => CatalogBloc(FakeCatalogRepository(const Right(products))),
      act: (bloc) => bloc.add(const CatalogRefreshed()),
      expect: () => [
        const CatalogState(status: CatalogStatus.loading),
        const CatalogState(status: CatalogStatus.success, products: products),
      ],
    );
  });
}
