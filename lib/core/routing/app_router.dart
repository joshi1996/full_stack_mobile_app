import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/routing/auth_refresh_notifier.dart';
import 'package:full_stack_mobile_app/core/routing/route_names.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/auth_status.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/auth_loading_page.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:full_stack_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    final refreshNotifier = AuthRefreshNotifier(authBloc);

    return GoRouter(
      refreshListenable: refreshNotifier,

      redirect: (context, state) {
        final authStatus = authBloc.state.status;

        final isLoginRoute = state.matchedLocation == '/login';

        if (authStatus == AuthStatus.unknown) {
          if (state.matchedLocation == '/auth-loading') {
            return null;
          }

          return '/auth-loading';
        }

        if (authStatus == AuthStatus.unauthenticated) {
          if (isLoginRoute) {
            return null;
          }

          return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isLoginRoute) {
            return '/';
          }
        }

        return null;
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
      ],
    );
  }
}
