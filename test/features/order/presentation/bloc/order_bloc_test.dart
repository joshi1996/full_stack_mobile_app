import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Order;

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_address.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_item.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_pricing.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/payment_method.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/order.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/order_item.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/order_pricing.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/order_status.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/payment_status.dart';
import 'package:full_stack_mobile_app/features/order/domain/repositories/order_repository.dart';
import 'package:full_stack_mobile_app/features/order/domain/usecases/create_order.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_event.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_operation_status.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_state.dart'
    hide OrderStatus;

class FakeOrderRepository implements OrderRepository {
  Either<Failure, Order> createOrderResult = Right(_testOrder);

  Either<Failure, List<Order>> getOrdersResult = Right([_testOrder]);

  Either<Failure, Order> getOrderByIdResult = Right(_testOrder);

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    return createOrderResult;
  }

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    return getOrdersResult;
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    return getOrderByIdResult;
  }
}

const _testAddress = CheckoutAddress(
  id: 'address-1',
  label: 'Home',
  recipientName: 'Amit Joshi',
  addressLine1: '123 Main Street',
  addressLine2: null,
  city: 'Ahmedabad',
  state: 'Gujarat',
  postalCode: '380001',
  phone: '9876543210',
);

const _testCheckout = Checkout(
  items: [
    CheckoutItem(
      productId: 'product-1',
      productName: 'Test Product',
      imageUrl: 'https://example.com/product.jpg',
      unitPrice: 1000,
      quantity: 2,
    ),
  ],
  pricing: CheckoutPricing(
    subtotal: 2000,
    discount: 100,
    deliveryFee: 50,
    tax: 100,
  ),
  address: _testAddress,
  paymentMethod: PaymentMethod.upi,
);

final _testOrder = Order(
  id: 'order-1',
  items: const [
    OrderItem(
      productId: 'product-1',
      productName: 'Test Product',
      imageUrl: 'https://example.com/product.jpg',
      unitPrice: 1000,
      quantity: 2,
    ),
  ],
  address: _testAddress,
  pricing: const OrderPricing(
    subtotal: 2000,
    discount: 100,
    deliveryFee: 50,
    tax: 100,
    total: 2050,
  ),
  paymentMethod: PaymentMethod.upi,
  orderStatus: OrderStatus.pending,
  paymentStatus: PaymentStatus.pending,
  createdAt: DateTime(2026, 9, 14),
);

void main() {
  late FakeOrderRepository repository;
  late CreateOrder createOrder;
  late OrderBloc bloc;

  setUp(() {
    repository = FakeOrderRepository();

    createOrder = CreateOrder(repository);

    bloc = OrderBloc(createOrder: createOrder, orderRepository: repository);
  });

  tearDown(() async {
    await bloc.close();
  });

  group('OrderBloc', () {
    test('initial state is OrderOperationStatus.initial', () {
      expect(bloc.state, const OrderState());

      expect(bloc.state.status, OrderOperationStatus.initial);
    });

    test('emits creating then created when order creation succeeds', () async {
      repository.createOrderResult = Right(_testOrder);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrderState>().having(
            (state) => state.status,
            'status',
            OrderOperationStatus.creating,
          ),
          isA<OrderState>()
              .having(
                (state) => state.status,
                'status',
                OrderOperationStatus.created,
              )
              .having((state) => state.order, 'order', _testOrder),
        ]),
      );

      bloc.add(const OrderCreateRequested(_testCheckout));

      await expectation;
    });

    test('emits creating then failure when order creation fails', () async {
      repository.createOrderResult = const Left(
        UnknownFailure('Unable to create order.'),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrderState>().having(
            (state) => state.status,
            'status',
            OrderOperationStatus.creating,
          ),
          isA<OrderState>()
              .having(
                (state) => state.status,
                'status',
                OrderOperationStatus.failure,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Unable to create order.',
              ),
        ]),
      );

      bloc.add(const OrderCreateRequested(_testCheckout));

      await expectation;
    });

    test('emits loading then loaded when orders load successfully', () async {
      repository.getOrdersResult = Right([_testOrder]);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrderState>().having(
            (state) => state.status,
            'status',
            OrderOperationStatus.loading,
          ),
          isA<OrderState>()
              .having(
                (state) => state.status,
                'status',
                OrderOperationStatus.loaded,
              )
              .having((state) => state.orders, 'orders', [_testOrder]),
        ]),
      );

      bloc.add(const OrdersRequested());

      await expectation;
    });

    test('emits loading then failure when loading orders fails', () async {
      repository.getOrdersResult = const Left(
        UnknownFailure('Unable to load orders.'),
      );

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrderState>().having(
            (state) => state.status,
            'status',
            OrderOperationStatus.loading,
          ),
          isA<OrderState>()
              .having(
                (state) => state.status,
                'status',
                OrderOperationStatus.failure,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                'Unable to load orders.',
              ),
        ]),
      );

      bloc.add(const OrdersRequested());

      await expectation;
    });

    test(
      'emits loading then loaded when order details load successfully',
      () async {
        repository.getOrderByIdResult = Right(_testOrder);

        final expectation = expectLater(
          bloc.stream,
          emitsInOrder([
            isA<OrderState>().having(
              (state) => state.status,
              'status',
              OrderOperationStatus.loading,
            ),
            isA<OrderState>()
                .having(
                  (state) => state.status,
                  'status',
                  OrderOperationStatus.loaded,
                )
                .having((state) => state.order, 'order', _testOrder),
          ]),
        );

        bloc.add(const OrderDetailsRequested('order-1'));

        await expectation;
      },
    );

    test(
      'emits loading then failure when loading order details fails',
      () async {
        repository.getOrderByIdResult = const Left(
          UnknownFailure('Order not found.'),
        );

        final expectation = expectLater(
          bloc.stream,
          emitsInOrder([
            isA<OrderState>().having(
              (state) => state.status,
              'status',
              OrderOperationStatus.loading,
            ),
            isA<OrderState>()
                .having(
                  (state) => state.status,
                  'status',
                  OrderOperationStatus.failure,
                )
                .having(
                  (state) => state.errorMessage,
                  'errorMessage',
                  'Order not found.',
                ),
          ]),
        );

        bloc.add(const OrderDetailsRequested('missing-order'));

        await expectation;
      },
    );
  });
}
