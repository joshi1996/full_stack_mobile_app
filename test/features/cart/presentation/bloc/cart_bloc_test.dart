import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart_item.dart';
import 'package:full_stack_mobile_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_state.dart';

class FakeCartRepository implements CartRepository {
  FakeCartRepository({this.cart = const Cart()});

  Cart cart;

  Failure? getCartFailure;
  Failure? addItemFailure;
  Failure? updateQuantityFailure;
  Failure? removeItemFailure;
  Failure? clearCartFailure;

  @override
  Future<Either<Failure, Cart>> getCart() async {
    if (getCartFailure != null) {
      return Left(getCartFailure!);
    }

    return Right(cart);
  }

  @override
  Future<Either<Failure, Cart>> addItem(CartItem item) async {
    if (addItemFailure != null) {
      return Left(addItemFailure!);
    }

    final existingIndex = cart.items.indexWhere(
      (existingItem) => existingItem.productId == item.productId,
    );

    if (existingIndex == -1) {
      cart = cart.copyWith(items: [...cart.items, item]);
    } else {
      final updatedItems = [...cart.items];
      final existingItem = updatedItems[existingIndex];

      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );

      cart = cart.copyWith(items: updatedItems);
    }

    return Right(cart);
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    if (updateQuantityFailure != null) {
      return Left(updateQuantityFailure!);
    }

    if (quantity <= 0) {
      return removeItem(productId);
    }

    final updatedItems = cart.items.map((item) {
      if (item.productId != productId) {
        return item;
      }

      return item.copyWith(quantity: quantity);
    }).toList();

    cart = cart.copyWith(items: updatedItems);

    return Right(cart);
  }

  @override
  Future<Either<Failure, Cart>> removeItem(String productId) async {
    if (removeItemFailure != null) {
      return Left(removeItemFailure!);
    }

    cart = cart.copyWith(
      items: cart.items.where((item) => item.productId != productId).toList(),
    );

    return Right(cart);
  }

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    if (clearCartFailure != null) {
      return Left(clearCartFailure!);
    }

    cart = const Cart();

    return Right(cart);
  }
}

const testItem = CartItem(
  productId: 'product-1',
  productName: 'Premium Wireless Headphones',
  imageUrl: 'https://example.com/headphones.jpg',
  unitPrice: 2999,
  quantity: 1,
);

const secondTestItem = CartItem(
  productId: 'product-2',
  productName: 'Smart Watch Pro',
  imageUrl: 'https://example.com/watch.jpg',
  unitPrice: 4999,
  quantity: 1,
);

void main() {
  group('CartBloc', () {
    late FakeCartRepository repository;

    setUp(() {
      repository = FakeCartRepository();
    });

    blocTest<CartBloc, CartState>(
      'emits loading and success when cart loads',
      build: () => CartBloc(repository),
      act: (bloc) => bloc.add(const CartStarted()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(status: CartStatus.success, cart: Cart()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading and failure when cart loading fails',
      build: () {
        repository.getCartFailure = const ServerFailure('Unable to load cart');

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(const CartStarted()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(
          status: CartStatus.failure,
          errorMessage: 'Unable to load cart',
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'adds item to cart',
      build: () => CartBloc(repository),
      act: (bloc) => bloc.add(const CartItemAdded(testItem)),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(
          status: CartStatus.success,
          cart: Cart(items: [testItem]),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'adding same product increases quantity',
      build: () {
        repository.cart = const Cart(items: [testItem]);

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testItem)),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(
          status: CartStatus.success,
          cart: Cart(
            items: [
              CartItem(
                productId: 'product-1',
                productName: 'Premium Wireless Headphones',
                imageUrl: 'https://example.com/headphones.jpg',
                unitPrice: 2999,
                quantity: 2,
              ),
            ],
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'updates item quantity',
      build: () {
        repository.cart = const Cart(items: [testItem]);

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(
        const CartQuantityUpdated(productId: 'product-1', quantity: 3),
      ),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(
          status: CartStatus.success,
          cart: Cart(
            items: [
              CartItem(
                productId: 'product-1',
                productName: 'Premium Wireless Headphones',
                imageUrl: 'https://example.com/headphones.jpg',
                unitPrice: 2999,
                quantity: 3,
              ),
            ],
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item from cart',
      build: () {
        repository.cart = const Cart(items: [testItem]);

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(const CartItemRemoved('product-1')),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(status: CartStatus.success, cart: Cart()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears cart',
      build: () {
        repository.cart = const Cart(items: [testItem, secondTestItem]);

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(const CartCleared()),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(status: CartStatus.success, cart: Cart()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits refreshing and success when cart is refreshed',
      build: () {
        repository.cart = const Cart(items: [testItem]);

        return CartBloc(repository);
      },
      seed: () => const CartState(
        status: CartStatus.success,
        cart: Cart(items: [testItem]),
      ),
      act: (bloc) => bloc.add(const CartRefreshed()),
      expect: () => [
        const CartState(
          status: CartStatus.success,
          cart: Cart(items: [testItem]),
          isRefreshing: true,
        ),
        const CartState(
          status: CartStatus.success,
          cart: Cart(items: [testItem]),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'preserves existing cart when refresh fails',
      build: () {
        repository.cart = const Cart(items: [testItem]);

        repository.getCartFailure = const ServerFailure(
          'Unable to refresh cart',
        );

        return CartBloc(repository);
      },
      seed: () => const CartState(
        status: CartStatus.success,
        cart: Cart(items: [testItem]),
      ),
      act: (bloc) => bloc.add(const CartRefreshed()),
      expect: () => [
        const CartState(
          status: CartStatus.success,
          cart: Cart(items: [testItem]),
          isRefreshing: true,
        ),
        const CartState(
          status: CartStatus.success,
          cart: Cart(items: [testItem]),
          errorMessage: 'Unable to refresh cart',
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits failure when adding item fails',
      build: () {
        repository.addItemFailure = const ServerFailure('Unable to add item');

        return CartBloc(repository);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testItem)),
      expect: () => [
        const CartState(isUpdating: true),
        const CartState(errorMessage: 'Unable to add item'),
      ],
    );
  });
}
