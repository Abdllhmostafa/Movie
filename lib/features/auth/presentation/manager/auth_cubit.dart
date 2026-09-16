import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/auth/domain/use_case/google_sign_in_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/reset_password_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase? resetPasswordUseCase;
  final GoogleSignInUseCase? googleSignInUseCase;

  AuthCubit(
    this.loginUseCase,
    this.registerUseCase, {
    this.resetPasswordUseCase,
    this.googleSignInUseCase,
  }) : super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await loginUseCase(email: email, password: password);
    if (isClosed) return;

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? avatar,
  }) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
      avatar: avatar,
    );
    if (isClosed) return;

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userEntity) => emit(AuthRegisterSuccess(userEntity)),
    );
  }

  Future<void> signInWithGoogle() async {
    if (googleSignInUseCase == null) {
      emit(const AuthFailure('Google Sign-In is not configured.'));
      return;
    }
    emit(const AuthLoading());
    final result = await googleSignInUseCase!();
    if (isClosed) return;

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }

  Future<void> resetPassword(String email) async {
    if (resetPasswordUseCase == null) {
      emit(const AuthFailure('Reset Password is not configured.'));
      return;
    }
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      emit(const AuthFailure('Please enter your email address.'));
      return;
    }
    emit(const AuthLoading());
    final result = await resetPasswordUseCase!(email: trimmedEmail);
    if (isClosed) return;

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (_) => emit(AuthPasswordResetSent(trimmedEmail)),
    );
  }

  void resetState() {
    emit(const AuthInitial());
  }
}
