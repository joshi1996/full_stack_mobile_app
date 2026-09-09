import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:full_stack_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';
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
