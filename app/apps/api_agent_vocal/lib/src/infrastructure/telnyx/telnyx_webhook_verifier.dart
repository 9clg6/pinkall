import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// Authentication failure for a public Telnyx webhook.
final class TelnyxWebhookVerificationException implements Exception {
  const TelnyxWebhookVerificationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Verifies Telnyx's Ed25519 signature over `timestamp|raw_json_payload`.
final class TelnyxWebhookVerifier {
  TelnyxWebhookVerifier({
    required String? publicKey,
    DateTime Function()? now,
    this.tolerance = const Duration(minutes: 5),
  }) : _publicKey = publicKey,
       _now = now ?? DateTime.now;

  final String? _publicKey;
  final DateTime Function() _now;
  final Duration tolerance;
  final Ed25519 _algorithm = Ed25519();

  bool get isConfigured => _publicKey != null && _publicKey.trim().isNotEmpty;

  Future<void> verify({
    required String rawBody,
    required String? signatureHeader,
    required String? timestampHeader,
  }) async {
    if (!isConfigured) {
      throw const TelnyxWebhookVerificationException(
        'TELNYX_PUBLIC_KEY is not configured.',
      );
    }
    final int? timestamp = int.tryParse(timestampHeader ?? '');
    if (timestamp == null) {
      throw const TelnyxWebhookVerificationException(
        'Missing or invalid Telnyx timestamp.',
      );
    }
    final int nowSeconds = _now().toUtc().millisecondsSinceEpoch ~/ 1000;
    if ((nowSeconds - timestamp).abs() > tolerance.inSeconds) {
      throw const TelnyxWebhookVerificationException(
        'Telnyx webhook timestamp is outside the five-minute window.',
      );
    }
    late final List<int> signatureBytes;
    try {
      signatureBytes = base64Decode(signatureHeader ?? '');
    } on FormatException {
      throw const TelnyxWebhookVerificationException(
        'Invalid Telnyx signature encoding.',
      );
    }
    if (signatureBytes.length != 64) {
      throw const TelnyxWebhookVerificationException(
        'Invalid Telnyx signature length.',
      );
    }
    final List<int> publicKeyBytes = _decodePublicKey(_publicKey!);
    late final bool valid;
    try {
      valid = await _algorithm.verify(
        utf8.encode('$timestampHeader|$rawBody'),
        signature: Signature(
          signatureBytes,
          publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
        ),
      );
    } on Object {
      throw const TelnyxWebhookVerificationException(
        'Invalid Telnyx webhook signature.',
      );
    }
    if (!valid) {
      throw const TelnyxWebhookVerificationException(
        'Invalid Telnyx webhook signature.',
      );
    }
  }

  static List<int> _decodePublicKey(String input) {
    final String trimmed = input.trim();
    if (RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(trimmed)) {
      return List<int>.generate(
        32,
        (int index) =>
            int.parse(trimmed.substring(index * 2, index * 2 + 2), radix: 16),
        growable: false,
      );
    }
    final String normalized = trimmed
        .replaceAll(RegExp(r'-----BEGIN PUBLIC KEY-----'), '')
        .replaceAll(RegExp(r'-----END PUBLIC KEY-----'), '')
        .replaceAll(RegExp(r'\s+'), '');
    try {
      final List<int> decoded = base64Decode(normalized);
      if (decoded.length == 32) {
        return decoded;
      }
      // RFC 8410 SubjectPublicKeyInfo wrapping for an Ed25519 raw key.
      if (decoded.length == 44) {
        return decoded.sublist(12);
      }
    } on FormatException {
      // Converted into a provider-specific verification failure below.
    }
    throw const TelnyxWebhookVerificationException(
      'TELNYX_PUBLIC_KEY must be a raw Base64/hex Ed25519 key or PEM.',
    );
  }
}
