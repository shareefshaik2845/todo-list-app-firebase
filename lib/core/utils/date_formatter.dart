// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) return 'Today';
    if (taskDate == tomorrow) return 'Tomorrow';
    if (taskDate.isBefore(today)) return 'Overdue · ${DateFormat('MMM d').format(date)}';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy · hh:mm a').format(date);
  }

  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }
}
