class APIException implements Exception {
  APIException({required this.errorMassage, required this.statusCode});
  String errorMassage;
  int statusCode;
}
