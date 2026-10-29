import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/routing/app_router.dart';
import 'package:full_stack_mobile_app/core/routing/route_paths.dart';
import 'package:full_stack_mobile_app/features/auth/domain/entities/user.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_state.dart';

class _UnauthenticatedRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async =>
      const Right(User(id: '1', email: 'user@example.com', name: 'User'));

  @override
  Future<Either<Failure, Unit>> logout() async => const Right(unit);

  @override
  Future<Either<Failure, User?>> getCurrentUser() async => const Right(null);
}

class _RetryableRepository implements AuthRepository {
  int restorationAttempts = 0;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async =>
      const Right(User(id: '1', email: 'user@example.com', name: 'User'));

  @override
  Future<Either<Failure, Unit>> logout() async => const Right(unit);

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    restorationAttempts++;
    if (restorationAttempts == 1) {
      return const Left(NetworkFailure('offline'));
    }
    return const Right(null);
  }
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('unauthenticated users are redirected from protected routes', (
    tester,
  ) async {
    registerNetworkDependencies();
    registerAuthDependencies();
    final authBloc = AuthBloc(_UnauthenticatedRepository());
    await authBloc.checkAuthStatus();
    final router = AppRouter.createRouter(authBloc);

    await tester.pumpWidget(
      BlocProvider.value(
        value: authBloc,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    router.go(RoutePaths.home);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('Welcome Back'), findsOneWidget);

    router.dispose();
    await authBloc.close();
  });

  testWidgets('keeps restoration failures on loading and retries on tap', (
    tester,
  ) async {
    registerNetworkDependencies();
    registerAuthDependencies();
    final repository = _RetryableRepository();
    final authBloc = AuthBloc(repository);
    await authBloc.checkAuthStatus();
    final router = AppRouter.createRouter(authBloc);

    await tester.pumpWidget(
      BlocProvider.value(
        value: authBloc,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      RoutePaths.authLoading,
    );
    expect(find.text('Unable to verify your session'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Welcome Back'), findsNothing);

    router.go(RoutePaths.home);
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      RoutePaths.authLoading,
    );
    expect(find.text('Welcome Back'), findsNothing);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(repository.restorationAttempts, 2);
    expect(router.routeInformationProvider.value.uri.path, RoutePaths.login);
    expect(find.text('Welcome Back'), findsOneWidget);

    router.dispose();
    await authBloc.close();
  });

  test('an unverified session starts in the unknown auth state', () {
    final authBloc = AuthBloc(_UnauthenticatedRepository());
    addTearDown(authBloc.close);

    expect(authBloc.state, isA<AuthInitial>());
  });
}
