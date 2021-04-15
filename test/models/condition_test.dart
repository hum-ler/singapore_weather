import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/condition.dart';
import 'package:singapore_weather/models/geoposition.dart';
import 'package:singapore_weather/models/source.dart';

void main() {
  test('Condition.isExpired', () {
    // Current creation time => false.
    Condition condition = Condition(
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(condition.creation, isNotNull);
    expect(condition.expiry, isNotNull);
    expect(condition.validityPeriod, isNotNull);
    expect(
      condition.expiry,
      equals(condition.creation.add(condition.validityPeriod)),
    );
    expect(condition.isExpired, isFalse);

    // Creation time way in the past => true.
    condition = Condition(
      condition: '',
      creation: DateTime(1000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(condition.creation, isNotNull);
    expect(condition.expiry, isNotNull);
    expect(condition.validityPeriod, isNotNull);
    expect(
      condition.expiry,
      equals(condition.creation.add(condition.validityPeriod)),
    );
    expect(condition.isExpired, isTrue);

    // Creation time in the future => false.
    condition = Condition(
      condition: '',
      creation: DateTime(3000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(condition.creation, isNotNull);
    expect(condition.expiry, isNotNull);
    expect(condition.validityPeriod, isNotNull);
    expect(
      condition.expiry,
      equals(condition.creation.add(condition.validityPeriod)),
    );
    expect(condition.isExpired, isFalse);

    // Creation time just within validity period => false.
    final Duration validityPeriod = condition.validityPeriod;
    final DateTime now = DateTime.now();
    condition = Condition(
      condition: '',
      creation: now.subtract(validityPeriod).add(const Duration(hours: 1)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      condition.expiry.isAfter(now),
      isTrue,
    );
    expect(condition.isExpired, isFalse);

    // Creation time just without validity period => true.
    condition = Condition(
      condition: '',
      creation: now.subtract(validityPeriod).subtract(const Duration(hours: 1)),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(
      condition.expiry.isBefore(now),
      isTrue,
    );
    expect(condition.isExpired, isTrue);
  });

  test('Condition.isNearby', () {
    Condition condition = Condition(
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(condition.isNearby, isTrue);

    condition = Condition(
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Geoposition(
        latitude: 1.0,
        longitude: 2.0,
      ),
    );

    expect(condition.isNearby, isFalse);
  });

  test('Condition.isValid: == isNearBy && !isExpired', () {
    Condition condition = Condition(
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Sources.central.location,
    );

    expect(condition.isNearby, isTrue);
    expect(condition.isExpired, isFalse);
    expect(condition.isValid, isTrue);

    condition = Condition(
      condition: '',
      creation: DateTime(1000),
      source: Sources.central,
      userLocation: Sources.central.location,
    );
    expect(condition.isNearby, isTrue);
    expect(condition.isExpired, isTrue);
    expect(condition.isValid, isFalse);

    condition = Condition(
      condition: '',
      creation: DateTime.now(),
      source: Sources.central,
      userLocation: Geoposition(
        latitude: 1.0,
        longitude: 2.0,
      ),
    );
    expect(condition.isNearby, isFalse);
    expect(condition.isExpired, isFalse);
    expect(condition.isValid, isFalse);

    condition = Condition(
      condition: '',
      creation: DateTime(1000),
      source: Sources.central,
      userLocation: Geoposition(
        latitude: 1.0,
        longitude: 2.0,
      ),
    );
    expect(condition.isNearby, isFalse);
    expect(condition.isExpired, isTrue);
    expect(condition.isValid, isFalse);
  });
}
