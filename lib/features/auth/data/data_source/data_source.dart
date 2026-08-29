abstract class AuthDataSource {
  Future<String> login(String email, String password);
  Future<String> register(
    String name,
    String email,
    String password,
    String rePassword,
    String phone,
  );
}
