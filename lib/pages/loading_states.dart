//state
enum LoadingStates { initial, loading, success, error}

class ApiResponse<T> {
  final LoadingStates states;
  final T? data;
  final String? errorMessage;

  const ApiResponse._({required this.states, this.data, this.errorMessage});

  factory ApiResponse.initial() => ApiResponse._(states: LoadingStates.initial);

  factory ApiResponse.loading() => ApiResponse._(states: LoadingStates.loading);

  factory ApiResponse.success(T data) =>
      ApiResponse._(states: LoadingStates.success, data: data);

  factory ApiResponse.error(String message) =>
      ApiResponse._(states: LoadingStates.error, errorMessage: message);

  bool get isLoading => states == LoadingStates.loading;
  bool get isSucess => states == LoadingStates.success;
  bool get isError => states == LoadingStates.error;

  @override
  String toString() {
    return "ApiResponse($states, $data, $errorMessage)";
  }
}
