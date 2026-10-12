import 'package:json_annotation/json_annotation.dart';

/// Stable speaker roles used independently from an STT provider.
@JsonEnum(fieldRename: FieldRename.snake)
enum TranscriptSpeaker {
  /// The Pinkall user or seller.
  seller,

  /// The called person or prospect.
  prospect,

  /// A speaker that could not be assigned safely.
  unknown,
}
