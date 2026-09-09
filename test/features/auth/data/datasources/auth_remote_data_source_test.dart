import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';

void main() {
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = AuthRemoteDataSourceImpl();
  });

  test('login returns UserModel', () async {
    final result = await dataSource.login(
      email: 'amit@example.com',
      password: 'password',
    );

    expect(result.id, '1');
    expect(result.email, 'amit@example.com');
    expect(result.name, 'Amit');
  });

  test('getCurrentUser returns null when user is not logged in', () async {
    final result = await dataSource.getCurrentUser();

    expect(result, isNull);
  });

  test('logout completes successfully', () async {
    await expectLater(dataSource.logout(), completes);
  });
}
