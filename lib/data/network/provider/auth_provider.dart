import 'dart:io';

import 'package:dio/dio.dart';

class AuthorizeProvider extends Interceptor {
  AuthorizeProvider();

  static const _authorizationKey = 'authorization';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    });

    final authorized = options.extra[_authorizationKey].toString();
    if (!(bool.tryParse(authorized) ?? false)) {
      options.extra.remove(_authorizationKey);

      return super.onRequest(options, handler);
    }

    final tokenStorage = '';
    if (tokenStorage.isEmpty) return handler.next(options);

    final token = tokenStorage;

    options.headers.addAll({
      HttpHeaders.cookieHeader: 'resource=$token',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    return super.onRequest(options, handler);
  }
}
