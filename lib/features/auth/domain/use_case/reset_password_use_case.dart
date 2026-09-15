import 'package:dartz/dartz.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class ResetPasswordUseCase {
  final AuthRepo repo;

  const ResetPasswordUseCase(this.repo);

  Future<Either<String, Unit>> call({required String email}) {
    return repo.resetPassword(email: email);
  }
}
