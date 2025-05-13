import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit_demo/data/dto/base/item.dart';
import 'package:retrofit_demo/data/dto/product.dart';
import 'package:retrofit_demo/data/network/rest/api.dart';

import 'api_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late ApiService service;

  setUpAll(() => service = MockApiService());

  group('#getProducts', () {
    test('Get Products Success Call', () async {
      when(service.getProducts()).thenAnswer(
        (realInvocation) async => XItem(items: [
          Product(id: 1, label: 'Product 1'),
          Product(id: 2, label: 'Product 2'),
        ]),
      );

      expect(
        await service.getProducts(),
        XItem(items: [
          Product(id: 1, label: 'Product 1'),
          Product(id: 2, label: 'Product 2'),
        ]),
      );
    });
  });

  group('#searchProducts', () {
    test('Search Products Success Call', () async {
      when(service.searchProducts(query: '')).thenAnswer(
        (realInvocation) async => XItem(items: [
          Product(id: 1, label: 'Product 1'),
          Product(id: 2, label: 'Product 2'),
        ]),
      );

      expect(
        await service.searchProducts(query: ''),
        XItem(items: [
          Product(id: 1, label: 'Product 1'),
          Product(id: 2, label: 'Product 2'),
        ]),
      );
    });
  });

  group('#getProductbyId', () {
    test('Get Products by Id Success Call', () async {
      when(service.getProductById(
        id: 1,
      )).thenAnswer(
        (realInvocation) async => Product(id: 1, label: 'Product 1'),
      );

      expect(
        await service.getProductById(id: 1),
        Product(id: 1, label: 'Product 1'),
      );
    });
  });

  group('#createProduct', () {
    test('Create Products Success Call', () async {
      when(service.createProduct(
        product: Product(id: 1, label: ''),
      )).thenAnswer(
        (realInvocation) async => Product(id: 1, label: ''),
      );

      expect(
        await service.createProduct(product: Product(id: 1, label: '')),
        Product(id: 1, label: ''),
      );
    });
  });

  group('#updateProduct', () {
    test('Update Products Success Call', () async {
      when(service.updateProduct(
        id: 1,
        product: Product(id: 1, label: ''),
      )).thenAnswer(
        (realInvocation) async => Product(id: 1, label: ''),
      );

      expect(
        await service.updateProduct(
          id: 1,
          product: Product(id: 1, label: ''),
        ),
        Product(id: 1, label: ''),
      );
    });
  });

  group('#deleteProduct', () {
    test('Delte Products Success Call', () {});
  });
}
