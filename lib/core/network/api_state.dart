sealed class ApiState<T> {
  const ApiState();
}

class ApiInit<T> extends ApiState<T> {
  const ApiInit();
}

class ApiLoading<T> extends ApiState<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiState<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiEmpty<T> extends ApiState<T> {
  const ApiEmpty();
}

class ApiError<T> extends ApiState<T> {
  final int code;
  final String message;
  const ApiError(this.code, this.message);
}

class ApiNoInternet<T> extends ApiState<T> {
  const ApiNoInternet();
}

class ApiUnauthorized<T> extends ApiState<T> {
  const ApiUnauthorized();
}

class ApiNoPermission<T> extends ApiState<T> {
  const ApiNoPermission();
}
