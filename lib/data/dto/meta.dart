import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit_demo/shared/constants.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? barcode;
  final String? qrCode;

  factory Meta.fromJson(JSON json) => _$MetaFromJson(json);

  JSON toJson() => _$MetaToJson(this);
}
