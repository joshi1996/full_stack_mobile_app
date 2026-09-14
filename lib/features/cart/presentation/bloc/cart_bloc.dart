import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.repository) : super(const CartState()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartQuantityUpdated>(_onCartQuantityUpdated);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartCleared>(_onCartCleared);
    on<CartRefreshed>(_onCartRefreshed);
  }

  final CartRepository repository;

  Future<void> _onCartStarted(
    CartStarted event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading, clearErrorMessage: true));

    final result = await repository.getCart();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
      'CART: adding ${event.item.productId} - ${event.item.productName}',
    );

    emit(state.copyWith(isUpdating: true, clearErrorMessage: true));

    final result = await repository.addItem(event.item);

    result.fold(
      (failure) {
        debugPrint('CART: ADD FAILED -> ${failure.message}');

        emit(state.copyWith(isUpdating: false, errorMessage: failure.message));
      },
      (cart) {
        debugPrint('CART: items after add = ${cart.items.length}');

        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            isUpdating: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onCartQuantityUpdated(
    CartQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, clearErrorMessage: true));

    final result = await repository.updateQuantity(
      productId: event.productId,
      quantity: event.quantity,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false, errorMessage: failure.message));
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            isUpdating: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, clearErrorMessage: true));

    final result = await repository.removeItem(event.productId);

    result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false, errorMessage: failure.message));
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            isUpdating: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onCartCleared(
    CartCleared event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, clearErrorMessage: true));

    final result = await repository.clearCart();

    result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false, errorMessage: failure.message));
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            isUpdating: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onCartRefreshed(
    CartRefreshed event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, clearErrorMessage: true));

    final result = await repository.getCart();

    result.fold(
      (failure) {
        emit(
          state.copyWith(isRefreshing: false, errorMessage: failure.message),
        );
      },
      (cart) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cart,
            isRefreshing: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }
}
