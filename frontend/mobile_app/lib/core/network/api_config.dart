import 'package:flutter/foundation.dart';

enum ApiEnvironment { development, staging, production }

class ApiConfig {
  const ApiConfig({
    this.environment = const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    ),
    this.apiBaseUrl = const String.fromEnvironment('API_BASE_URL'),
    this.targetPlatform,
    this.isWeb = kIsWeb,
  });

  final String environment;
  final String apiBaseUrl;
  final TargetPlatform? targetPlatform;
  final bool isWeb;

  String get baseUrl {
    final apiEnvironment = switch (environment) {
      'development' => ApiEnvironment.development,
      'staging' => ApiEnvironment.staging,
      'production' => ApiEnvironment.production,
      _ => throw StateError(
        'APP_ENV must be development, staging, or production.',
      ),
    };

    final configuredUrl = apiBaseUrl.trim();
    final url = configuredUrl.isNotEmpty
        ? configuredUrl
        : switch (apiEnvironment) {
            ApiEnvironment.development => _developmentBaseUrl,
            ApiEnvironment.staging ||
            ApiEnvironment.production => throw StateError(
              'API_BASE_URL must be provided for staging and production.',
            ),
          };

    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        !{'http', 'https'}.contains(uri.scheme)) {
      throw StateError('API_BASE_URL must be a valid HTTP or HTTPS URL.');
    }

    if (apiEnvironment != ApiEnvironment.development && uri.scheme != 'https') {
      throw StateError('Staging and production API URLs must use HTTPS.');
    }

    return uri
        .replace(path: uri.path.endsWith('/') ? uri.path : '${uri.path}/')
        .toString();
  }

  String get _developmentBaseUrl {
    if (isWeb) return 'http://localhost:3000/';

    return switch (targetPlatform ?? defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:3000/',
      TargetPlatform.iOS => 'http://localhost:3000/',
      TargetPlatform.fuchsia => 'http://localhost:3000/',
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => 'http://127.0.0.1:3000/',
    };
  }
}
