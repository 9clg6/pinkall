/// Formats durations for the Pinkall presentation layer.
abstract final class DurationFormatter {
  /// Returns a clock value such as `02:14` or `01:02:14`.
  static String clock(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    final String minuteText = minutes.toString().padLeft(2, '0');
    final String secondText = seconds.toString().padLeft(2, '0');

    if (hours == 0) {
      return '$minuteText:$secondText';
    }

    final String hourText = hours.toString().padLeft(2, '0');
    return '$hourText:$minuteText:$secondText';
  }
}
