import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_operation_status.dart';

import '../../domain/usecases/create_order.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required CreateOrder createOrder,
    required OrderRepository orderRepository,
  }) : _createOrder = createOrder,
       _orderRepository = orderRepository,
       super(const OrderState()) {
    on<OrderCreateRequested>(_onCreateOrder);
    on<OrdersRequested>(_onOrdersRequested);
    on<OrderDetailsRequested>(_onOrderDetailsRequested);
  }

  final CreateOrder _createOrder;
  final OrderRepository _orderRepository;

  Future<void> _onCreateOrder(
    OrderCreateRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderOperationStatus.creating,
        clearErrorMessage: true,
      ),
    );

    final result = await _createOrder(event.checkout);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (order) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.created,
            order: order,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onOrdersRequested(
    OrdersRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderOperationStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _orderRepository.getOrders();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (orders) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.loaded,
            orders: orders,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onOrderDetailsRequested(
    OrderDetailsRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderOperationStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final result = await _orderRepository.getOrderById(event.orderId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (order) {
        emit(
          state.copyWith(
            status: OrderOperationStatus.loaded,
            order: order,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }
}
