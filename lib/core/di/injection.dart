import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:full_stack_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:full_stack_mobile_app/features/catalog/data/datasources/catalog_data_source.dart';
import 'package:full_stack_mobile_app/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:full_stack_mobile_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:full_stack_mobile_app/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:full_stack_mobile_app/features/home/data/datasources/home_data_source.dart';
import 'package:full_stack_mobile_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:full_stack_mobile_app/features/home/domain/repositories/home_repository.dart';
import 'package:full_stack_mobile_app/features/home/presentation/bloc/home_bloc.dart';
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
}
