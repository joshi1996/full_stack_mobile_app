import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/core/error/app_exception.dart';

void main() {
  test('ServerException stores message', () {
    const exception = ServerException('Server error');

    expect(exception.message, 'Server error');
  });

  test('NetworkException stores message', () {
    const exception = NetworkException('Network error');

    expect(exception.message, 'Network error');
  });

  test('AuthenticationException stores message', () {
    const exception = AuthenticationException('Invalid credentials');

    expect(exception.message, 'Invalid credentials');
  });

  test('CacheException stores message', () {
    const exception = CacheException('Cache error');

    expect(exception.message, 'Cache error');
  });
}
