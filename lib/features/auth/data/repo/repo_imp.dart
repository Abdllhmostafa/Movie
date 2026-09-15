import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:movie_app/features/auth/data/models/user_model.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class AuthRepoImp implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepoImp(this.authRemoteDataSource);

  @override
  Future<Either<String, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await authRemoteDataSource.login(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebase(userCredential.user!);
        return Right(userModel);
      } else {
        return const Left('User data not found.');
      }
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    String? avatar,
  }) async {
    try {
      final userCredential = await authRemoteDataSource.register(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        if (avatar != null && avatar.isNotEmpty) {
          await userCredential.user!.updatePhotoURL(avatar);
        }
        final userModel = UserModel(
          email: userCredential.user!.email ?? email,
          uID: userCredential.user!.uid,
          name: name,
        );
        return Right(userModel);
      } else {
        return const Left('User data not found.');
      }
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> resetPassword({required String email}) async {
    try {
      await authRemoteDataSource.resetPassword(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() async {
    try {
      final userCredential = await authRemoteDataSource.signInWithGoogle();
      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebase(userCredential.user!);
        return Right(userModel);
      } else {
        return const Left('Google sign-in cancelled or failed.');
      }
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(e.toString());
    }
  }


  String _mapFirebaseError(FirebaseAuthException e) {
    // ignore: avoid_print
    print('FirebaseAuthException [${e.code}]: ${e.message}');
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'network-request-failed':
        return 'Network error: ${e.message ?? "Connection failed. Please check emulator/device internet."}';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
    }
  }
}
