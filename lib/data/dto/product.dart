import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit_demo/shared/constants.dart';

import 'dimension.dart';
import 'meta.dart';
import 'review.dart';

part 'product.g.dart';

Product deserializeProduct(JSON json) => Product.fromJson(json);
JSON serializeProduct(Product object) => object.toJson();

@JsonSerializable()
class Product {
  Product({
    this.id,
    this.label,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  @JsonKey(includeIfNull: false)
  final int? id;
  @JsonKey(name: 'title')
  String? label;
  String? description;
  final String? category;
  double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final List<String>? tags;
  final String? brand;
  final String? sku;
  int? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Review>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final Meta? meta;
  List<String>? images;
  final String? thumbnail;

  factory Product.fromJson(JSON json) => _$ProductFromJson(json);

  JSON toJson() => _$ProductToJson(this);
}
