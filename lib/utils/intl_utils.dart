import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Returns the DateTime as a string in the given [pattern].
  ///
  /// The default pattern, if not given, is 'd MMM h:mm'.
  ///
  /// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  /// for details on the pattern.
  String format({
    String? pattern = 'd MMM h:mm',
  }) =>
      DateFormat(pattern).format(this);
}

extension NumExt on num {
  /// Returns the number as a string in the given [pattern].
  ///
  /// The default pattern, if not given, is '#.#',
  ///
  /// See https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
  /// for details on the pattern.
  String format({
    String? pattern = '#.#',
  }) =>
      NumberFormat(pattern).format(this);
}
