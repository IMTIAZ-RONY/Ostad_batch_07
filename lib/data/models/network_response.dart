class NetworkResponse {
  final bool isSuccess;
  final statusCode;
  dynamic responseData;
  final errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = "Some thing went wrong.",
  });
}
