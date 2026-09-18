import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<void> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
