import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this.dataSource);

  final CatalogDataSource dataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await dataSource.getProducts();

      return Right(products);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String productId) async {
    try {
      final product = await dataSource.getProductById(productId);

      return Right(product);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
