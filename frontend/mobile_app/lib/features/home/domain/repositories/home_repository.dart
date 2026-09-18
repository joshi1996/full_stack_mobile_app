import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/home_configuration.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeConfiguration>> getHomeConfiguration();
}
