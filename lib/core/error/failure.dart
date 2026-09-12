abstract class Failure {
  final String message;
  final int statusCode;

  Failure(this.message, this.statusCode);
  String get erroMessage => '$statusCode : $message';
}

class APIFailure extends Failure {
  APIFailure(super.errorMessage, super.statusCode);
}
