import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:full_stack_mobile_app/features/address/data/datasources/address_data_source.dart';
import 'package:full_stack_mobile_app/features/address/data/repositories/address_repository_impl.dart';
import 'package:full_stack_mobile_app/features/address/domain/repositories/address_repository.dart';
import 'package:full_stack_mobile_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:full_stack_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/cart/data/datasources/cart_data_source.dart';
import 'package:full_stack_mobile_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:full_stack_mobile_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:full_stack_mobile_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:full_stack_mobile_app/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:full_stack_mobile_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/product_details_bloc.dart';
import 'package:full_stack_mobile_app/features/checkout/data/datasources/checkout_data_source.dart';
import 'package:full_stack_mobile_app/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/usecases/get_checkout.dart';
import 'package:full_stack_mobile_app/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:full_stack_mobile_app/features/home/data/datasources/home_data_source.dart';
import 'package:full_stack_mobile_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:full_stack_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:full_stack_mobile_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:full_stack_mobile_app/features/order/data/datasources/order_data_source.dart';
import 'package:full_stack_mobile_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:full_stack_mobile_app/features/order/domain/repositories/order_repository.dart';
import 'package:full_stack_mobile_app/features/order/domain/usecases/create_order.dart';
import 'package:full_stack_mobile_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void registerAuthDependencies() {
  // Data source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl.new,
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<Login>(() => Login(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<Login>()));

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()),
  );
}

void registerHomeDependencies() {
  getIt.registerLazySingleton<HomeDataSource>(HomeDataSourceImpl.new);

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeDataSource>()),
  );

  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<HomeRepository>()));
}

void registerCatalogDependencies() {
  getIt.registerLazySingleton<CatalogDataSource>(CatalogDataSourceImpl.new);

  getIt.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(getIt<CatalogDataSource>()),
  );

  getIt.registerFactory<CatalogBloc>(
    () => CatalogBloc(getIt<CatalogRepository>()),
  );

  getIt.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(getIt<CatalogRepository>()),
  );
}

void registerCartDependencies() {
  getIt.registerLazySingleton<CartDataSource>(CartDataSourceImpl.new);

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt<CartDataSource>()),
  );

  getIt.registerFactory<CartBloc>(() => CartBloc(getIt<CartRepository>()));
}

void registerCheckoutDependencies() {
  getIt.registerLazySingleton<CheckoutDataSource>(CheckoutDataSourceImpl.new);

  getIt.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(getIt<CheckoutDataSource>()),
  );

  getIt.registerLazySingleton<GetCheckout>(
    () => GetCheckout(getIt<CheckoutRepository>()),
  );

  getIt.registerFactory<CheckoutBloc>(() => CheckoutBloc(getIt<GetCheckout>()));
}

void registerAddressDependencies() {
  getIt.registerLazySingleton<AddressDataSource>(AddressDataSourceImpl.new);

  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(getIt<AddressDataSource>()),
  );

  getIt.registerFactory<AddressBloc>(
    () => AddressBloc(getIt<AddressRepository>()),
  );
}

void registerOrderDependencies() {
  getIt.registerLazySingleton<OrderDataSource>(OrderDataSourceImpl.new);

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderDataSource>()),
  );

  getIt.registerLazySingleton<CreateOrder>(
    () => CreateOrder(getIt<OrderRepository>()),
  );

  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
      createOrder: getIt<CreateOrder>(),
      orderRepository: getIt<OrderRepository>(),
    ),
  );
}
