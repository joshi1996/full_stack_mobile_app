import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/address.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import '../widgets/add_address_button.dart';
import '../widgets/address_card.dart';
import '../widgets/address_empty_view.dart';

class AddressSelectionPage extends StatelessWidget {
  const AddressSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddressBloc>()..add(const AddressStarted()),
      child: const _AddressSelectionView(),
    );
  }
}

class _AddressSelectionView extends StatelessWidget {
  const _AddressSelectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Delivery Address')),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state.status == AddressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AddressStatus.failure) {
            return _AddressErrorView(
              message: state.errorMessage ?? 'Unable to load addresses.',
              onRetry: () {
                context.read<AddressBloc>().add(const AddressStarted());
              },
            );
          }

          if (state.addresses.isEmpty) {
            return AddressEmptyView(
              onAddAddress: () => _openAddAddress(context),
            );
          }

          return _AddressListContent(state: state);
        },
      ),
    );
  }

  Future<void> _openAddAddress(BuildContext context) async {
    final address = await context.push<Address>(
      RoutePaths.addAddress,
      extra: context.read<AddressBloc>(),
    );

    if (address == null || !context.mounted) {
      return;
    }

    context.pop(address);
  }
}

class _AddressListContent extends StatelessWidget {
  const _AddressListContent({required this.state});

  final AddressState state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AddressBloc>().add(const AddressRefreshed());

        await context.read<AddressBloc>().stream.firstWhere(
          (state) => !state.isRefreshing,
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Saved Addresses', style: AppTextStyles.headingMedium),
          const SizedBox(height: AppSpacing.md),

          ...state.addresses.map(
            (address) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AddressCard(
                address: address,
                isSelected: state.selectedAddress?.id == address.id,
                onTap: () {
                  context.read<AddressBloc>().add(AddressSelected(address));
                },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          AddAddressButton(onPressed: () => _openAddAddress(context)),

          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.selectedAddress == null
                  ? null
                  : () {
                      context.pop(state.selectedAddress);
                    },
              child: const Text('Deliver to this Address'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddAddress(BuildContext context) async {
    final address = await context.push<Address>(
      RoutePaths.addAddress,
      extra: context.read<AddressBloc>(),
    );

    if (address == null || !context.mounted) {
      return;
    }

    context.pop(address);
  }
}

class _AddressErrorView extends StatelessWidget {
  const _AddressErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
