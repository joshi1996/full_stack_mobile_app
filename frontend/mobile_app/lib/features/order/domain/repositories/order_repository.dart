import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../entities/order.dart';

abstract interface class OrderRepository {
  Future<Either<Failure, Order>> createOrder(Order order);

  Future<Either<Failure, List<Order>>> getOrders();

  Future<Either<Failure, Order>> getOrderById(String orderId);
}
