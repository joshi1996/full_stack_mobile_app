import 'package:equatable/equatable.dart';

class OrderPricing extends Equatable {
  const OrderPricing({
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.tax,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double total;

  @override
  List<Object?> get props => [subtotal, discount, deliveryFee, tax, total];
}
