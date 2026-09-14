import 'package:equatable/equatable.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_address.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/payment_method.dart';

import '../../../cart/domain/entities/cart.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

final class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted(this.cart);

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}

final class CheckoutAddressSelected extends CheckoutEvent {
  const CheckoutAddressSelected(this.address);

  final CheckoutAddress address;

  @override
  List<Object?> get props => [address];
}

final class CheckoutPaymentMethodSelected extends CheckoutEvent {
  const CheckoutPaymentMethodSelected(this.paymentMethod);

  final PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];
}
