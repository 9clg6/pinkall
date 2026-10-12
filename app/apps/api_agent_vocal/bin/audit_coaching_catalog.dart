import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/coaching_catalog_validator.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart run bin/audit_coaching_catalog.dart <catalog-directory>',
    );
    exitCode = 64;
    return;
  }
  final CoachingCatalogAuditReport report = const CoachingCatalogValidator()
      .validateDirectory(arguments.single);
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report.toJson()));
  if (!report.isValid) {
    exitCode = 2;
  }
}
