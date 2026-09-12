import 'package:dartz/dartz.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  const LoginUseCase(this.repo);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repo.login(email: email, password: password);
  }
}
