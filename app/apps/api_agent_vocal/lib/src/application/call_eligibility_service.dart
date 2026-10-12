/// Conservative target-policy gate for outbound calls in France.
final class CallEligibilityService {
  const CallEligibilityService();

  Map<String, Object?> evaluate(Map<String, Object?> input) {
    final String phoneNumber = _text(input['phone_number']) ?? '';
    final String market = (_text(input['market']) ?? 'unknown').toLowerCase();
    final String countryCode = (_text(input['country_code']) ?? 'FR')
        .toUpperCase();
    final bool? priorConsent = input['has_prior_consent'] is bool
        ? input['has_prior_consent']! as bool
        : null;
    final bool optedOut = input['has_opted_out'] == true;
    final bool professionalRelevance =
        input['professional_relevance_confirmed'] == true;
    final List<String> reasons = <String>[];
    String status = 'eligible';

    if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(phoneNumber)) {
      status = 'ineligible';
      reasons.add('phone_number_invalid');
    } else if (optedOut) {
      status = 'ineligible';
      reasons.add('opted_out');
    } else if (countryCode != 'FR') {
      status = 'review_required';
      reasons.add('policy_unavailable');
    } else if (market == 'unknown') {
      status = 'review_required';
      reasons.add('market_unknown');
    } else if (market == 'b2c' && priorConsent != true) {
      // The product enforces the 11 August 2026 target policy now so a caller
      // cannot accidentally build a future-illegal B2C list.
      status = 'ineligible';
      reasons.add('b2c_consent_missing');
    } else if (market == 'b2b' && !professionalRelevance) {
      status = 'ineligible';
      reasons.add('professional_relevance_missing');
    } else if (market != 'b2b' && market != 'b2c') {
      status = 'review_required';
      reasons.add('market_unknown');
    }

    return <String, Object?>{
      'contact_id': _text(input['contact_id']),
      'status': status,
      'reasons': reasons,
      'checked_at': DateTime.now().toUtc().toIso8601String(),
      'policy_version': 'fr-2026-08-11',
      'eligible': status == 'eligible',
      'disclaimer':
          'Decision-support only. The caller remains responsible for legal '
          'basis, evidence, sector rules and suppression lists.',
    };
  }

  static String? _text(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
