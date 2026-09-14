import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/features/layout/data/data_source/user_movies_service.dart';
import 'package:movie_app/features/layout/presentation/profile/manager/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _firebaseAuth;

  ProfileCubit({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(ProfileInitialState());

  Future<void> getProfileData() async {
    emit(ProfileLoadingState());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        try {
          await user.reload();
        } catch (_) {}
      }
      final freshUser = _firebaseAuth.currentUser;

      String name = (freshUser?.displayName != null &&
              freshUser!.displayName!.trim().isNotEmpty)
          ? freshUser.displayName!.trim()
          : "";
      String email = freshUser?.email ?? "";
      String phone = freshUser?.phoneNumber ?? "";
      String avatar = (freshUser?.photoURL != null &&
              freshUser!.photoURL!.trim().isNotEmpty)
          ? freshUser.photoURL!.trim()
          : "";

      if (freshUser != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          if (name.isEmpty) {
            name = prefs.getString('user_name_${freshUser.uid}') ??
                prefs.getString('user_name') ??
                prefs.getString('pending_name') ??
                "";
          }
          if (phone.isEmpty) {
            phone = prefs.getString('user_phone_${freshUser.uid}') ??
                prefs.getString('user_phone') ??
                prefs.getString('pending_phone') ??
                "";
          }
          if (avatar.isEmpty) {
            avatar = prefs.getString('user_avatar_${freshUser.uid}') ??
                prefs.getString('user_avatar') ??
                "";
          }
        } catch (_) {}
      }

      if (name.isEmpty) {
        name = email.isNotEmpty ? email.split('@').first : "User";
      }
      if (avatar.isEmpty) {
        avatar = AppAssets.gamer9;
      }

      final wishlistMovies = await UserMoviesService.getWishlist();
      final watchlistMovies = await UserMoviesService.getWatchlist();
      final historyMovies = await UserMoviesService.getHistory();

      emit(
        ProfileLoadedState(
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
          wishlistMovies: wishlistMovies,
          watchlistMovies: watchlistMovies,
          historyMovies: historyMovies,
        ),
      );
    } catch (e) {
      final user = _firebaseAuth.currentUser;
      final fallbackName = (user?.displayName != null && user!.displayName!.isNotEmpty)
          ? user.displayName!
          : (user?.email?.split('@').first ?? "User");
      final fallbackAvatar = (user?.photoURL != null && user!.photoURL!.isNotEmpty)
          ? user.photoURL!
          : AppAssets.gamer9;

      final wishlistMovies = await UserMoviesService.getWishlist();
      final watchlistMovies = await UserMoviesService.getWatchlist();
      final historyMovies = await UserMoviesService.getHistory();

      emit(
        ProfileLoadedState(
          name: fallbackName,
          email: user?.email ?? "",
          phone: user?.phoneNumber ?? "",
          avatar: fallbackAvatar,
          wishlistMovies: wishlistMovies,
          watchlistMovies: watchlistMovies,
          historyMovies: historyMovies,
        ),
      );
    }
  }

  Future<void> updateProfileData({
    required String name,
    required String avatar,
    String? phone,
  }) async {
    emit(ProfileLoadingState());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.updatePhotoURL(avatar);

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name_${user.uid}', name);
          await prefs.setString('user_name', name);
          await prefs.setString('user_avatar_${user.uid}', avatar);
          await prefs.setString('user_avatar', avatar);
          if (phone != null && phone.isNotEmpty) {
            await prefs.setString('user_phone_${user.uid}', phone);
            await prefs.setString('user_phone', phone);
          }
        } catch (_) {}

        try {
          await user.reload();
        } catch (_) {}
      }
      await getProfileData();
      emit(ProfileUpdateSuccessState());
    } catch (e) {
      emit(ProfileErrorState(_mapErrorMessage(e)));
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;
    if (email == null || email.isEmpty) {
      emit(ProfileErrorState("No email associated with this account"));
      return;
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      emit(ProfilePasswordResetSentState(email: email));
    } catch (e) {
      emit(ProfileErrorState(_mapErrorMessage(e)));
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(ProfileSignOutSuccessState());
    } catch (e) {
      emit(ProfileErrorState(_mapErrorMessage(e)));
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoadingState());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('user_phone_${user.uid}');
          await prefs.remove('user_name_${user.uid}');
          await prefs.remove('user_avatar_${user.uid}');
          await prefs.remove('user_phone');
          await prefs.remove('user_name');
          await prefs.remove('pending_phone');
          await prefs.remove('pending_name');
        } catch (_) {}

        await UserMoviesService.clearUserData(user.uid);
        await user.delete();
      }
      emit(ProfileDeleteAccountSuccessState());
    } catch (e) {
      emit(ProfileErrorState(_mapErrorMessage(e)));
    }
  }

  String _mapErrorMessage(dynamic error) {
    final errString = error.toString().toLowerCase();

    if (error is FirebaseAuthException || error is FirebaseException) {
      final code = (error is FirebaseAuthException)
          ? error.code
          : (error as FirebaseException).code;

      switch (code) {
        case 'requires-recent-login':
        case 'user-token-expired':
          return 'This action requires a fresh login for security. Please log out, sign in again, and retry.';
        case 'user-not-found':
          return 'No user found for that account.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid credentials. Please check and try again.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'email-already-in-use':
          return 'This email is already in use by another account.';
        default:
          if (error.message != null && error.message!.isNotEmpty) {
            return error.message!;
          }
      }
    }

    if (errString.contains('requires-recent-login') ||
        errString.contains('recent-login') ||
        errString.contains('credential_too_old')) {
      return 'This action requires a fresh login for security. Please log out, sign in again, and retry.';
    }

    if (errString.contains('network') ||
        errString.contains('socket') ||
        errString.contains('connection')) {
      return 'Network connection error. Please verify your internet connection.';
    }

    return error?.toString().replaceFirst('Exception: ', '') ??
        'An unexpected error occurred. Please try again.';
  }
}
