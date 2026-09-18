import '../../../cart/domain/entities/cart.dart';
import '../../domain/entities/checkout.dart';
import '../../domain/entities/checkout_item.dart';
import '../../domain/entities/checkout_pricing.dart';

abstract interface class CheckoutDataSource {
  Future<Checkout> getCheckout(Cart cart);
}

class CheckoutDataSourceImpl implements CheckoutDataSource {
  const CheckoutDataSourceImpl();

  @override
  Future<Checkout> getCheckout(Cart cart) async {
    final items = cart.items
        .map(
          (item) => CheckoutItem(
            productId: item.productId,
            productName: item.productName,
            imageUrl: item.imageUrl,
            unitPrice: item.unitPrice,
            quantity: item.quantity,
          ),
        )
        .toList(growable: false);

    final pricing = CheckoutPricing(
      subtotal: cart.subtotal,
      discount: 0,
      deliveryFee: 0,
      tax: 0,
    );

    return Checkout(items: items, pricing: pricing);
  }
}
