import 'package:flutter/foundation.dart';

class MainError {
  MainError({@required this.error, this.trace});

  final String error;
  final StackTrace trace;

  @override
  String toString() => error;
}

class ConnectionError extends MainError {
  ConnectionError({String error = 'Ошибка связи', StackTrace trace})
      : super(error: error, trace: trace);
}

class ServerError extends MainError {
  ServerError({@required String error, StackTrace trace})
      : super(error: error, trace: trace);
}

class InvalidResponseError extends ServerError {
  InvalidResponseError(
      {String error = 'Неправильный ответ от сервера',
      @required StackTrace trace})
      : super(error: error, trace: trace);
}

class AuthorizationError extends ServerError {
  AuthorizationError(
      {String error = 'Ошибка авторизации', @required StackTrace trace})
      : super(error: error, trace: trace);
}
