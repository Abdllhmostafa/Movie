import 'package:dartz/dartz.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class RegisterUseCase {
  final AuthRepo repo;

  const RegisterUseCase(this.repo);

  Future<Either<String, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repo.register(name: name, email: email, password: password);
  }
}
