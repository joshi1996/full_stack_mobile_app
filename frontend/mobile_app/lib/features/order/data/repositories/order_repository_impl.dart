import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.dataSource);

  final OrderDataSource dataSource;

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      final createdOrder = await dataSource.createOrder(order);

      return Right(createdOrder);
    } catch (exception) {
      return Left(UnknownFailure('Unable to create order: $exception'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await dataSource.getOrders();

      return Right(orders);
    } catch (exception) {
      return Left(UnknownFailure('Unable to load orders: $exception'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final order = await dataSource.getOrderById(orderId);

      return Right(order);
    } catch (exception) {
      return Left(UnknownFailure('Unable to load order: $exception'));
    }
  }
}
