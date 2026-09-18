import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartStarted extends CartEvent {
  const CartStarted();
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded(this.item);

  final CartItem item;

  @override
  List<Object?> get props => [item];
}

final class CartQuantityUpdated extends CartEvent {
  const CartQuantityUpdated({required this.productId, required this.quantity});

  final String productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}

final class CartCleared extends CartEvent {
  const CartCleared();
}

final class CartRefreshed extends CartEvent {
  const CartRefreshed();
}
