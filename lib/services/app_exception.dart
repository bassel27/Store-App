class AppException implements Exception {
  final String message;
  // final String? prefix;
  final String? url;

  AppException(this.message, [this.url]);
  @override
  String toString() {
    return message;
  }
}

class BadRequestException extends AppException {
  BadRequestException(String message, [String? url]) : super(message, url);
}

class FetchDataException extends AppException {
  FetchDataException(String message, [String? url]) : super(message, url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException(String message, [String? url])
      : super(message, url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException(String message, [String? url]) : super(message, url);
}

class ProductUnavailableException extends AppException {
  ProductUnavailableException(String message, [String? url])
      : super(message, url);
}

class EmailAlreadyExistsException extends BadRequestException {
  EmailAlreadyExistsException(
      [String message = "This email address is already in use.", String? url])
      : super(message, url);
}

class InvalidEmailException extends BadRequestException {
  InvalidEmailException(
      [String message = "This is not a valid email address.", String? url])
      : super(message, url);
}

class WeakPasswordException extends BadRequestException {
  WeakPasswordException(
      [String message = "This password is too weak.", String? url])
      : super(message, url);
}

class EmailNotFound extends BadRequestException {
  EmailNotFound(
      [String message = "Could not find a user with that email.", String? url])
      : super(message, url);
}

class InvalidPasswordException extends BadRequestException {
  InvalidPasswordException([String message = "Invalid password.", String? url])
      : super(message, url);
}
