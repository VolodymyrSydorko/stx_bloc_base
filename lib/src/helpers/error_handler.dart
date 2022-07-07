abstract class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;
}

class NetworkDeleteException extends NetworkException {
  NetworkDeleteException(super.message);
}
