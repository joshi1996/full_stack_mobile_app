import 'package:equatable/equatable.dart';

import 'checkout_address.dart';
import 'checkout_item.dart';
import 'checkout_pricing.dart';
import 'payment_method.dart';

class Checkout extends Equatable {
  const Checkout({
    required this.items,
    required this.pricing,
    this.address,
    this.paymentMethod,
  });

  final List<CheckoutItem> items;
  final CheckoutPricing pricing;
  final CheckoutAddress? address;
  final PaymentMethod? paymentMethod;

  bool get isReadyToPlaceOrder =>
      items.isNotEmpty && address != null && paymentMethod != null;

  Checkout copyWith({
    List<CheckoutItem>? items,
    CheckoutPricing? pricing,
    CheckoutAddress? address,
    PaymentMethod? paymentMethod,
  }) {
    return Checkout(
      items: items ?? this.items,
      pricing: pricing ?? this.pricing,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [items, pricing, address, paymentMethod];
}
