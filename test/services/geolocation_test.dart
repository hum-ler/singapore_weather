import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:singapore_weather/models/geoposition.dart';
import 'package:singapore_weather/services/geolocation.dart';

import 'geolocation_test.mocks.dart';

@GenerateMocks([Location, LocationData])
main() {
  group('Geolocation.getCurrentLocation(): ', () {
    test('location service off => GeolocationException', () {
      final MockLocation location = MockLocation();
      when(location.serviceEnabled()).thenAnswer((_) async => false);
      when(location.requestService()).thenAnswer((_) async => false);
      when(location.hasPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.requestPermission())
          .thenAnswer((_) async => PermissionStatus.granted);

      final Geolocation geolocation = Geolocation(location);

      expect(
        geolocation.getCurrentLocation(),
        throwsA(isA<GeolocationException>()),
      );
    });

    test('location permission denied => GeolocationException', () {
      final MockLocation location = MockLocation();
      when(location.serviceEnabled()).thenAnswer((_) async => true);
      when(location.requestService()).thenAnswer((_) async => true);
      when(location.hasPermission())
          .thenAnswer((_) async => PermissionStatus.denied);
      when(location.requestPermission())
          .thenAnswer((_) async => PermissionStatus.denied);

      final Geolocation geolocation = Geolocation(location);

      expect(
        geolocation.getCurrentLocation(),
        throwsA(isA<GeolocationException>()),
      );
    });

    test('Location.getLocation() exception => GeolocationException', () {
      final MockLocation location = MockLocation();
      when(location.serviceEnabled()).thenAnswer((_) async => true);
      when(location.requestService()).thenAnswer((_) async => true);
      when(location.hasPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.requestPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.getLocation()).thenAnswer((_) => Future.error(''));

      final Geolocation geolocation = Geolocation(location);

      expect(
        geolocation.getCurrentLocation(),
        throwsA(isA<GeolocationException>()),
      );
    });

    test('Location.getLocation() timeout => GeolocationException', () {
      final MockLocation location = MockLocation();
      when(location.serviceEnabled()).thenAnswer((_) async => true);
      when(location.requestService()).thenAnswer((_) async => true);
      when(location.hasPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.requestPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.getLocation())
          .thenAnswer((_) => Future.error(TimeoutException(null)));

      final Geolocation geolocation = Geolocation(location);

      expect(
        geolocation.getCurrentLocation(),
        throwsA(isA<GeolocationException>()),
      );
    });

    test('valid response', () async {
      final MockLocationData locationData = MockLocationData();
      when(locationData.latitude).thenReturn(111.111111);
      when(locationData.longitude).thenReturn(222.222222);

      final MockLocation location = MockLocation();
      when(location.serviceEnabled()).thenAnswer((_) async => true);
      when(location.requestService()).thenAnswer((_) async => true);
      when(location.hasPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.requestPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(location.getLocation()).thenAnswer((_) async => locationData);

      final Geolocation geolocation = Geolocation(location);
      final Geoposition geoposition = await geolocation.getCurrentLocation();

      expect(geoposition.latitude, moreOrLessEquals(111.111111));
      expect(geoposition.longitude, moreOrLessEquals(222.222222));
    });
  });
}
