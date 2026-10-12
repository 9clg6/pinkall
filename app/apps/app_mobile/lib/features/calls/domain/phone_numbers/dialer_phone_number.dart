/// Normalizes a number entered in the dialer before validation and dialing.
///
/// French mobile numbers entered in their familiar national form (`06` or
/// `07`) are converted to E.164. International numbers keep their country
/// code; the standard `00` international prefix is accepted as an alternative
/// to `+`.
String normalizeDialerPhoneNumber(String value) {
  String normalized = value.trim().replaceAll(RegExp(r'[\s().-]'), '');

  if (normalized.startsWith('00')) {
    normalized = '+${normalized.substring(2)}';
  }

  if (RegExp(r'^0[67]\d{8}$').hasMatch(normalized)) {
    return '+33${normalized.substring(1)}';
  }

  // `+33 (0)6 ...` is a common human-readable French representation. The
  // trunk prefix must not be sent once the number is in international form.
  if (RegExp(r'^\+330[67]\d{8}$').hasMatch(normalized)) {
    return '+33${normalized.substring(4)}';
  }

  return normalized;
}

/// Whether [value] becomes a valid E.164 destination after normalization.
bool isValidDialerPhoneNumber(String value) =>
    RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(normalizeDialerPhoneNumber(value));
