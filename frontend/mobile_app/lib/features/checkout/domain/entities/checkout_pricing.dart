import 'package:equatable/equatable.dart';

class CheckoutPricing extends Equatable {
  const CheckoutPricing({
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.tax,
  });

  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;

  double get total => subtotal - discount + deliveryFee + tax;

  @override
  List<Object?> get props => [subtotal, discount, deliveryFee, tax];
}
