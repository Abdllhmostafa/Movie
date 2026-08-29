import 'package:e_commerce_app/features/auth/domain/repo/repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  const LoginUseCase(this.repo);

  Future<bool> call(String email, String password) {
    return repo.login(email, password);
  }
}
