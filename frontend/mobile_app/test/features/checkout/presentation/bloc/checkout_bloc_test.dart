import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart_item.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_item.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_pricing.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/usecases/get_checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_state.dart';

class FakeCheckoutRepository implements CheckoutRepository {
  FakeCheckoutRepository({this.checkout, this.failure});

  Checkout? checkout;
  Failure? failure;

  @override
  Future<Either<Failure, Checkout>> getCheckout(Cart cart) async {
    if (failure != null) {
      return Left(failure!);
    }

    return Right(
      checkout ??
          Checkout(
            items: cart.items
                .map(
                  (item) => CheckoutItem(
                    productId: item.productId,
                    productName: item.productName,
                    imageUrl: item.imageUrl,
                    unitPrice: item.unitPrice,
                    quantity: item.quantity,
                  ),
                )
                .toList(),
            pricing: CheckoutPricing(
              subtotal: cart.subtotal,
              discount: 0,
              deliveryFee: 0,
              tax: 0,
            ),
          ),
    );
  }
}

const testCartItem = CartItem(
  productId: 'product-1',
  productName: 'Premium Wireless Headphones',
  imageUrl: 'https://example.com/headphones.jpg',
  unitPrice: 2999,
  quantity: 2,
);

void main() {
  group('CheckoutBloc', () {
    late FakeCheckoutRepository repository;

    setUp(() {
      repository = FakeCheckoutRepository();
    });

    blocTest<CheckoutBloc, CheckoutState>(
      'emits loading and success when checkout loads',
      build: () => CheckoutBloc(GetCheckout(repository)),
      act: (bloc) =>
          bloc.add(const CheckoutStarted(Cart(items: [testCartItem]))),
      expect: () => [
        const CheckoutState(status: CheckoutStatus.loading),
        CheckoutState(
          status: CheckoutStatus.success,
          checkout: Checkout(
            items: [
              CheckoutItem(
                productId: 'product-1',
                productName: 'Premium Wireless Headphones',
                imageUrl: 'https://example.com/headphones.jpg',
                unitPrice: 2999,
                quantity: 2,
              ),
            ],
            pricing: CheckoutPricing(
              subtotal: 5998,
              discount: 0,
              deliveryFee: 0,
              tax: 0,
            ),
          ),
        ),
      ],
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits loading and failure when checkout loading fails',
      build: () {
        repository.failure = const ServerFailure('Unable to load checkout');

        return CheckoutBloc(GetCheckout(repository));
      },
      act: (bloc) =>
          bloc.add(const CheckoutStarted(Cart(items: [testCartItem]))),
      expect: () => [
        const CheckoutState(status: CheckoutStatus.loading),
        const CheckoutState(
          status: CheckoutStatus.failure,
          errorMessage: 'Unable to load checkout',
        ),
      ],
    );
  });
}
