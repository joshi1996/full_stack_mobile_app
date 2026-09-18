import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_status.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () {
          context.pushNamed(
            RouteNames.orderDetails,
            pathParameters: {'orderId': order.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderHeader(order: order),
              const SizedBox(height: AppSpacing.md),
              _OrderSummary(order: order),
              const SizedBox(height: AppSpacing.md),
              _OrderFooter(order: order),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _formatDate(order.createdAt),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        _OrderStatusBadge(status: order.orderStatus),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.shopping_bag_outlined),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            '${order.items.length} '
            '${order.items.length == 1 ? 'item' : 'items'}',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        Text(
          '₹${order.pricing.total.toStringAsFixed(2)}',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _OrderFooter extends StatelessWidget {
  const _OrderFooter({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_paymentIcon(order.paymentMethod.name), size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            _paymentLabel(order.paymentMethod.name),
            style: AppTextStyles.bodyMedium,
          ),
        ),
        Text(
          _paymentStatusLabel(order.paymentStatus),
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  IconData _paymentIcon(String method) {
    switch (method) {
      case 'upi':
        return Icons.account_balance_outlined;
      case 'card':
        return Icons.credit_card_outlined;
      case 'cashOnDelivery':
        return Icons.money_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  String _paymentLabel(String method) {
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
        return 'Payment Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}

class _OrderStatusBadge extends StatelessWidget {
  const _OrderStatusBadge({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: _backgroundColor(status),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          _label(status),
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Color _backgroundColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.shade100;
      case OrderStatus.confirmed:
        return Colors.blue.shade100;
      case OrderStatus.processing:
        return Colors.indigo.shade100;
      case OrderStatus.shipped:
        return Colors.purple.shade100;
      case OrderStatus.delivered:
        return Colors.green.shade100;
      case OrderStatus.cancelled:
        return Colors.red.shade100;
    }
  }

  String _label(OrderStatus status) {
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
