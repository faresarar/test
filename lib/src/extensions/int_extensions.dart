import 'package:intl/intl.dart';

extension IntExtensions on int {
  /// get time format ``MM:HH` from `minutes`.
  ///
  /// - e.g. `430` in minutes is `08:13`
  String get toTimeFormat {
    return '${NumberFormat('00').format(this ~/ 60)}:${NumberFormat('00').format(this % 60)}';
  }
}
