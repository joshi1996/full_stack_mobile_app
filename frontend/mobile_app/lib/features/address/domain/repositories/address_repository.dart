import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/address.dart';

abstract interface class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();

  Future<Either<Failure, Address>> getDefaultAddress();

  Future<Either<Failure, Address>> addAddress(Address address);
}
