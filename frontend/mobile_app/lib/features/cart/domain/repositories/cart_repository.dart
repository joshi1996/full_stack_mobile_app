import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';

abstract interface class CartRepository {
  Future<Either<Failure, Cart>> getCart();

  Future<Either<Failure, Cart>> addItem(CartItem item);

  Future<Either<Failure, Cart>> updateQuantity({
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, Cart>> removeItem(String productId);

  Future<Either<Failure, Cart>> clearCart();
}
