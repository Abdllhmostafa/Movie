import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/states/base_state.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'package:movie_app/features/auth/presentation/manager/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit(this.loginUseCase, this.registerUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginState: const LoadingState()));
    try {
      final isLogin = await loginUseCase.call(email, password);
      if (isLogin) {
        emit(state.copyWith(loginState: const SuccessState(data: "Success")));
      } else {
        emit(state.copyWith(loginState: const ErrorState(message: "Invalid email or password")));
      }
    } catch (e) {
      emit(state.copyWith(loginState: ErrorState(message: e.toString())));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String rePassword,
    required String phone,
  }) async {
    emit(state.copyWith(registerState: const LoadingState()));
    try {
      final isRegistered = await registerUseCase.call(
        name,
        email,
        password,
        rePassword,
        phone,
      );
      if (isRegistered) {
        emit(state.copyWith(registerState: const SuccessState(data: "Success")));
      } else {
        emit(state.copyWith(registerState: const ErrorState(message: "Registration failed")));
      }
    } catch (e) {
      emit(state.copyWith(registerState: ErrorState(message: e.toString())));
    }
  }
}
