import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/payment_method.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_event.dart';

class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({required this.paymentMethod, super.key});

  final PaymentMethod? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            if (paymentMethod == null)
              _PaymentSelectionPrompt(onTap: () => _showPaymentMethods(context))
            else
              _SelectedPaymentMethod(
                paymentMethod: paymentMethod!,
                onChange: () => _showPaymentMethods(context),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentMethods(BuildContext context) async {
    final selectedMethod = await showModalBottomSheet<PaymentMethod>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return _PaymentMethodSelector(selectedMethod: paymentMethod);
      },
    );

    if (selectedMethod == null || !context.mounted) {
      return;
    }

    context.read<CheckoutBloc>().add(
      CheckoutPaymentMethodSelected(selectedMethod),
    );
  }
}

class _PaymentSelectionPrompt extends StatelessWidget {
  const _PaymentSelectionPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.payment_outlined),
      title: const Text('Select Payment Method'),
      subtitle: const Text('Choose how you want to pay for this order.'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _SelectedPaymentMethod extends StatelessWidget {
  const _SelectedPaymentMethod({
    required this.paymentMethod,
    required this.onChange,
  });

  final PaymentMethod paymentMethod;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_paymentIcon(paymentMethod)),
      title: Text(_paymentLabel(paymentMethod)),
      subtitle: Text(_paymentDescription(paymentMethod)),
      trailing: TextButton(onPressed: onChange, child: const Text('Change')),
    );
  }

  IconData _paymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return Icons.money_outlined;
      case PaymentMethod.upi:
        return Icons.account_balance_wallet_outlined;
      case PaymentMethod.card:
        return Icons.credit_card_outlined;
    }
  }

  String _paymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.card:
        return 'Card';
    }
  }

  String _paymentDescription(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Pay when your order is delivered.';
      case PaymentMethod.upi:
        return 'Pay securely using UPI.';
      case PaymentMethod.card:
        return 'Pay using your debit or credit card.';
    }
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({required this.selectedMethod});

  final PaymentMethod? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            _PaymentMethodTile(
              method: PaymentMethod.upi,
              selectedMethod: selectedMethod,
            ),
            _PaymentMethodTile(
              method: PaymentMethod.card,
              selectedMethod: selectedMethod,
            ),
            _PaymentMethodTile(
              method: PaymentMethod.cashOnDelivery,
              selectedMethod: selectedMethod,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selectedMethod,
  });

  final PaymentMethod method;
  final PaymentMethod? selectedMethod;

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selectedMethod;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_icon),
      title: Text(_label),
      subtitle: Text(_description),
      trailing: Radio<PaymentMethod>(value: method),
      selected: isSelected,
      onTap: () {
        Navigator.of(context).pop(method);
      },
    );
  }

  IconData get _icon {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return Icons.money_outlined;
      case PaymentMethod.upi:
        return Icons.account_balance_wallet_outlined;
      case PaymentMethod.card:
        return Icons.credit_card_outlined;
    }
  }

  String get _label {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.card:
        return 'Credit / Debit Card';
    }
  }

  String get _description {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Pay when your order arrives.';
      case PaymentMethod.upi:
        return 'Google Pay, PhonePe, Paytm and other UPI apps.';
      case PaymentMethod.card:
        return 'Visa, Mastercard and other supported cards.';
    }
  }
}
