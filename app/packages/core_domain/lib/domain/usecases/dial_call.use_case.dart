import 'package:core_domain/domain/params/dial_call.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Places an outbound Telnyx call.
final class DialCallUseCase
    extends FutureUseCaseWithParams<String, DialCallParam> {
  /// Creates the use case with its [callRepository].
  DialCallUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<String> invoke(DialCallParam params) {
    return _callRepository.dial(
      destinationNumber: params.destinationNumber,
      clientState: params.clientState,
      customHeaders: params.customHeaders,
    );
  }
}
