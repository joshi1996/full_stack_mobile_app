import 'package:equatable/equatable.dart';

import '../../../checkout/domain/entities/checkout_address.dart';
import '../../../checkout/domain/entities/payment_method.dart';
import 'order_item.dart';
import 'order_pricing.dart';
import 'order_status.dart';
import 'payment_status.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.address,
    required this.pricing,
    required this.paymentMethod,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  final String id;
  final List<OrderItem> items;
  final CheckoutAddress address;
  final OrderPricing pricing;
  final PaymentMethod paymentMethod;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    items,
    address,
    pricing,
    paymentMethod,
    orderStatus,
    paymentStatus,
    createdAt,
  ];
}
