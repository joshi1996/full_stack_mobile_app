import '../../domain/entities/order.dart';

abstract interface class OrderDataSource {
  Future<Order> createOrder(Order order);

  Future<List<Order>> getOrders();

  Future<Order> getOrderById(String orderId);
}

class OrderDataSourceImpl implements OrderDataSource {
  OrderDataSourceImpl();

  final List<Order> _orders = [];

  @override
  Future<Order> createOrder(Order order) async {
    _orders.add(order);
    return order;
  }

  @override
  Future<List<Order>> getOrders() async {
    return List.unmodifiable(_orders);
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    return _orders.firstWhere(
      (order) => order.id == orderId,
      orElse: () => throw StateError('Order not found: $orderId'),
    );
  }
}
