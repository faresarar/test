import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  // TimeOfDay parse(String time) {
  //   List<String> values = time.split(':');
  //   return TimeOfDay(
  //     hour: int.parse(values[0]),
  //     minute: int.parse(values[1]),
  //   );
  // }

  /// add [minutes] to `TimeOfDay`.
  TimeOfDay add(int minutes) {
    int totalMinutes = (hour * 60) + minute;
    totalMinutes += minutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }
}
