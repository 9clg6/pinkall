/// Converts a Dart enum value to the snake-case wire format used by Pinkall.
String enumToWireName(Enum value) {
  return value.name.replaceAllMapped(
    RegExp('([a-z0-9])([A-Z])'),
    (Match match) => '${match.group(1)}_${match.group(2)!.toLowerCase()}',
  );
}

/// Resolves a snake-case Pinkall wire value against [values].
T enumFromWireName<T extends Enum>(List<T> values, String wireName) {
  for (final T value in values) {
    if (enumToWireName(value) == wireName) {
      return value;
    }
  }
  throw FormatException('Unsupported ${T.toString()} value: $wireName.');
}
