import 'package:movie_app/features/auth/data/data_source/data_source.dart';
import 'package:movie_app/features/auth/domain/repo/repo.dart';

class AuthRepoImp implements AuthRepo {
  final AuthDataSource dataSource;

  const AuthRepoImp(this.dataSource);

  @override
  Future<bool> login(String email, String password) async {
    final value = await dataSource.login(email, password);
    return value == "success";
  }

  @override
  Future<bool> register(
    String name,
    String email,
    String password,
    String rePassword,
    String phone,
  ) async {
    final value = await dataSource.register(
      name,
      email,
      password,
      rePassword,
      phone,
    );
    return value == "success";
  }
}

// Alias to support legacy naming if needed
typedef AuthRepImp = AuthRepoImp;
