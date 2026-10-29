import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/core/network/api_config.dart';

void main() {
  test('uses the Android emulator host for local development', () {
    const config = ApiConfig(
      targetPlatform: TargetPlatform.android,
      isWeb: false,
    );

    expect(config.baseUrl, 'http://10.0.2.2:3000/');
  });

  test('uses loopback for desktop development', () {
    const config = ApiConfig(
      targetPlatform: TargetPlatform.windows,
      isWeb: false,
    );

    expect(config.baseUrl, 'http://127.0.0.1:3000/');
  });

  test('allows a developer to override the URL for a physical device', () {
    const config = ApiConfig(
      apiBaseUrl: 'http://192.168.1.20:3000',
      targetPlatform: TargetPlatform.android,
      isWeb: false,
    );

    expect(config.baseUrl, 'http://192.168.1.20:3000/');
  });

  test('requires an explicit HTTPS URL for deployed environments', () {
    const missingUrl = ApiConfig(environment: 'production');
    const insecureUrl = ApiConfig(
      environment: 'staging',
      apiBaseUrl: 'http://staging.example.test',
    );

    expect(() => missingUrl.baseUrl, throwsStateError);
    expect(() => insecureUrl.baseUrl, throwsStateError);
  });

  test('accepts an explicit HTTPS URL for staging', () {
    const config = ApiConfig(
      environment: 'staging',
      apiBaseUrl: 'https://staging.example.test/api',
    );

    expect(config.baseUrl, 'https://staging.example.test/api/');
  });
}
