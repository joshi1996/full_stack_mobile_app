import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/core/error/app_exception.dart';
import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/core/error/failure_mapper.dart';

void main() {
  test('maps AuthenticationException to AuthenticationFailure', () {
    const exception = AuthenticationException('Invalid credentials');

    final failure = FailureMapper.fromException(exception);

    expect(failure, isA<AuthenticationFailure>());
    expect(failure.message, 'Invalid credentials');
  });

  test('maps NetworkException to NetworkFailure', () {
    const exception = NetworkException('No internet connection');

    final failure = FailureMapper.fromException(exception);

    expect(failure, isA<NetworkFailure>());
    expect(failure.message, 'No internet connection');
  });

  test('maps ServerException to ServerFailure', () {
    const exception = ServerException('Internal server error');

    final failure = FailureMapper.fromException(exception);

    expect(failure, isA<ServerFailure>());
    expect(failure.message, 'Internal server error');
  });

  test('maps CacheException to CacheFailure', () {
    const exception = CacheException('Cache unavailable');

    final failure = FailureMapper.fromException(exception);

    expect(failure, isA<CacheFailure>());
    expect(failure.message, 'Cache unavailable');
  });

  test('maps unknown exception to UnknownFailure', () {
    final failure = FailureMapper.fromException(
      Exception('Something unexpected happened'),
    );

    expect(failure, isA<UnknownFailure>());
  });
}
