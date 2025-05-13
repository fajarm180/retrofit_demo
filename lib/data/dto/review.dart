import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit_demo/shared/constants.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  final int? rating;
  final String? comment;
  final DateTime? date;
  final String? reviewerName;
  final String? reviewerEmail;

  factory Review.fromJson(JSON json) => _$ReviewFromJson(json);

  JSON toJson() => _$ReviewToJson(this);
}
