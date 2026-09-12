import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failure.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
