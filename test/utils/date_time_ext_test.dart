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

      // Find the offset in minutes from local timezone to SGT (GMT+8).
      final int localToSgtOffset = local.timeZoneOffset.inMinutes - 8 * 60;

      // Add 8 hours to create time in future (simulated SGT+8).
      final DateTime sgt =
          local.add(Duration(minutes: localToSgtOffset + 8 * 60));

      expect(local.isAtSameMomentAs(utc), isTrue);
      expect(sgt.isAtSameMomentAs(utc.toSgt()), isTrue);
      expect(utc.toSgt(), equals(sgt));
    });
  });
}
