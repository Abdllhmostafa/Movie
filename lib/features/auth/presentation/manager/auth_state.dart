import 'package:e_commerce_app/core/states/base_state.dart';

class AuthState {
  final BaseState<String> loginState;
  final BaseState<String> registerState;

  const AuthState({
    this.loginState = const InitialState<String>(),
    this.registerState = const InitialState<String>(),
  });

  AuthState copyWith({
    BaseState<String>? loginState,
    BaseState<String>? registerState,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      registerState: registerState ?? this.registerState,
    );
  }
}
