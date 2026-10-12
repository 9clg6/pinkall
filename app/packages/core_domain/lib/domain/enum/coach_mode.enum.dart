import 'package:json_annotation/json_annotation.dart';

/// Controls whether coaching is disabled, evaluated silently, or shown live.
@JsonEnum(fieldRename: FieldRename.snake)
enum CoachMode {
  /// No coaching work is requested for the call.
  off,

  /// Suggestions are evaluated by the backend but hidden from the caller.
  shadow,

  /// Eligible suggestions are delivered to the caller during the call.
  live,
}
