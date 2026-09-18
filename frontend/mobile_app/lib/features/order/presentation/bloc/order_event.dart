import 'package:equatable/equatable.dart';

import '../../../checkout/domain/entities/checkout.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class OrderCreateRequested extends OrderEvent {
  const OrderCreateRequested(this.checkout);

  final Checkout checkout;

  @override
  List<Object?> get props => [checkout];
}

final class OrdersRequested extends OrderEvent {
  const OrdersRequested();
}

final class OrderDetailsRequested extends OrderEvent {
  const OrderDetailsRequested(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}
