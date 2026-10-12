import 'package:json_annotation/json_annotation.dart';

/// Outcome recorded for a completed or attempted call.
@JsonEnum(fieldRename: FieldRename.snake)
enum CallOutcomeType {
  /// No outcome has been qualified yet.
  unknown,

  /// The prospect did not answer.
  noAnswer,

  /// The call reached voicemail.
  voicemail,

  /// A follow-up action is expected.
  followUp,

  /// A meeting was booked.
  meetingBooked,

  /// The prospect is not interested.
  notInterested,

  /// The prospect does not meet qualification criteria.
  disqualified,

  /// The commercial opportunity was won.
  won,

  /// The commercial opportunity was lost.
  lost,
}
