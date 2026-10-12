import 'package:core_domain/core_domain.dart';

/// Immutable presentation state for the minimal backend-backed CRM.
final class CrmState {
  /// Creates CRM state.
  const CrmState({
    required this.contacts,
    required this.isOperating,
    this.feedback,
    this.failure,
  });

  /// Contacts confirmed by the Pinkall backend.
  final List<ContactEntity> contacts;

  /// Whether a mutation or refresh is in flight.
  final bool isOperating;

  /// Latest server-confirmed result.
  final String? feedback;

  /// Latest explicit operation failure.
  final String? failure;

  /// Creates a changed CRM state.
  CrmState copyWith({
    List<ContactEntity>? contacts,
    bool? isOperating,
    String? feedback,
    String? failure,
    bool clearFeedback = false,
    bool clearFailure = false,
  }) {
    return CrmState(
      contacts: contacts ?? this.contacts,
      isOperating: isOperating ?? this.isOperating,
      feedback: clearFeedback ? null : feedback ?? this.feedback,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
