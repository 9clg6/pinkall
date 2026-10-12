import 'package:api_agent_vocal/src/application/call_eligibility_service.dart';
import 'package:test/test.dart';

void main() {
  const CallEligibilityService service = CallEligibilityService();

  test('returns the core_data B2C consent contract', () {
    final Map<String, Object?> result = service.evaluate(<String, Object?>{
      'phone_number': '+33601020304',
      'market': 'b2c',
      'has_prior_consent': false,
      'country_code': 'FR',
    });

    expect(result['status'], 'ineligible');
    expect(result['reasons'], contains('b2c_consent_missing'));
    expect(result['checked_at'], isA<String>());
    expect(result['policy_version'], 'fr-2026-08-11');
  });

  test('allows B2C only when prior consent is asserted', () {
    final Map<String, Object?> result = service.evaluate(<String, Object?>{
      'phone_number': '+33601020304',
      'market': 'b2c',
      'has_prior_consent': true,
      'country_code': 'FR',
    });

    expect(result['status'], 'eligible');
  });

  test('requires professional relevance for B2B', () {
    final Map<String, Object?> result = service.evaluate(<String, Object?>{
      'phone_number': '+33101020304',
      'market': 'b2b',
      'professional_relevance_confirmed': false,
      'country_code': 'FR',
    });

    expect(result['status'], 'ineligible');
    expect(result['reasons'], contains('professional_relevance_missing'));
  });
}
