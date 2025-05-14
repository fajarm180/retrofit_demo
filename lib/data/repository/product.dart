import 'dart:async';

import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/network/rest/api.dart';

class ProductRepo {
  ProductRepo();

  final _service = ApiService();

  FutureOr<List<Product>> getProducts({
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await ((query?.isNotEmpty ?? false)
        ? _service.searchProducts(
            query: query ?? '',
            limit: limit,
            skip: (page * limit) - limit,
          )
        : _service.getProducts(
            limit: limit,
            skip: (page * limit) - limit,
          ));

    return result.items;
  }

  FutureOr<Product> getProduct(int id) => _service.getProductById(id: id);

  FutureOr<void> addProduct(Product product) =>
      _service.createProduct(product: product);

  FutureOr<void> updateProduct(Product product) async =>
      _service.updateProduct(id: product.id ?? 0, product: product);

  FutureOr<void> deleteProduct(int id) async => _service.deleteProduct(id: id);
}
