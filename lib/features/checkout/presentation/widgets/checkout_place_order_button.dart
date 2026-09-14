import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:full_stack_mobile_app/core/theme/app_dimensions.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_state.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  const CheckoutPlaceOrderButton({required this.checkout, super.key});

  final Checkout checkout;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        final isAddressSelected = state.selectedAddress != null;
        final isPaymentSelected = state.selectedPaymentMethod != null;

        final isReady = isAddressSelected && isPaymentSelected;

        return SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: FilledButton(
            onPressed: isReady
                ? () => _placeOrder(context)
                : () => _validateCheckout(
                    context,
                    isAddressSelected: isAddressSelected,
                    isPaymentSelected: isPaymentSelected,
                  ),
            child: Text(
              isReady
                  ? 'Place Order • ₹${checkout.pricing.total.toStringAsFixed(2)}'
                  : 'Complete Checkout',
            ),
          ),
        );
      },
    );
  }

  void _validateCheckout(
    BuildContext context, {
    required bool isAddressSelected,
    required bool isPaymentSelected,
  }) {
    if (!isAddressSelected) {
      _showMessage(context, 'Please select a delivery address.');
      return;
    }

    if (!isPaymentSelected) {
      _showMessage(context, 'Please select a payment method.');
    }
  }

  void _placeOrder(BuildContext context) {
    _showMessage(context, 'Order creation will be implemented next.');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
