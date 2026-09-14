import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_address.dart';
import 'package:go_router/go_router.dart';

import 'package:full_stack_mobile_app/core/routing/route_paths.dart';
import 'package:full_stack_mobile_app/core/theme/app_spacing.dart';
import 'package:full_stack_mobile_app/features/address/domain/entities/address.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/mappers/checkout_address_mapper.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({required this.address, super.key});

  final CheckoutAddress? address;

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select(
      (CheckoutBloc bloc) => bloc.state.selectedAddress,
    );

    final displayAddress = selectedAddress ?? address;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            if (displayAddress == null)
              const Text('No delivery address selected.')
            else ...[
              Text(
                displayAddress.label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(displayAddress.recipientName),
              Text(displayAddress.addressLine1),
              if (displayAddress.addressLine2 != null &&
                  displayAddress.addressLine2!.isNotEmpty)
                Text(displayAddress.addressLine2!),
              Text(
                '${displayAddress.city}, '
                '${displayAddress.state} - '
                '${displayAddress.postalCode}',
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(displayAddress.phone),
            ],
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () async {
                final selectedAddress = await context.push<Address>(
                  RoutePaths.addressSelection,
                );

                if (selectedAddress == null || !context.mounted) {
                  return;
                }

                context.read<CheckoutBloc>().add(
                  CheckoutAddressSelected(toCheckoutAddress(selectedAddress)),
                );
              },
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Change Address'),
            ),
          ],
        ),
      ),
    );
  }
}
