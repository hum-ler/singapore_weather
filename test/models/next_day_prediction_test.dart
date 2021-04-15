import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/next_day_prediction.dart';

main() {
  test('NextDayPrediction.endTime', () {
    final DateTime now = DateTime.now();

    NextDayPrediction prediction = NextDayPrediction(
      creation: now,
      startTime: now,
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.endTime, equals(now.add(const Duration(days: 1))));

    prediction = NextDayPrediction(
      creation: now,
      startTime: now,
      period: const Duration(hours: 12),
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.endTime, equals(now.add(const Duration(hours: 12))));
  });

  test('NextDayPrediction.isExpired', () {
    final DateTime now = DateTime.now();

    NextDayPrediction prediction = NextDayPrediction(
      creation: now,
      startTime: now,
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.isExpired, isFalse);

    prediction = NextDayPrediction(
      creation: now,
      startTime: now.subtract(const Duration(days: 2)),
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.isExpired, isTrue);

    prediction = NextDayPrediction(
      creation: now,
      startTime: now,
      period: const Duration(hours: 12),
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.isExpired, isFalse);

    prediction = NextDayPrediction(
      creation: now,
      startTime: now.subtract(const Duration(days: 1)),
      period: const Duration(hours: 12),
      temperature: null,
      humidity: null,
      windSpeed: null,
      generalWindDirection: null,
    );

    expect(prediction.isExpired, isTrue);
  });
}
