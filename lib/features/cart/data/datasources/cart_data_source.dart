import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

abstract interface class CartDataSource {
  Future<Cart> getCart();

  Future<Cart> addItem(CartItem item);

  Future<Cart> updateQuantity({
    required String productId,
    required int quantity,
  });

  Future<Cart> removeItem(String productId);

  Future<Cart> clearCart();
}

class CartDataSourceImpl implements CartDataSource {
  CartDataSourceImpl();

  Cart _cart = const Cart();

  @override
  Future<Cart> getCart() async {
    return _cart;
  }

  @override
  Future<Cart> addItem(CartItem item) async {
    final existingIndex = _cart.items.indexWhere(
      (cartItem) => cartItem.productId == item.productId,
    );

    if (existingIndex == -1) {
      _cart = _cart.copyWith(items: [..._cart.items, item]);

      return _cart;
    }

    final existingItem = _cart.items[existingIndex];

    final updatedItem = existingItem.copyWith(
      quantity: existingItem.quantity + item.quantity,
    );

    final updatedItems = [..._cart.items];

    updatedItems[existingIndex] = updatedItem;

    _cart = _cart.copyWith(items: updatedItems);

    return _cart;
  }

  @override
  Future<Cart> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final index = _cart.items.indexWhere((item) => item.productId == productId);

    if (index == -1) {
      throw Exception('Cart item not found');
    }

    if (quantity <= 0) {
      return removeItem(productId);
    }

    final updatedItems = [..._cart.items];

    updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);

    _cart = _cart.copyWith(items: updatedItems);

    return _cart;
  }

  @override
  Future<Cart> removeItem(String productId) async {
    final updatedItems = _cart.items
        .where((item) => item.productId != productId)
        .toList();

    _cart = _cart.copyWith(items: updatedItems);

    return _cart;
  }

  @override
  Future<Cart> clearCart() async {
    _cart = const Cart();

    return _cart;
  }
}
