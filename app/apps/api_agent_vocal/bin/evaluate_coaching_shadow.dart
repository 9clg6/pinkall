import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/application/coaching_shadow_evaluator.dart';
import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/coaching_catalog_validator.dart';

void main(List<String> arguments) {
  final Map<String, String> options = _parseOptions(arguments);
  final String? catalogDirectory = options['catalog'];
  final String? casesPath = options['cases'];
  final String? observationsPath = options['observations'];
  if (catalogDirectory == null ||
      casesPath == null ||
      observationsPath == null) {
    stderr.writeln(
      'Usage: dart run bin/evaluate_coaching_shadow.dart '
      '--catalog <directory> --cases <cases.json> '
      '--observations <observations.jsonl> [--enforce]',
    );
    exitCode = 64;
    return;
  }

  try {
    final CoachingCatalogAuditReport audit = const CoachingCatalogValidator()
        .validateDirectory(catalogDirectory);
    if (!audit.isValid) {
      stdout.writeln(
        const JsonEncoder.withIndent('  ').convert(<String, Object?>{
          'catalog_audit': audit.toJson(),
          'shadow_evaluation': null,
        }),
      );
      exitCode = 2;
      return;
    }

    final Map<String, Object?> casesDocument = _readObject(casesPath);
    final List<CoachingShadowCase> cases = _objectRows(
      casesDocument['cases'],
    ).map(CoachingShadowCase.fromJson).toList(growable: false);
    final List<CoachingShadowObservation> observations = File(observationsPath)
        .readAsLinesSync()
        .where((String line) => line.trim().isNotEmpty)
        .map((String line) {
          final Object? decoded = jsonDecode(line);
          if (decoded is! Map<String, Object?>) {
            throw const FormatException(
              'Every observations.jsonl line must contain an object.',
            );
          }
          return CoachingShadowObservation.fromJson(decoded);
        })
        .toList(growable: false);
    final CoachingShadowPolicy policy = CoachingShadowPolicy.fromJson(
      _readObject('$catalogDirectory/evaluation-policy.json'),
    );
    final Map<String, Set<String>> recommendationSources =
        <String, Set<String>>{};
    for (final Map<String, Object?> recommendation in _readRows(
      '$catalogDirectory/recommendations.json',
    )) {
      final String? id = _text(recommendation['id']);
      if (id != null) {
        recommendationSources[id] = _stringList(
          recommendation['source_ids'],
        ).toSet();
      }
    }
    final CoachingShadowEvaluationReport report =
        const CoachingShadowEvaluator().evaluate(
          cases: cases,
          observations: observations,
          recommendationSourceIds: recommendationSources,
          policy: policy,
        );
    stdout.writeln(
      const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'catalog_audit': audit.toJson(),
        'dataset': <String, Object?>{
          'version': casesDocument['dataset_version'],
          'status': casesDocument['dataset_status'],
        },
        'shadow_evaluation': report.toJson(),
      }),
    );
    if (options.containsKey('enforce') && !report.passesConfiguredGates) {
      exitCode = 3;
    }
  } on FileSystemException catch (error) {
    stderr.writeln('Shadow evaluation file error: ${error.message}');
    exitCode = 66;
  } on FormatException catch (error) {
    stderr.writeln('Shadow evaluation data error: ${error.message}');
    exitCode = 65;
  }
}

Map<String, String> _parseOptions(List<String> arguments) {
  final Map<String, String> result = <String, String>{};
  for (int index = 0; index < arguments.length; index += 1) {
    final String argument = arguments[index];
    if (argument == '--enforce') {
      result['enforce'] = 'true';
      continue;
    }
    if (!argument.startsWith('--') || index + 1 >= arguments.length) {
      continue;
    }
    result[argument.substring(2)] = arguments[index + 1];
    index += 1;
  }
  return result;
}

Map<String, Object?> _readObject(String path) {
  final Object? decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('$path must contain a JSON object.');
  }
  return decoded;
}

List<Map<String, Object?>> _readRows(String path) {
  final Object? decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! List<Object?>) {
    throw FormatException('$path must contain a JSON array.');
  }
  return _objectRows(decoded);
}

List<Map<String, Object?>> _objectRows(Object? value) {
  if (value is! List<Object?>) {
    return const <Map<String, Object?>>[];
  }
  return value.whereType<Map<String, Object?>>().toList(growable: false);
}

String? _text(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }
  return value.trim();
}

List<String> _stringList(Object? value) {
  if (value is! List<Object?>) {
    return const <String>[];
  }
  return value.whereType<String>().toList(growable: false);
}
