class NetworkException implements Exception {
  const NetworkException();
}

class RequestTimeoutException implements Exception {
  const RequestTimeoutException();
}

class ServerException implements Exception {
  const ServerException(this.statusCode);

  final int statusCode;
}

class InvalidResponseException implements Exception {
  const InvalidResponseException();
}