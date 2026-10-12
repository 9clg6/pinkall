import 'package:pinkall/features/calls/domain/phone_numbers/dialer_phone_number.dart';

/// A supported Pinkall link that opens the call composer.
final class CallDeepLink {
  /// Creates a call link with its normalized E.164 [phoneNumber].
  const CallDeepLink({required this.phoneNumber});

  /// The E.164 number to prefill in the call composer.
  final String phoneNumber;
}

/// Parses [uri] when it targets Pinkall's call composer with a valid number.
///
/// Supported locations are `pinkall://call` and
/// `https://www.pinkall.app/call`. The `number` query value may use either an
/// encoded or a literal `+`, and is normalized with the dialer's rules.
CallDeepLink? parseCallDeepLink(Uri uri) {
  if (!_isSupportedCallLocation(uri)) {
    return null;
  }

  final String? rawPhoneNumber = _singleNumberQueryValue(uri);
  if (rawPhoneNumber == null || !isValidDialerPhoneNumber(rawPhoneNumber)) {
    return null;
  }

  return CallDeepLink(phoneNumber: normalizeDialerPhoneNumber(rawPhoneNumber));
}

bool _isSupportedCallLocation(Uri uri) {
  if (uri.userInfo.isNotEmpty || uri.hasPort) {
    return false;
  }

  final String scheme = uri.scheme.toLowerCase();
  final String host = uri.host.toLowerCase();

  if (scheme == 'pinkall') {
    return host == 'call' && uri.path.isEmpty;
  }

  if (scheme == 'https') {
    return host == 'www.pinkall.app' && uri.path == '/call';
  }

  return false;
}

String? _singleNumberQueryValue(Uri uri) {
  final List<String> rawValues = <String>[];

  for (final String component in uri.query.split('&')) {
    final int separatorIndex = component.indexOf('=');
    final String rawKey = separatorIndex < 0
        ? component
        : component.substring(0, separatorIndex);

    late final String key;
    try {
      key = Uri.decodeQueryComponent(rawKey);
    } on FormatException {
      return null;
    }

    if (key != 'number') {
      continue;
    }
    if (separatorIndex < 0) {
      return null;
    }

    rawValues.add(component.substring(separatorIndex + 1));
  }

  if (rawValues.length != 1 || rawValues.single.isEmpty) {
    return null;
  }

  try {
    // `decodeComponent` deliberately preserves a literal `+`. Standard query
    // decoding would turn it into a space and reject common manually-built
    // deep links such as `?number=+33612345678`.
    return Uri.decodeComponent(rawValues.single);
  } on FormatException {
    return null;
  }
}
