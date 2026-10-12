import 'package:core_data/model/remote/call_eligibility.remote.model.dart';

/// Remote source for versioned outbound-call policy decisions.
abstract interface class CallEligibilityRemoteDataSource {
  /// Evaluates known call facts on the Pinkall backend.
  Future<CallEligibilityRemoteModel> evaluate(Map<String, dynamic> body);
}
