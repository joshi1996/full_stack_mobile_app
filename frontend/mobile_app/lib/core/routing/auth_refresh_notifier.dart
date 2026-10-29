import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:full_stack_mobile_app/core/network/auth_session_coordinator.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(
    AuthBloc authBloc,
    AuthSessionCoordinator sessionCoordinator,
  ) {
    _sessionExpiredSubscription = sessionCoordinator.sessionExpired.listen((_) {
      authBloc.sessionExpired();
    });
    _authSubscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<void> _sessionExpiredSubscription;
  late final StreamSubscription<void> _authSubscription;

  @override
  void dispose() {
    _sessionExpiredSubscription.cancel();
    _authSubscription.cancel();
    super.dispose();
  }
}
