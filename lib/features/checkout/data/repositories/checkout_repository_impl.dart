import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../domain/entities/checkout.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_data_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this.dataSource);

  final CheckoutDataSource dataSource;

  @override
  Future<Either<Failure, Checkout>> getCheckout(Cart cart) async {
    try {
      final checkout = await dataSource.getCheckout(cart);

      return Right(checkout);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
