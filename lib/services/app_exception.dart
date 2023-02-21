class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? url;

  AppException(this.message, [this.prefix, this.url]);
  @override
  String toString() {
    return message;
  }
}

class BadRequestException extends AppException {
  BadRequestException(String message, [String? url])
      : super(message, 'Bad Request', url);
}

class FetchDataException extends AppException {
  FetchDataException(String message, [String? url])
      : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException(String message, [String? url])
      : super(message, 'Api did not respond in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException(String message, [String? url])
      : super(message, 'Unauthorized request', url);
}

class ProductUnavailableException implements Exception {
  final String message;
  ProductUnavailableException(this.message);
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}
