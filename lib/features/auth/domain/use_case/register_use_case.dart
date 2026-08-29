import 'package:e_commerce_app/features/auth/domain/repo/repo.dart';

class RegisterUseCase {
  final AuthRepo repo;

  const RegisterUseCase(this.repo);

  Future<bool> call(
    String name,
    String email,
    String password,
    String rePassword,
    String phone,
  ) {
    return repo.register(name, email, password, rePassword, phone);
  }
}
