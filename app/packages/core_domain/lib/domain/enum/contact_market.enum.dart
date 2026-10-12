import 'package:json_annotation/json_annotation.dart';

/// Market relationship used when evaluating outbound-call eligibility.
@JsonEnum(fieldRename: FieldRename.snake)
enum ContactMarket {
  /// A professional or business prospect.
  b2b,

  /// An individual acting as a consumer.
  b2c,

  /// The relationship has not been qualified yet.
  unknown,
}
