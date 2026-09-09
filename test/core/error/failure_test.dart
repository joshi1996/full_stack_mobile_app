import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';

void main() {
  test('ServerFailure stores message', () {
    const failure = ServerFailure('Server error');

    expect(failure.message, 'Server error');
  });

  test('NetworkFailure stores message', () {
    const failure = NetworkFailure('No internet connection');

    expect(failure.message, 'No internet connection');
  });

  test('AuthenticationFailure stores message', () {
    const failure = AuthenticationFailure('Invalid credentials');

    expect(failure.message, 'Invalid credentials');
  });

  test('CacheFailure stores message', () {
    const failure = CacheFailure('Cache error');

    expect(failure.message, 'Cache error');
  });

  test('UnknownFailure stores message', () {
    const failure = UnknownFailure('Unknown error');

    expect(failure.message, 'Unknown error');
  });
}
