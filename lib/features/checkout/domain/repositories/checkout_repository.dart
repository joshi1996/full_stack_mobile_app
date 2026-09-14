import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../cart/domain/entities/cart.dart';
import '../entities/checkout.dart';

abstract interface class CheckoutRepository {
  Future<Either<Failure, Checkout>> getCheckout(Cart cart);
}
