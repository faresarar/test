import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../extensions.dart';

class DateTimeUtils {
  final BuildContext context;

  DateTimeUtils(this.context);

  static DateTimeUtils of(BuildContext context) {
    assert(context.mounted);
    return DateTimeUtils(context);
  }

  /// return `true` if [datetime1] and [datetime2] are in the same year.
  static bool isSameYear(DateTime datetime1, DateTime datetime2) =>
      datetime1.year == datetime2.year;

  /// return `true` if [datetime1] and [datetime2] are in the same month.
  static bool isSameMonth(DateTime datetime1, DateTime datetime2) =>
      datetime1.year == datetime2.year && datetime1.month == datetime2.month;

  /// returns the difference between [after] and [before] in days.
  static int differenceInDays(DateTime before, DateTime after) {
    return after.difference(before).inDays;
  }

  /// return `true` if [datetime1] and [datetime2] are in the same day.
  static bool isSameDay(DateTime datetime1, DateTime datetime2) =>
      datetime1.day == datetime2.day &&
      datetime1.month == datetime2.month &&
      datetime1.year == datetime2.year;

  /// return `true` if [difference] is within 7 days
  static bool isSameWeek(Duration difference) => (difference.inDays).abs() < 7;

  String getLanguageCode() => Localizations.localeOf(context).languageCode;

  ///Takes [date] to format the input into a date and time value.
  /// -  if [showYear] is false, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  /// -  if [date] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  /// -  else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  String formatDate({
    required DateTime date,
    bool showYear = true,
  }) {
    String locale = getLanguageCode();
    if (!showYear) return DateFormat.MMMd(locale).format(date);
    final DateTime now = DateTime.now();
    if (isSameYear(now, date)) {
      return DateFormat.MMMd(locale).format(date);
    }
    return DateFormat.yMMMd(locale).format(date);
  }

  // ///Takes [milliseconds] to format the input into a date and time value.
  // ///- if [milliseconds] is within an hour, format as `m` (e.g. 1m).
  // ///- if [milliseconds] is in the same day, format as `h` (e.g. 1h).
  // ///- if [milliseconds] is in the same week, format as `d` (e.g. 1d).
  // ///- if ![showFullDate] return null,
  // ///- if [milliseconds] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  // ///- else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  // String? formatElapsedFromMilliseconds(
  //   int milliseconds, [
  //   bool showFullDate = true,
  // ]) {
  //   DateTime datetime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  //   return formatElapsed(datetime, showFullDate);
  // }

  // ///Takes [milliseconds] to format the input into a date and time value.
  // ///- if [milliseconds] is within an hour, format as `m ago` (e.g. 1m ago).
  // ///- if [milliseconds] is in the same day, format as `h ago` (e.g. 1h ago).
  // ///- if [milliseconds] is in the same week, format as `d ago` (e.g. 1d ago).
  // ///- if ![showFullDate] return null,
  // ///- if [milliseconds] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  // ///- else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  // String? formatElapsedAgoFromMilliseconds(
  //   int milliseconds, [
  //   bool showFullDate = true,
  // ]) {
  //   DateTime datetime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  //   return formatElapsedAgo(datetime, showFullDate);
  // }

  // ///Takes [context] and [datetime] to format the input into a date and time value.
  // ///- if [datetime] is within an hour, format as `m ago` (e.g. 1m ago).
  // ///- if [datetime] is in the same day, format as `h ago` (e.g. 1h ago).
  // ///- if [datetime] is in the same week, format as `d ago` (e.g. 1d ago).
  // ///- if ![showFullDate] return null,
  // ///- if [datetime] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  // ///- else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  // String? formatElapsedAgo(
  //   DateTime datetime, [
  //   bool showFullDate = true,
  // ]) {
  //   final DateTime now = DateTime.now();
  //   String locale = getLanguageCode();
  //   final Duration diff = now.difference(datetime);
  //   final inMinutes = diff.inMinutes;
  //   if (inMinutes < 1) {
  //     return AppLocalizations.of(context)!.moments_ago;
  //   }
  //   if (diff.inHours < 1) {
  //     return AppLocalizations.of(context)!.m_ago(inMinutes);
  //   }
  //   final inHours = diff.inHours;
  //   if (diff.inHours < 24) {
  //     return AppLocalizations.of(context)!.h_ago(inHours);
  //   }
  //   final inDays = diff.inDays;
  //   if (isSameWeek(diff)) {
  //     return AppLocalizations.of(context)!.d_ago(inDays);
  //   }
  //   if (!showFullDate) return null;
  //   if (isSameYear(now, datetime)) {
  //     return DateFormat.MMMd(locale).format(datetime);
  //   }
  //   return DateFormat.yMMMd(locale).format(datetime);
  // }

  // ///Takes [context] and [datetime] to format the input into a date and time value.
  // ///- if [datetime] is within an hour, format as `m` (e.g. 1m).
  // ///- if [datetime] is in the same day, format as `h` (e.g. 1h).
  // ///- if [datetime] is in the same week, format as `d` (e.g. 1d).
  // ///- if ![showFullDate] return null,
  // ///- if [datetime] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  // ///- else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  // String? formatElapsed(
  //   DateTime datetime, [
  //   bool showFullDate = true,
  // ]) {
  //   final DateTime now = DateTime.now();
  //   String locale = getLanguageCode();
  //   final Duration diff = now.difference(datetime);
  //   final inMinutes = diff.inMinutes;
  //   if (inMinutes < 1) {
  //     if (showFullDate) {
  //       return AppLocalizations.of(context)!.moments_ago;
  //     } else {
  //       return '<${AppLocalizations.of(context)!.m(1)}';
  //     }
  //   }
  //   if (diff.inHours < 1) {
  //     return AppLocalizations.of(context)!.m(inMinutes);
  //   }
  //   final inHours = diff.inHours;
  //   if (diff.inHours < 24) {
  //     return AppLocalizations.of(context)!.h(inHours);
  //   }
  //   final inDays = diff.inDays;
  //   if (isSameWeek(diff)) {
  //     return AppLocalizations.of(context)!.d(inDays);
  //   }
  //   if (!showFullDate) return null;
  //   if (isSameYear(now, datetime)) {
  //     return DateFormat.MMMd(locale).format(datetime);
  //   }
  //   return DateFormat.yMMMd(locale).format(datetime);
  // }

  /// Takes [datetime] and format it as `HOUR24_MINUTE` or `Hm` and force 24 hour time (e.g. 16:35).
  String formatToHour(DateTime datetime) {
    String locale = getLanguageCode();
    return DateFormat.Hm(locale).format(datetime);
  }

  /// Takes [datetime] and format it as `ABBR_WEEKDAY` or `E` (e.g. Sun).
  String formatToDay(DateTime datetime) {
    String locale = getLanguageCode();
    return DateFormat.E(locale).format(datetime);
  }

  /// Takes [datetime] and format it as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  String formatToMonthDay(DateTime datetime) {
    String locale = getLanguageCode();
    return DateFormat.MMMd(locale).format(datetime);
  }

  /// Takes [datetime] and format it as `YEAR` or `y` (e.g. Jul 2023).
  String formatToYear(DateTime datetime) {
    String locale = getLanguageCode();
    return DateFormat.y(locale).format(datetime);
  }

  ///Format [datetime] to a date and time value. Show time only if [datetime] is in the same day.
  /// -  if [datetime] is in the same day, format as `HOUR24_MINUTE` or `Hm` (e.g. 17:37).
  /// -  if [datetime] is in the same week, format as `ABBR_WEEKDAY` or `E (e.g. Sun).
  /// -  if [datetime] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` (e.g. Jul 22).
  /// -  else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  String formatShort(DateTime datetime) {
    String locale = getLanguageCode();
    if (isSameYear(DateTime.now(), datetime)) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(datetime);
      if (isSameDay(now, datetime)) {
        return DateFormat.Hm(locale).format(datetime);
      } else if (isSameWeek(difference)) {
        return DateFormat.E(locale).format(datetime);
      } else {
        return DateFormat.MMMd(locale).format(datetime);
      }
    } else {
      return DateFormat.yMd(getLanguageCode()) //2/5/2023
          .format(datetime);
    }
  }

  ///Format [datetime] to a date and time value. Hide time only when [datetime] is in a different year
  /// -  if [datetime] is in the same day, format as `HOUR24_MINUTE` or `Hm` (e.g. 17:37).
  /// -  if [datetime] is in the same week, format as `ABBR_WEEKDAY` or `E` Hm (e.g. Sun 13:45).
  /// -  if [datetime] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` Hm (e.g. Jul 22 13:45).
  /// -  else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` (e.g. Jul 22, 2022).
  String format(DateTime datetime) {
    final DateTime now = DateTime.now();
    String locale = getLanguageCode();
    if (isSameDay(now, datetime)) {
      return DateFormat.Hm(locale).format(datetime);
    }
    if (isSameWeek(datetime.difference(now))) {
      return DateFormat.E(locale).add_Hm().format(datetime);
    } else {
      if (isSameYear(now, datetime)) {
        return DateFormat.MMMd(locale).add_Hm().format(datetime);
      }
      return DateFormat.yMMMd(locale).format(datetime);
    }
  }

  ///Format [datetime] to a date and time value. Always show time.
  /// -  if [datetime] is in the same year, format as `MMMEd Hm (e.g. Wed, Apr 22 13:45)`.
  /// -  else, format as `yMMMEd Hm (e.g. Wed, Apr 22 2023 13:45)`.
  String formatLong(DateTime datetime) {
    final DateTime now = DateTime.now();
    String locale = getLanguageCode();
    if (isSameYear(now, datetime)) {
      return DateFormat.MMMEd(locale).add_Hm().format(datetime);
    }
    return DateFormat.yMMMEd(locale).add_Hm().format(datetime);
  }

  // ///Format [datetime] to a date and time value. Always show time.
  // /// -  if [datetime] is in the same day, format as `HOUR24_MINUTE` or `Hm` (e.g. 17:37).
  // /// -  if [datetime] is within a week, format as `ABBR_WEEKDAY` or `E` at Hm (e.g. Sun at 17:37).
  // /// -  if [datetime] is in the same year, format as `ABBR_MONTH_DAY` or `MMMd` at Hm (e.g. Jul 22 at 17:37).
  // /// -  else, format as `YEAR_ABBR_MONTH_DAY` or `yMMMd` at jm (e.g. Jul 22, 2022 at 17:37).
  // String formatLongWithAt(
  //   DateTime datetime,
  // ) {
  //   final DateTime now = DateTime.now();
  //   String locale = getLanguageCode();
  //   if (isSameDay(now, datetime)) {
  //     return DateFormat.Hm(locale).format(datetime);
  //   }
  //   if (isSameWeek(datetime.difference(now))) {
  //     return AppLocalizations.of(context)!.date_at_time(
  //       DateFormat.E(locale).format(datetime),
  //       DateFormat.Hm(locale).format(datetime),
  //     );
  //   } else {
  //     if (isSameYear(now, datetime)) {
  //       return AppLocalizations.of(context)!.date_at_time(
  //         DateFormat.MMMd(locale).format(datetime),
  //         DateFormat.Hm(locale).format(datetime),
  //       );
  //     }
  //     return DateFormat.yMMMd(locale).format(datetime);
  //   }
  // }

  ///Format [datetime] to `HOUR24_MINUTE` or `Hm` (e.g. 17:37).
  String formatTime(DateTime datetime) {
    return DateFormat.Hm(getLanguageCode()).format(datetime);
  }

  ///Takes [initialMonths] and [weekPage] returns a `Set<DateTime>` of unfetched dates.
  static Set<DateTime> getMonthsInWeek({
    required Set<DateTime> initialMonths,
    required int weekPage,
  }) {
    Set<DateTime> months = {};
    // months.addAll(initialMonths);
    DateTime now = DateTime.now();
    DateTime datetime = now.add(
      Duration(days: 7 * weekPage),
    );
    DateTime start = datetime.getStartOfWeek();
    DateTime end = datetime.getEndOfWeek();
    months.addAll(
      {
        DateTime(start.year, start.month),
        DateTime(end.year, end.month),
      },
    );
    //remove any dates we already fetched from the DB
    for (var element in initialMonths) {
      months.remove(element);
    }
    return months;
  }

  /// Format [datetime] to `ABBR_WEEKDAY` or `E` (e.g. Sun).
  String formatWeekDay(DateTime datetime) {
    return DateFormat.E(getLanguageCode()).format(datetime);
  }

  /// Format [datetime] to `DAY` or `d` (e.g. Sunday).
  String formatDay(DateTime datetime) {
    return DateFormat.d(getLanguageCode()).format(datetime);
  }

  /// Format [timeOfDay] to `HOUR24_MINUTE` or `Hm` (e.g. 16:35).
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${NumberFormat('00').format(timeOfDay.hour)}:${NumberFormat('00').format(timeOfDay.minute)}';
  }

  ///returns a `DateTime` from [value].
  ///
  ///If [value] is null:
  ///- if [initIfNull] is true: return `DateTime.now()`
  ///- else: return null
  static DateTime? getDateTimefromTimestamp(
    dynamic value, [
    bool initIfNull = true,
  ]) {
    try {
      if (value is Timestamp) {
        return DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000)
            .toLocal();
      } else if (value is DateTime) {
        return value;
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw Exception();
      }
    } on Exception {
      if (initIfNull) {
        return DateTime.now();
      } else {
        return null;
      }
    }
  }

  ///Takes [milliseconds] to format the input into a date and time value.
  ///if [milliseconds] is within an hour, format as `m`.
  ///if [milliseconds] is in the same day, format as `h`.
  ///if [milliseconds] is in the same week, format as `d`.
  ///if ![showFullDate] return null,
  ///else, if [milliseconds] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTimeFromMilliseconds(
    int milliseconds, [
    bool showFullDate = true,
  ]) {
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatElapsedDateTime(datetime, showFullDate);
  }

  ///Takes [milliseconds] to format the input into a date and time value.
  ///if [milliseconds] is within an hour, format as `m ago`.
  ///if [milliseconds] is in the same day, format as `h ago`.
  ///if [milliseconds] is in the same week, format as `d ago`.
  ///if ![showFullDate] return null,
  ///else, if [milliseconds] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTimeFromMillisecondsAgo(
    int milliseconds, [
    bool showFullDate = true,
  ]) {
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatElapsedDateTimeAgo(datetime, showFullDate);
  }

  ///Takes [milliseconds] to format the input into a date and time value.
  ///if [milliseconds] is within an hour, format as `minutes ago`.
  ///if [milliseconds] is in the same day, format as `hours ago`.
  ///if [milliseconds] is in the same week, format as `days ago`.
  ///if ![showFullDate] return null,
  ///else, if [milliseconds] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTimeFromMillisecondsFullAgo(
    int milliseconds, [
    bool showFullDate = true,
  ]) {
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatElapsedDateTimeAgo(datetime, showFullDate);
  }

  ///Takes [context] and [datetime] to format the input into a date and time value.
  ///if [datetime] is within an hour, format as `m ago`.
  ///if [datetime] is in the same day, format as `h ago`.
  ///if [datetime] is in the same week, format as `d ago`.
  ///if ![showFullDate] return null,
  ///else, if [datetime] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTimeAgo(
    DateTime datetime, [
    bool showFullDate = true,
  ]) {
    final DateTime now = DateTime.now();
    String locale = getLanguageCode();
    final Duration diff = now.difference(datetime);
    final inMinutes = diff.inMinutes;
    if (inMinutes < 1) {
      return AppLocalizations.of(context)!.moments_ago;
    }
    if (diff.inHours < 1) {
      return AppLocalizations.of(context)!.m_ago(inMinutes);
    }
    final inHours = diff.inHours;
    if (diff.inHours < 24) {
      return AppLocalizations.of(context)!.h_ago(inHours);
    }
    final inDays = diff.inDays;
    if (isSameWeek(diff)) {
      return AppLocalizations.of(context)!.d_ago(inDays);
    }
    if (!showFullDate) return null;
    if (isSameYear(now, datetime)) {
      return DateFormat.MMMd(locale).format(datetime);
    }
    return DateFormat.yMMMd(locale).format(datetime);
  }

  ///Takes [context] and [datetime] to format the input into a date and time value.
  ///if [datetime] is within an hour, format as `minutes ago`.
  ///if [datetime] is in the same day, format as `hours ago`.
  ///if [datetime] is in the same week, format as `days ago`.
  ///if ![showFullDate] return null,
  ///else, if [datetime] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTimeFullAgo(
    DateTime datetime, [
    bool showFullDate = true,
  ]) {
    final DateTime now = DateTime.now();
    String locale = getLanguageCode();
    final Duration diff = now.difference(datetime);
    final inMinutes = diff.inMinutes;
    if (inMinutes < 1) {
      return AppLocalizations.of(context)!.moments_ago;
    }
    if (diff.inHours < 1) {
      return AppLocalizations.of(context)!.minutes_ago(inMinutes);
    }
    final inHours = diff.inHours;
    if (diff.inHours < 24) {
      return AppLocalizations.of(context)!.hours_ago(inHours);
    }
    final inDays = diff.inDays;
    if (isSameWeek(diff)) {
      return AppLocalizations.of(context)!.days_ago(inDays);
    }
    if (!showFullDate) return null;
    if (isSameYear(now, datetime)) {
      return DateFormat.MMMd(locale).format(datetime);
    }
    return DateFormat.yMMMd(locale).format(datetime);
  }

  ///Takes [context] and [datetime] to format the input into a date and time value.
  ///if [datetime] is within an hour, format as `m`.
  ///if [datetime] is in the same day, format as `h`.
  ///if [datetime] is in the same week, format as `d`.
  ///if ![showFullDate] return null,
  ///else, if [datetime] is in the same year, format as `MMMd (e.g. Jul 22)`.
  ///else, format as `yMMMd (e.g. Jul 22, 2022)`.
  String? formatElapsedDateTime(
    DateTime datetime, [
    bool showFullDate = true,
  ]) {
    final DateTime now = DateTime.now();
    String locale = getLanguageCode();
    final Duration diff = now.difference(datetime);
    final inMinutes = diff.inMinutes;
    if (inMinutes < 1) {
      return AppLocalizations.of(context)!.moments_ago;
    }
    if (diff.inHours < 1) {
      return AppLocalizations.of(context)!.m(inMinutes);
    }
    final inHours = diff.inHours;
    if (diff.inHours < 24) {
      return AppLocalizations.of(context)!.h(inHours);
    }
    final inDays = diff.inDays;
    if (isSameWeek(diff)) {
      return AppLocalizations.of(context)!.d(inDays);
    }
    if (!showFullDate) return null;
    if (isSameYear(now, datetime)) {
      return DateFormat.MMMd(locale).format(datetime);
    }
    return DateFormat.yMMMd(locale).format(datetime);
  }
}
