import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_data_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl(this.dataSource);

  final AddressDataSource dataSource;

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final addresses = await dataSource.getAddresses();
      return Right(addresses);
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> getDefaultAddress() async {
    try {
      final address = await dataSource.getDefaultAddress();

      if (address == null) {
        return Left(UnknownFailure('No default address found.'));
      }

      return Right(address);
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final savedAddress = await dataSource.addAddress(address);
      return Right(savedAddress);
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }
}
