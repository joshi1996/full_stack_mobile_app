import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../cart/domain/entities/cart.dart';
import '../entities/checkout.dart';
import '../repositories/checkout_repository.dart';

class GetCheckout {
  const GetCheckout(this.repository);

  final CheckoutRepository repository;

  Future<Either<Failure, Checkout>> call(Cart cart) {
    return repository.getCheckout(cart);
  }
}
