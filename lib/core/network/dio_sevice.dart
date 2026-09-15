import 'package:dio/dio.dart';

class DioSevice {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://movies-api.accel.li/api/v2/',
        connectTimeout: const Duration(seconds: 35),
        receiveTimeout: const Duration(seconds: 35),
        sendTimeout: const Duration(seconds: 35),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          final isTimeout = err.type == DioExceptionType.connectionTimeout ||
              err.type == DioExceptionType.receiveTimeout ||
              err.type == DioExceptionType.sendTimeout ||
              err.type == DioExceptionType.connectionError;

          final extra = err.requestOptions.extra;
          final retryCount = (extra['retryCount'] as int?) ?? 0;

          if (isTimeout && retryCount < 2) {
            extra['retryCount'] = retryCount + 1;
            try {
              final response = await dio.fetch(err.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(err);
            }
          }
          return handler.next(err);
        },
      ),
    );

    return dio;
  }
}
