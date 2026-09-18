import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_status.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_operation_status.dart';
import '../bloc/order_state.dart' hide OrderStatus;

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderBloc>()..add(OrderDetailsRequested(orderId)),
      child: _OrderDetailsView(orderId: orderId),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          switch (state.status) {
            case OrderOperationStatus.initial:
            case OrderOperationStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case OrderOperationStatus.failure:
              return _OrderDetailsErrorView(
                message: state.errorMessage ?? 'Unable to load order details.',
                onRetry: () {
                  context.read<OrderBloc>().add(OrderDetailsRequested(orderId));
                },
              );

            case OrderOperationStatus.creating:
              return const Center(child: CircularProgressIndicator());

            case OrderOperationStatus.created:
            case OrderOperationStatus.loaded:
              final order = state.order;

              if (order == null) {
                return const Center(child: Text('Order details unavailable.'));
              }

              return _OrderDetailsContent(order: order);
          }
        },
      ),
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  const _OrderDetailsContent({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _OrderOverviewCard(order: order),
            const SizedBox(height: AppSpacing.md),
            _OrderStatusCard(order: order),
            const SizedBox(height: AppSpacing.md),
            _OrderItemsCard(order: order),
            const SizedBox(height: AppSpacing.md),
            _OrderAddressCard(order: order),
            const SizedBox(height: AppSpacing.md),
            _OrderPaymentCard(order: order),
            const SizedBox(height: AppSpacing.md),
            _OrderPricingCard(order: order),
          ],
        );

        if (constraints.maxWidth < 900) {
          return content;
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: content,
          ),
        );
      },
    );
  }
}

class _OrderOverviewCard extends StatelessWidget {
  const _OrderOverviewCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.id}', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Placed on ${_formatDate(order.createdAt)}',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Status', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _orderStatusLabel(order.orderStatus),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _orderStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Items', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Qty: ${item.quantity}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '₹${item.unitPrice.toStringAsFixed(2)} each',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item.totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderAddressCard extends StatelessWidget {
  const _OrderAddressCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final address = order.address;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            Text(
              address.recipientName,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(address.addressLine1, style: AppTextStyles.bodyMedium),
            if (address.addressLine2 != null &&
                address.addressLine2!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(address.addressLine2!, style: AppTextStyles.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${address.city}, ${address.state} '
              '${address.postalCode}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(address.phone, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _OrderPaymentCard extends StatelessWidget {
  const _OrderPaymentCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.payment_outlined),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _paymentMethodLabel(order.paymentMethod.name),
                  style: AppTextStyles.bodyLarge,
                ),
                const Spacer(),
                Text(
                  _paymentStatusLabel(order.paymentStatus),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _paymentMethodLabel(String method) {
    switch (method) {
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Card';
      case 'cashOnDelivery':
        return 'Cash on Delivery';
      default:
        return 'Payment';
    }
  }

  String _paymentStatusLabel(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}

class _OrderPricingCard extends StatelessWidget {
  const _OrderPricingCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final pricing = order.pricing;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Details', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            _PriceRow(label: 'Subtotal', value: pricing.subtotal),
            _PriceRow(label: 'Discount', value: -pricing.discount),
            _PriceRow(label: 'Delivery Fee', value: pricing.deliveryFee),
            _PriceRow(label: 'Tax', value: pricing.tax),
            const Divider(),
            _PriceRow(label: 'Total', value: pricing.total, isTotal: true),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    )
                  : AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsErrorView extends StatelessWidget {
  const _OrderDetailsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
