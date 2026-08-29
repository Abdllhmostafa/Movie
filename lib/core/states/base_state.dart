sealed class BaseState<T> {
  final T? data;
  final String? message;
  const BaseState({this.data, this.message});
}

class InitialState<T> extends BaseState<T> {
  const InitialState();
}

class LoadingState<T> extends BaseState<T> {
  const LoadingState();
}

class SuccessState<T> extends BaseState<T> {
  const SuccessState({super.data});
}

class ErrorState<T> extends BaseState<T> {
  const ErrorState({super.message});
}
