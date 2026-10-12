import 'package:core_domain/core_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/crm/data/contact_import_parser.dart';

void main() {
  test('parses CSV rows including quoted commas and eligibility facts', () {
    final List<ContactImportRowParam> rows = ContactImportParser.parse(
      'phone_number,first_name,company,market,professional_relevance\n'
      '+33123456789,Ada,"Pinkall, SAS",b2b,oui',
    );

    expect(rows, hasLength(1));
    expect(rows.single.phoneNumber, '+33123456789');
    expect(rows.single.company, 'Pinkall, SAS');
    expect(rows.single.market, ContactMarket.b2b);
    expect(rows.single.professionalRelevanceConfirmed, isTrue);
  });

  test('parses JSON contacts and rejects rows without phone numbers', () {
    final List<ContactImportRowParam> rows = ContactImportParser.parse(
      '[{"phone_number":"+33612345678","market":"b2c",'
      '"has_prior_consent":true}]',
    );

    expect(rows.single.market, ContactMarket.b2c);
    expect(rows.single.hasPriorConsent, isTrue);
    expect(
      () => ContactImportParser.parse('[{"first_name":"Sans numéro"}]'),
      throwsFormatException,
    );
  });
}
