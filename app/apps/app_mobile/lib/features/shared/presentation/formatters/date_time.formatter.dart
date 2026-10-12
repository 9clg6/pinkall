/// Formats local dates without introducing business logic in screens.
abstract final class DateTimeFormatter {
  /// Returns a compact numeric date and time.
  static String compact(DateTime dateTime) {
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month · $hour:$minute';
  }
}
