import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.login) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final Login login;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await login(email: event.email, password: event.password);

    result.fold(
      (failure) {
        emit(LoginFailure(failure));
      },
      (user) {
        emit(LoginSuccess(user));
      },
    );
  }
}
