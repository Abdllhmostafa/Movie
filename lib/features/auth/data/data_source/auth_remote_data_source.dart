import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> register({
    required String email,
    required String password,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<UserCredential> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl([FirebaseAuth? firebaseAuth])
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user.',
        );
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      final googleProvider = GoogleAuthProvider();
      return await firebaseAuth.signInWithProvider(googleProvider);
    }
  }
}

typedef AuthRemoteDataSourceImp = AuthRemoteDataSourceImpl;
