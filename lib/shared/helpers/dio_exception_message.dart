import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class DioExceptionHandler {
  DioExceptionHandler() {
    const path = 'assets/jsons/error_message.json';
    rootBundle.loadString(path).then((value) {
      maps = jsonDecode(value) as JSON;
    });
  }

  JSON maps = <String, dynamic>{};

  Map<String, dynamic>? onException(DioException error) {
    final exceptionMessage = {
      DioExceptionType.connectionError: maps['connection_error'],
      DioExceptionType.connectionTimeout: maps['connection_timeout'],
      DioExceptionType.receiveTimeout: maps['receive_timeout'],
      DioExceptionType.sendTimeout: maps['send_timeout'],
      DioExceptionType.cancel: maps['cancel'],
      DioExceptionType.unknown: maps['unknown'],
    };

    final message = ((exceptionMessage[error.type] != null)
        ? exceptionMessage[error.type]
        : maps[error.response?.statusCode.toString()]) as JSON;

    return message;
  }
}
