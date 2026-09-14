import 'package:equatable/equatable.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_operation_status.dart';

import '../../domain/entities/order.dart';

enum OrderStatus { initial, creating, created, loading, loaded, failure }

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderOperationStatus.initial,
    this.order,
    this.orders = const [],
    this.errorMessage,
  });

  final OrderOperationStatus status;
  final Order? order;
  final List<Order> orders;
  final String? errorMessage;

  OrderState copyWith({
    OrderOperationStatus? status,
    Order? order,
    List<Order>? orders,
    String? errorMessage,
    bool clearOrder = false,
    bool clearErrorMessage = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: clearOrder ? null : order ?? this.order,
      orders: orders ?? this.orders,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, orders, errorMessage];
}
