import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.email, required super.uID, super.name});
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      email: user.email ?? "",
      uID: user.uid,
      name: user.displayName,
    );
  }
}
