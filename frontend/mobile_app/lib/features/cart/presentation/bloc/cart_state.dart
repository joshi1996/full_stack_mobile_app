import 'package:equatable/equatable.dart';

import '../../domain/entities/cart.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.errorMessage,
    this.isRefreshing = false,
    this.isUpdating = false,
  });

  final CartStatus status;
  final Cart cart;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isUpdating;

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isRefreshing,
    bool? isUpdating,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cart,
    errorMessage,
    isRefreshing,
    isUpdating,
  ];
}
