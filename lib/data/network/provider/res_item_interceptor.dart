import 'package:dio/dio.dart';
import 'package:retrofit_demo/shared/constants.dart';

class ResItemInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final paths = response.realUri.pathSegments;
    final key = paths.firstWhere(
      (e) => (response.data as JSON).containsKey(e),
      orElse: () => '',
    );

    if (key.isNotEmpty) response.data['items'] = response.data[key];

    super.onResponse(response, handler);
  }
}
