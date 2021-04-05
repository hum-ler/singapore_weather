import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/forecast.dart';
import 'package:singapore_weather/models/source.dart';

void main() {
  test('Forecast.isExpired', () {
    // Current creation time => false.
    Forecast forecast = Forecast(
      type: ForecastType.immediate,
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(forecast.creation, isNotNull);
    expect(forecast.expiry, isNotNull);
    expect(forecast.validityPeriod, isNotNull);
    expect(
      forecast.expiry,
      equals(forecast.creation.add(forecast.validityPeriod)),
    );
    expect(forecast.isExpired, isFalse);

    // Creation time way in the past => true.
    forecast = Forecast(
      type: ForecastType.immediate,
      condition: '',
      creation: DateTime(1000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(forecast.creation, isNotNull);
    expect(forecast.expiry, isNotNull);
    expect(forecast.validityPeriod, isNotNull);
    expect(
      forecast.expiry,
      equals(forecast.creation.add(forecast.validityPeriod)),
    );
    expect(forecast.isExpired, isTrue);

    // Creation time in the future => false.
    forecast = Forecast(
      type: ForecastType.immediate,
      condition: '',
      creation: DateTime(3000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(forecast.creation, isNotNull);
    expect(forecast.expiry, isNotNull);
    expect(forecast.validityPeriod, isNotNull);
    expect(
      forecast.expiry,
      equals(forecast.creation.add(forecast.validityPeriod)),
    );
    expect(forecast.isExpired, isFalse);

    // Creation time just within validity period => false.
    // Validity period is defined in hours, with the minimum of 2 hours.
    final Duration validityPeriod = forecast.validityPeriod;

    final DateTime now = DateTime.now();
    forecast = Forecast(
      type: ForecastType.immediate,
      condition: '',
      creation: now.subtract(validityPeriod).add(const Duration(hours: 1)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      forecast.expiry.isAfter(now),
      isTrue,
    );
    expect(forecast.isExpired, isFalse);

    // Creation time just without validity period => true.
    forecast = Forecast(
      type: ForecastType.immediate,
      condition: '',
      creation: now.subtract(validityPeriod).subtract(const Duration(hours: 1)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      forecast.expiry.isBefore(now),
      isTrue,
    );
    expect(forecast.isExpired, isTrue);
  });
}
