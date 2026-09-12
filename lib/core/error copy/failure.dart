abstract class Failure {
  final String message;

  Failure(this.message);
}

class APIFailure extends Failure {
  APIFailure(super.errorMessage);
}
