# full_stack_mobile_app

A new Flutter project.

## API environment

The app reads `APP_ENV` and `API_BASE_URL` with Flutter `--dart-define` values.
Development defaults to `http://10.0.2.2:3000/` on the Android emulator,
`http://localhost:3000/` on the iOS simulator and web, and
`http://127.0.0.1:3000/` on desktop. Android permits cleartext HTTP only in the
debug manifest. Staging and production require an explicit HTTPS `API_BASE_URL`.

For a physical device, use the development computer's LAN address and make sure
the backend is reachable from that device:

```shell
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000
```

For staging or production, provide the environment and deployment URL at build
time; do not commit deployment URLs that are private or environment-specific:

```shell
flutter run --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://YOUR_STAGING_API_HOST
flutter build apk --dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://YOUR_PRODUCTION_API_HOST
```

Browser builds also need the backend to allow the browser origin through CORS.

Logout removes the token from this device only. Since the backend has no logout
or token-revocation endpoint, a copied access token can still be used until its
10-minute expiry while the account remains active.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
