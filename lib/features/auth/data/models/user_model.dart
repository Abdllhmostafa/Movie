import 'package:movie_app/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.name,
    super.email,
    super.phone,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
    };
  }
}
