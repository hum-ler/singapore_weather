import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/geoposition.dart';
import 'package:singapore_weather/models/reading.dart';
import 'package:singapore_weather/models/source.dart';

void main() {
  test('Reading.isExpired', () {
    // Current creation time => false.
    Reading reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.creation, isNotNull);
    expect(reading.expiry, isNotNull);
    expect(reading.validityPeriod, isNotNull);
    expect(
      reading.expiry,
      equals(reading.creation.add(reading.validityPeriod)),
    );
    expect(reading.isExpired, isFalse);

    // Creation time way in the past => true.
    reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: DateTime(1000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.creation, isNotNull);
    expect(reading.expiry, isNotNull);
    expect(reading.validityPeriod, isNotNull);
    expect(
      reading.expiry,
      equals(reading.creation.add(reading.validityPeriod)),
    );
    expect(reading.isExpired, isTrue);

    // Creation time in the future => false.
    reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: DateTime(3000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.creation, isNotNull);
    expect(reading.expiry, isNotNull);
    expect(reading.validityPeriod, isNotNull);
    expect(
      reading.expiry,
      equals(reading.creation.add(reading.validityPeriod)),
    );
    expect(reading.isExpired, isFalse);

    // Creation time just within validity period => false.
    // Validity period is defined in minutes, with the minimum of 10 minutes.
    final Duration validityPeriod = reading.validityPeriod;

    final DateTime now = DateTime.now();
    reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: now.subtract(validityPeriod).add(const Duration(minutes: 5)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      reading.expiry.isAfter(now),
      isTrue,
    );
    expect(reading.isExpired, isFalse);

    // Creation time just without validity period => true.
    reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation:
          now.subtract(validityPeriod).subtract(const Duration(minutes: 5)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      reading.expiry.isBefore(now),
      isTrue,
    );
    expect(reading.isExpired, isTrue);
  });

  test('Reading.isNearBy', () {
    Reading reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.isNearby, isTrue);

    reading = Reading(
      type: ReadingType.temperature,
      value: 0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Geoposition(
        latitude: 1.0,
        longitude: 2.0,
      ),
    );

    expect(reading.isNearby, isFalse);
  });

  test('Reading.isInBounds', () {
    Reading reading = Reading(
      type: ReadingType.temperature,
      value: -200.0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.isInBounds, isFalse);

    reading = Reading(
      type: ReadingType.temperature,
      value: 200.0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.isInBounds, isFalse);

    reading = Reading(
      type: ReadingType.temperature,
      value: 25.0,
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(reading.isInBounds, isTrue);
  });

  test(
    'Reading.isValid: == isInBounds && isNearBy && !isExpired',
    () {
      Reading reading = Reading(
        type: ReadingType.temperature,
        value: 25.0,
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Sources.central.location,
      );

      expect(reading.isInBounds, isTrue);
      expect(reading.isNearby, isTrue);
      expect(reading.isExpired, isFalse);
      expect(reading.isValid, isTrue);

      reading = Reading(
        type: ReadingType.temperature,
        value: -200.0,
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Sources.central.location,
      );

      expect(reading.isInBounds, isFalse);
      expect(reading.isNearby, isTrue);
      expect(reading.isExpired, isFalse);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: 25.0,
        creation: DateTime(1000),
        source: Sources.central,
        userLocation: Sources.central.location,
      );

      expect(reading.isInBounds, isTrue);
      expect(reading.isNearby, isTrue);
      expect(reading.isExpired, isTrue);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: 25.0,
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Geoposition(
          latitude: 1.0,
          longitude: 2.0,
        ),
      );

      expect(reading.isInBounds, isTrue);
      expect(reading.isNearby, isFalse);
      expect(reading.isExpired, isFalse);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: -200.0,
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Geoposition(
          latitude: 1.0,
          longitude: 2.0,
        ),
      );

      expect(reading.isInBounds, isFalse);
      expect(reading.isNearby, isFalse);
      expect(reading.isExpired, isFalse);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: -200.0,
        creation: DateTime(1000),
        source: Sources.central,
        userLocation: Sources.central.location,
      );

      expect(reading.isInBounds, isFalse);
      expect(reading.isNearby, isTrue);
      expect(reading.isExpired, isTrue);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: 25.0,
        creation: DateTime(1000),
        source: Sources.central,
        userLocation: Geoposition(
          latitude: 1.0,
          longitude: 2.0,
        ),
      );

      expect(reading.isInBounds, isTrue);
      expect(reading.isNearby, isFalse);
      expect(reading.isExpired, isTrue);
      expect(reading.isValid, isFalse);

      reading = Reading(
        type: ReadingType.temperature,
        value: -200.0,
        creation: DateTime(1000),
        source: Sources.central,
        userLocation: Geoposition(
          latitude: 1.0,
          longitude: 2.0,
        ),
      );

      expect(reading.isInBounds, isFalse);
      expect(reading.isNearby, isFalse);
      expect(reading.isExpired, isTrue);
      expect(reading.isValid, isFalse);
    },
  );
}
