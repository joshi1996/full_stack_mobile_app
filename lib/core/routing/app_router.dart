import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/routing/auth_refresh_notifier.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/auth_status.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/auth_loading_page.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/pages/product_details_page.dart';
import 'package:full_stack_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/customer_app_shell.dart';
import 'package:full_stack_mobile_app/features/home/presentation/widgets/customer_placeholder_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    final refreshNotifier = AuthRefreshNotifier(authBloc);

    return GoRouter(
      initialLocation: '/auth-loading',
      refreshListenable: refreshNotifier,

      redirect: (context, state) {
        final authStatus = authBloc.state.status;
        final location = state.matchedLocation;

        final isLoginRoute = location == '/login';
        final isAuthLoadingRoute = location == '/auth-loading';

        // Authentication is still being restored.
        if (authStatus == AuthStatus.unknown) {
          return isAuthLoadingRoute ? null : '/auth-loading';
        }

        // User is not authenticated.
        if (authStatus == AuthStatus.unauthenticated) {
          return isLoginRoute ? null : '/login';
        }

        // User is authenticated.
        if (authStatus == AuthStatus.authenticated) {
          if (isLoginRoute || isAuthLoadingRoute) {
            return '/';
          }
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => getIt<LoginBloc>(),
              child: const LoginPage(),
            );
          },
        ),

        GoRoute(
          path: '/auth-loading',
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
              path: '/',
              name: RouteNames.home,
              builder: (context, state) {
                return const HomePage();
              },
            ),
            GoRoute(
              path: '/explore',
              name: RouteNames.explore,
              builder: (context, state) {
                return const CustomerPlaceholderPage(title: 'Explore');
              },
            ),
            GoRoute(
              path: '/cart',
              name: RouteNames.cart,
              builder: (context, state) {
                return const CustomerPlaceholderPage(title: 'Cart');
              },
            ),
            GoRoute(
              path: '/orders',
              name: RouteNames.orders,
              builder: (context, state) {
                return const CustomerPlaceholderPage(title: 'Orders');
              },
            ),
            GoRoute(
              path: '/profile',
              name: RouteNames.profile,
              builder: (context, state) {
                return const CustomerPlaceholderPage(title: 'Profile');
              },
            ),
          ],
        ),

        GoRoute(
          path: '/product/:productId',
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
      ],
    );
  }
}
