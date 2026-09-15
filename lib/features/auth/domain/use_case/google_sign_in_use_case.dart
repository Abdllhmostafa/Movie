import 'package:dartz/dartz.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class GoogleSignInUseCase {
  final AuthRepo repo;

  const GoogleSignInUseCase(this.repo);

  Future<Either<String, UserEntity>> call() {
    return repo.signInWithGoogle();
  }
}
