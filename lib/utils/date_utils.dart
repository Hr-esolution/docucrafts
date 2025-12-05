class DateUtils {
  /// Format a DateTime to a readable string
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Format a DateTime to a string with time
  static String formatDateTimeWithTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get today's date in dd/MM/yyyy format
  static String getTodayDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  /// Check if a date is in the future
  static bool isFutureDate(DateTime date) {
    final today = DateTime.now();
    return date.isAfter(today);
  }

  /// Check if a date is in the past
  static bool isPastDate(DateTime date) {
    final today = DateTime.now();
    return date.isBefore(today);
  }
}