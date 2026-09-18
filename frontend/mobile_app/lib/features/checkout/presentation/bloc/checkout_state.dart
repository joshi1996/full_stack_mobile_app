import 'package:equatable/equatable.dart';

import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_address.dart';

import '../../domain/entities/checkout.dart';
import '../../domain/entities/payment_method.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.checkout,
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final Checkout? checkout;
  final CheckoutAddress? selectedAddress;
  final PaymentMethod? selectedPaymentMethod;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    Checkout? checkout,
    CheckoutAddress? selectedAddress,
    PaymentMethod? selectedPaymentMethod,
    String? errorMessage,
    bool clearCheckout = false,
    bool clearErrorMessage = false,
    bool clearPaymentMethod = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      checkout: clearCheckout ? null : checkout ?? this.checkout,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: clearPaymentMethod
          ? null
          : selectedPaymentMethod ?? this.selectedPaymentMethod,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    checkout,
    selectedAddress,
    selectedPaymentMethod,
    errorMessage,
  ];
}
