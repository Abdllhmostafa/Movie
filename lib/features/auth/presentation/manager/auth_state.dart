import 'package:movie_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

/// Initial State
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading State
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Success State with UserEntity
class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);
}

/// Failure State with error message
class AuthFailure extends AuthState {
  final String errorMessage;
  const AuthFailure(this.errorMessage);
}

/// Password Reset Email Sent State
class AuthPasswordResetSent extends AuthState {
  final String email;
  const AuthPasswordResetSent(this.email);
}

