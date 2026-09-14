import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this.dataSource);

  final CartDataSource dataSource;

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final cart = await dataSource.getCart();

      return Right(cart);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Cart>> addItem(CartItem item) async {
    try {
      final cart = await dataSource.addItem(item);

      return Right(cart);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    try {
      final cart = await dataSource.updateQuantity(
        productId: productId,
        quantity: quantity,
      );

      return Right(cart);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeItem(String productId) async {
    try {
      final cart = await dataSource.removeItem(productId);

      return Right(cart);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    try {
      final cart = await dataSource.clearCart();

      return Right(cart);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
