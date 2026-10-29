import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';
import 'package:full_stack_mobile_app/core/routing/auth_refresh_notifier.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:full_stack_mobile_app/core/routing/route_paths.dart';
import 'package:full_stack_mobile_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:full_stack_mobile_app/features/address/presentation/pages/add_address_page.dart';
import 'package:full_stack_mobile_app/features/address/presentation/pages/address_selection_page.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/auth_status.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/auth_loading_page.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:full_stack_mobile_app/features/cart/domain/entities/cart.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/pages/cart_page.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/pages/catalog_page.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/pages/product_details_page.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:full_stack_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/customer_app_shell.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/customer_placeholder_page.dart';
import 'package:full_stack_mobile_app/features/order/domain/entities/order.dart';
import 'package:full_stack_mobile_app/features/order/presentation/pages/order_confirmation_page.dart';
import 'package:full_stack_mobile_app/features/order/presentation/pages/order_details_page.dart';
import 'package:full_stack_mobile_app/features/order/presentation/pages/orders_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    final refreshNotifier = AuthRefreshNotifier(
      authBloc,
      getIt<AuthSessionCoordinator>(),
    );

    return GoRouter(
      initialLocation: RoutePaths.authLoading,
      refreshListenable: refreshNotifier,

      redirect: (context, state) {
        final authStatus = authBloc.state.status;
        final location = state.matchedLocation;

        final isLoginRoute = location == RoutePaths.login;
        final isAuthLoadingRoute = location == RoutePaths.authLoading;

        // Authentication is still being restored or needs a retry.
        if (authStatus == AuthStatus.unknown ||
            authStatus == AuthStatus.restorationFailed) {
          return isAuthLoadingRoute ? null : RoutePaths.authLoading;
        }

        // User is not authenticated.
        if (authStatus == AuthStatus.unauthenticated) {
          return isLoginRoute ? null : RoutePaths.login;
        }

        // User is authenticated.
        if (authStatus == AuthStatus.authenticated) {
          if (isLoginRoute || isAuthLoadingRoute) {
            return RoutePaths.home;
          }
        }

        return null;
      },

      routes: [
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<LoginBloc>(),
              child: const LoginPage(),
            );
          },
        ),

        GoRoute(
          path: RoutePaths.authLoading,
          name: RouteNames.authLoading,
          builder: (context, state) {
            return const AuthLoadingPage();
          },
        ),

        ShellRoute(
          builder: (context, state, child) {
            return CustomerAppShell(child: child);
          },
          routes: [
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) {
                return const HomePage();
              },
            ),
            GoRoute(
              path: RoutePaths.explore,
              name: RouteNames.explore,
              builder: (context, state) {
                return CatalogPage();
              },
            ),
            GoRoute(
              path: RoutePaths.cart,
              name: RouteNames.cart,
              builder: (context, state) {
                return const CartPage();
              },
            ),
            GoRoute(
              path: RoutePaths.orders,
              name: RouteNames.orders,
              builder: (context, state) {
                return const OrdersPage();
              },
            ),
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) {
                return const CustomerPlaceholderPage(title: 'Profile');
              },
            ),
          ],
        ),

        GoRoute(
          path: RoutePaths.productDetails,
          name: RouteNames.productDetails,
          builder: (context, state) {
            final productId = state.pathParameters['productId'];

            if (productId == null || productId.isEmpty) {
              return const Scaffold(
                body: Center(child: Text('Product not found')),
              );
            }

            return ProductDetailsPage(productId: productId);
          },
        ),

        GoRoute(
          name: RouteNames.checkout,
          path: RoutePaths.checkout,
          builder: (context, state) {
            final cart = state.extra;

            if (cart is! Cart) {
              return const Scaffold(
                body: Center(child: Text('Checkout is unavailable.')),
              );
            }

            return CheckoutPage(cart: cart);
          },
        ),

        GoRoute(
          path: RoutePaths.addressSelection,
          name: RouteNames.addressSelection,
          builder: (context, state) {
            return const AddressSelectionPage();
          },
        ),

        GoRoute(
          path: RoutePaths.addAddress,
          name: RouteNames.addAddress,
          builder: (context, state) {
            final addressBloc = state.extra;

            if (addressBloc is! AddressBloc) {
              return const Scaffold(
                body: Center(child: Text('Unable to open address form.')),
              );
            }

            return BlocProvider.value(
              value: addressBloc,
              child: const AddAddressPage(),
            );
          },
        ),

        GoRoute(
          name: RouteNames.orderConfirmation,
          path: RoutePaths.orderConfirmation,
          builder: (context, state) {
            final order = state.extra;

            if (order is! Order) {
              return const Scaffold(
                body: Center(child: Text('Order confirmation is unavailable.')),
              );
            }

            return OrderConfirmationPage(order: order);
          },
        ),

        GoRoute(
          path: RoutePaths.orderDetails,
          name: RouteNames.orderDetails,
          builder: (context, state) {
            final orderId = state.pathParameters['orderId'];

            if (orderId == null || orderId.isEmpty) {
              return const Scaffold(
                body: Center(child: Text('Order not found.')),
              );
            }

            return OrderDetailsPage(orderId: orderId);
          },
        ),
      ],
    );
  }
}
