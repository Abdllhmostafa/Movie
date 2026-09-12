import 'package:dartz/dartz.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepo {
  Future<Either<String, UserEntity>> login({
    required String email,
    required String password,
  });
  Future<Either<String, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });
}
