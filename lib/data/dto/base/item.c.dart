import 'package:retrofit_demo/shared/constants.dart';

import '../product.dart';
import 'item.dart';

XItem<Product> deserializeXItemProduct(JSON json) =>
    XItem.fromJson(json, (j) => Product.fromJson(j as JSON));

// JSON serializeXItemProductDto(XItem object) => object.toJson();
