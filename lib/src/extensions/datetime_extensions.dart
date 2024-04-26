import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  ///format datetime into a String in the format `YYYY-MM-DD`
  String formatDate() {
    return '$year-${NumberFormat('00').format(month)}-${NumberFormat('00').format(day)}';
  }

  ///format datetime into a String in the format `HH:mm`
  String formatTimeStart() {
    return '${NumberFormat('00').format(hour)}:${NumberFormat('00').format(minute)}';
  }

  ///format datetime into a String in the format `YYYY-MM-DD HH:mm`
  String formatDateTime() {
    return '$year-${NumberFormat('00').format(month)}-${NumberFormat('00').format(day)} ${NumberFormat('00').format(hour)}:${NumberFormat('00').format(minute)}';
  }

  ///format datetime into a String in the format `YYYY-MM-DD HH:mm`
  String formatDateTimeFull() {
    return '$year-${NumberFormat('00').format(month)}-${NumberFormat('00').format(day)} ${NumberFormat('00').format(hour)}:${NumberFormat('00').format(minute)}:${NumberFormat('00').format(second)}';
  }

  /// get week number from `DateTime`
  String formatWeekNumber() {
    // Calculate the day of the year (1-366)
    int dayOfYear = int.parse(DateFormat('D').format(this));

    // Calculate the weekday of January 4th (ISO-8601 defines this date to always be in week 1)
    DateTime jan4th = DateTime(year, 1, 4);
    int jan4thWeekday = jan4th.weekday;

    // Calculate the offset to get the first week starting on a Monday
    int offset = (jan4thWeekday <= 4) ? 5 - jan4thWeekday : 12 - jan4thWeekday;

    // Calculate the week number
    int weekNumber = ((dayOfYear + offset) ~/ 7) + 1;

    return weekNumber.toString();
  }

  ///Formats the dates with a week in the format of:
  ///
  ///- `d(start) - d(end) MMMM` if the week starts and ends with the `month`.
  ///
  ///- `d MMMM(start) - d MMMM(end)` else.
  String formatWeekDatesRage(String locale) {
    DateTime start = getStartOfWeek();
    DateTime end = getEndOfWeek();
    if (DateFormat.yM(locale).format(start) ==
        DateFormat.yM(locale).format(end)) {
      return '${DateFormat.d(locale).format(start)} - ${DateFormat.d(locale).format(end)} ${DateFormat.MMM(locale).format(start)}';
    } else {
      return '${DateFormat.d(locale).format(start)} ${DateFormat.MMM(locale).format(start)} - ${DateFormat.d(locale).format(end)} ${DateFormat.MMM(locale).format(end)}';
    }
  }

  /// get seven dates for week by `DateTime`.
  List<DateTime> getWeekDates() {
    // Find the starting day of the week (Sunday)
    DateTime startOfWeek = subtract(Duration(days: weekday - 1));

    // Generate a list of 7 dates starting from the startOfWeek
    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = startOfWeek.add(Duration(days: i));
      weekDates.add(currentDate);
    }

    return weekDates;
  }

  /// get start of the week for `DateTime`
  DateTime getStartOfWeek({int offset = 0}) {
    DateTime startOfWeek = subtract(Duration(days: weekday - 1));
    return startOfWeek.add(Duration(days: offset));
  }

  /// get end of the week for `DateTime`
  DateTime getEndOfWeek({int offset = 0}) {
    DateTime startOfWeek = subtract(Duration(days: weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return endOfWeek.add(Duration(days: offset));
  }
}
