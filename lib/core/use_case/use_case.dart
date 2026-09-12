import 'package:movie_app/core/utils/type_def.dart';

abstract class UseCase<T> {
  const UseCase();
  FutureResult<T> call();

}