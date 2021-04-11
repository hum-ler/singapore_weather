import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/utils/date_time_ext.dart';

main() {
  group('DateTime.toSgt():', () {
    test('!isUtc => AssertionError', () {
      final DateTime now = DateTime.now();

      expect(() => now.toSgt(), throwsAssertionError);
    });

    test('valid input', () {
      final DateTime local = DateTime.now();

      final DateTime utc = local.toUtc();

      expect(local.isAtSameMomentAs(utc), isTrue);
      expect(local.isAtSameMomentAs(utc.toSgt()), isTrue);
      expect(utc.toSgt(), equals(local));
    });
  });
}
