import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:full_stack_mobile_app/core/theme/app_dimensions.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_event.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_operation_status.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_state.dart';

class CheckoutPlaceOrderButton extends StatelessWidget {
  const CheckoutPlaceOrderButton({required this.checkout, super.key});

  final Checkout checkout;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, checkoutState) {
        final isAddressSelected = checkoutState.selectedAddress != null;
        final isPaymentSelected = checkoutState.selectedPaymentMethod != null;

        final isReady = isAddressSelected && isPaymentSelected;

        return BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            final isCreatingOrder =
                orderState.status == OrderOperationStatus.creating;

            return SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: FilledButton(
                onPressed: isCreatingOrder
                    ? null
                    : isReady
                    ? () => _placeOrder(context)
                    : () => _validateCheckout(
                        context,
                        isAddressSelected: isAddressSelected,
                        isPaymentSelected: isPaymentSelected,
                      ),
                child: isCreatingOrder
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isReady
                            ? 'Place Order • ₹${checkout.pricing.total.toStringAsFixed(2)}'
                            : 'Complete Checkout',
                      ),
              ),
            );
          },
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
    context.read<OrderBloc>().add(OrderCreateRequested(checkout));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
