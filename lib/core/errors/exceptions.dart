class ServerException implements Exception {

  ServerException([this.message = 'Server error occurred']);
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {

  CacheException([this.message = 'Cache error occurred']);
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {

  NetworkException([this.message = 'Network error occurred']);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {

  ValidationException([this.message = 'Validation error occurred']);
  final String message;

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {

  AuthenticationException([this.message = 'Authentication failed']);
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthorizationException implements Exception {

  AuthorizationException([this.message = 'Authorization failed']);
  final String message;

  @override
  String toString() => 'AuthorizationException: $message';
}

class NotFoundException implements Exception {

  NotFoundException([this.message = 'Resource not found']);
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}
