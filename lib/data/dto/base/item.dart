import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit_demo/shared/constants.dart';

export 'item.c.dart';

part 'item.g.dart';

Object? _itemMapper(json, field) {
  final keys = [
    'products',
  ];

  final key = keys.firstWhere((e) => json.containsKey(e), orElse: () => '');
  return key.isNotEmpty ? json[key] : [];
}

@JsonSerializable(
  createToJson: false,
  genericArgumentFactories: true,
)
class XItem<T> {
  XItem({
    this.items = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 10,
  });

  @JsonKey(defaultValue: [], readValue: _itemMapper)
  final List<T> items;
  final int total;
  final int skip;
  final int limit;

  factory XItem.fromJson(JSON json, T Function(Object? json) fromJsonT) =>
      _$XItemFromJson(json, fromJsonT);
}
