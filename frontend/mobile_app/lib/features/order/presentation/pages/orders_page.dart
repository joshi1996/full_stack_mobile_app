import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_operation_status.dart';
import '../bloc/order_state.dart';
import '../widgets/order_card.dart';
import '../widgets/order_empty_view.dart';
import '../widgets/order_error_view.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderBloc>()..add(const OrdersRequested()),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          switch (state.status) {
            case OrderOperationStatus.initial:
            case OrderOperationStatus.loading:
            case OrderOperationStatus.creating:
              return const Center(child: CircularProgressIndicator());

            case OrderOperationStatus.failure:
              return OrderErrorView(
                message: state.errorMessage ?? 'Unable to load orders.',
                onRetry: () {
                  context.read<OrderBloc>().add(const OrdersRequested());
                },
              );

            case OrderOperationStatus.created:
            case OrderOperationStatus.loaded:
              if (state.orders.isEmpty) {
                return const OrderEmptyView();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderBloc>().add(const OrdersRequested());

                  await context.read<OrderBloc>().stream.firstWhere(
                    (state) => state.status == OrderOperationStatus.loaded,
                  );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return OrderCard(order: state.orders[index]);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
