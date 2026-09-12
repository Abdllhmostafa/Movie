import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:movie_app/features/auth/domain/use_case/register_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit(this.loginUseCase, this.registerUseCase) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failureMessage) => emit(AuthFailure(failureMessage)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }
}
