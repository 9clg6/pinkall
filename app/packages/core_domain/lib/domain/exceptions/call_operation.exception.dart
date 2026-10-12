import 'package:core_domain/domain/enum/call_failure_code.enum.dart';

/// Safe, structured failure produced by a calling operation.
final class CallOperationException implements Exception {
  /// Creates a failure carrying the stable domain [code].
  const CallOperationException({required this.code});

  /// Machine-readable failure code suitable for presentation mapping.
  final CallFailureCode code;

  @override
  String toString() => 'CallOperationException(code: ${code.name})';
}
