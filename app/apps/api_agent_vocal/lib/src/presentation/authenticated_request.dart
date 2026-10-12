import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:shelf/shelf.dart';

/// Request context key reserved for the verified Pinkall principal.
const String authPrincipalContextKey = 'pinkall.auth_principal';

/// Authenticated request accessors used by protected transport handlers.
extension AuthenticatedRequestX on Request {
  /// Returns the verified workspace-bound principal.
  ///
  /// Protected handlers fail closed if middleware composition is bypassed.
  AuthPrincipal get authPrincipal {
    final Object? value = context[authPrincipalContextKey];
    if (value is! AuthPrincipal) {
      throw StateError(
        'A protected Pinkall request has no authenticated principal.',
      );
    }
    return value;
  }
}
