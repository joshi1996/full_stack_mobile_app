import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/core/di/injection.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:full_stack_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:full_stack_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/login_bloc.dart';

void main() {
  setUp(() {
    getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('should resolve all auth dependencies', () {
    registerAuthDependencies();

    expect(getIt<AuthRemoteDataSource>(), isA<AuthRemoteDataSource>());

    expect(getIt<AuthRepository>(), isA<AuthRepository>());

    expect(getIt<Login>(), isA<Login>());

    expect(getIt<LoginBloc>(), isA<LoginBloc>());
  });
}
