import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';

import '../../domain/entities/home_configuration.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.dataSource);

  final HomeDataSource dataSource;

  @override
  Future<Either<Failure, HomeConfiguration>> getHomeConfiguration() async {
    try {
      final configuration = await dataSource.getHomeConfiguration();

      return Right(configuration);
    } catch (exception) {
      return Left(FailureMapper.fromException(exception));
    }
  }
}
