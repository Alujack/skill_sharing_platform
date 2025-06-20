class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic responseData;

  ApiException(this.message, this.statusCode, [this.responseData]);

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}