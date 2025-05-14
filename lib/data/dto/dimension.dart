import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit_demo/shared/constants.dart';

part 'dimension.g.dart';

@JsonSerializable()
class Dimensions {
  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  double? width;
  double? height;
  double? depth;

  factory Dimensions.fromJson(JSON json) => _$DimensionsFromJson(json);

  JSON toJson() => _$DimensionsToJson(this);
}
