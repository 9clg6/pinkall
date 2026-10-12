import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

final Expando<Set<String>> _trustedCertificatePins = Expando<Set<String>>(
  'postgres trusted certificate pins',
);

/// Records the certificates loaded into [context] so that a managed server
/// chain containing its own trusted root can be handled without disabling TLS
/// authentication globally.
void registerTrustedCertificatePins(SecurityContext context, String path) {
  final List<int> bytes = File(path).readAsBytesSync();
  final Set<String> pins = <String>{};
  try {
    final String pem = utf8.decode(bytes);
    final RegExp certificateBlock = RegExp(
      r'-----BEGIN CERTIFICATE-----(.*?)-----END CERTIFICATE-----',
      dotAll: true,
    );
    for (final RegExpMatch match in certificateBlock.allMatches(pem)) {
      final String encoded = match.group(1)!.replaceAll(RegExp(r'\s'), '');
      pins.add(sha256.convert(base64Decode(encoded)).toString());
    }
  } on FormatException {
    // A non-PEM certificate may be DER encoded. Pin its exact bytes below.
  }
  if (pins.isEmpty) {
    pins.add(sha256.convert(bytes).toString());
  }
  _trustedCertificatePins[context] = Set<String>.unmodifiable(pins);
}

/// Returns true only when [certificate] is byte-for-byte one of the explicit
/// trust anchors loaded from sslrootcert.
bool matchesTrustedCertificatePin(
  SecurityContext? context,
  X509Certificate certificate,
) {
  if (context == null) return false;
  final Set<String>? pins = _trustedCertificatePins[context];
  if (pins == null) return false;
  return pins.contains(sha256.convert(certificate.der).toString());
}
