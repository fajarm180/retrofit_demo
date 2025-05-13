import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit_demo/data/dto/base/item.dart';
import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/network/constants.dart';
import 'package:retrofit_demo/data/network/provider/auth_provider.dart';

part 'api.g.dart';

@RestApi(
  baseUrl: 'https://dummyjson.com',
  parser: Parser.FlutterCompute,
)
abstract class ApiService {
  factory ApiService({Dio? dio, String? baseURL}) {
    final d = dio ?? Dio();

    d.interceptors.addAll([
      AuthorizeProvider(),
    ]);

    if (kDebugMode) {
      d.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
      ));
    }

    return _ApiService(d, baseUrl: baseURL);
  }

  @Authorization
  @GET('/products')
  Future<XItem<Product>> getProducts({
    @Queries() Map<String, dynamic>? queries,
    @Query('limit') int limit = 10,
    @Query('skip') int skip = 0,
    @Query('select') String? select,
  });

  @GET('/products/search')
  Future<XItem<Product>> searchProducts({
    @Query('q') required String query,
    @Query('limit') int limit = 10,
    @Query('skip') int skip = 0,
  });

  @GET('/products/{id}')
  Future<Product> getProductById({
    @Path('id') required int id,
  });

  @POST('/products')
  Future<Product> createProduct({
    @Body() required Product product,
  });

  @PUT('/products/{id}')
  Future<Product> updateProduct({
    @Path('id') required int id,
    @Body() required Product product,
  });

  @DELETE('/products/{id}')
  Future<void> deleteProduct({
    @Path('id') required int id,
  });
}
