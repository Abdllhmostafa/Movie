import 'package:movie_app/features/auth/data/data_source/data_source.dart';

class AuthDataSourceImp implements AuthDataSource {
  @override
  Future<String> login(String email, String password) async {
    // Simulate remote network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return "success";
  }

  @override
  Future<String> register(
    String name,
    String email,
    String password,
    String rePassword,
    String phone,
  ) async {
    // Simulate remote network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return "success";
  }
}
