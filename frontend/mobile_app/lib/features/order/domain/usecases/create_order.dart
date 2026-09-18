import 'package:fpdart/fpdart.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../checkout/domain/entities/checkout.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/order_pricing.dart';
import '../entities/order_status.dart';
import '../entities/payment_status.dart';
import '../repositories/order_repository.dart';

class CreateOrder {
  const CreateOrder(this.repository);

  final OrderRepository repository;

  Future<Either<Failure, Order>> call(Checkout checkout) async {
    if (!checkout.isReadyToPlaceOrder) {
      return const Left(
        UnknownFailure('Checkout is not ready to place the order.'),
      );
    }

    final address = checkout.address;
    final paymentMethod = checkout.paymentMethod;

    if (address == null || paymentMethod == null) {
      return const Left(
        UnknownFailure('Delivery address and payment method are required.'),
      );
    }

    final order = Order(
      id: 'order-${DateTime.now().microsecondsSinceEpoch}',
      items: checkout.items
          .map(
            (item) => OrderItem(
              productId: item.productId,
              productName: item.productName,
              imageUrl: item.imageUrl,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
            ),
          )
          .toList(),
      address: address,
      pricing: OrderPricing(
        subtotal: checkout.pricing.subtotal,
        discount: checkout.pricing.discount,
        deliveryFee: checkout.pricing.deliveryFee,
        tax: checkout.pricing.tax,
        total: checkout.pricing.total,
      ),
      paymentMethod: paymentMethod,
      orderStatus: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
    );

    return repository.createOrder(order);
  }
}
