import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/address/domain/entities/address.dart';
import 'package:go_router/go_router.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import '../widgets/address_form.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.status == AddressStatus.added) {
          final address = state.selectedAddress;

          if (address != null) {
            context.pop(address);
          }
        }

        if (state.status == AddressStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to save address.'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Address')),
          body: AddressForm(
            isSubmitting: state.status == AddressStatus.adding,
            onSubmit: (formData) {
              final address = Address(
                id: 'address-${DateTime.now().microsecondsSinceEpoch}',
                label: formData.label,
                fullName: formData.recipientName,
                addressLine1: formData.addressLine1,
                addressLine2: formData.addressLine2,
                city: formData.city,
                state: formData.state,
                postalCode: formData.postalCode,
                phoneNumber: formData.phone,
              );

              context.read<AddressBloc>().add(AddressAddRequested(address));
            },
          ),
        );
      },
    );
  }
}
