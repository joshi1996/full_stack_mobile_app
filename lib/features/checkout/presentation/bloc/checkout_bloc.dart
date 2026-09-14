import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_checkout.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc(this.getCheckout) : super(const CheckoutState()) {
    on<CheckoutStarted>(_onCheckoutStarted);
    on<CheckoutAddressSelected>(_onAddressSelected);
    on<CheckoutPaymentMethodSelected>(_onPaymentMethodSelected);
  }

  final GetCheckout getCheckout;

  Future<void> _onCheckoutStarted(
    CheckoutStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(status: CheckoutStatus.loading, clearErrorMessage: true),
    );

    final result = await getCheckout(event.cart);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (checkout) {
        emit(
          state.copyWith(
            status: CheckoutStatus.success,
            checkout: checkout,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void _onAddressSelected(
    CheckoutAddressSelected event,
    Emitter<CheckoutState> emit,
  ) {
    final checkout = state.checkout;

    emit(
      state.copyWith(
        selectedAddress: event.address,
        checkout: checkout?.copyWith(address: event.address),
      ),
    );
  }

  void _onPaymentMethodSelected(
    CheckoutPaymentMethodSelected event,
    Emitter<CheckoutState> emit,
  ) {
    final checkout = state.checkout;

    emit(
      state.copyWith(
        selectedPaymentMethod: event.paymentMethod,
        checkout: checkout?.copyWith(paymentMethod: event.paymentMethod),
      ),
    );
  }
}
