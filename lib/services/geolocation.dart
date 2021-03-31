import 'dart:async';

import 'package:location/location.dart';

import '../models/geoposition.dart';

/// The service that retrieves geolocation.
class Geolocation {
  /// Location library.
  final Location location;

  const Geolocation(this.location);

  /// Retrieves the current geolocation.
  ///
  /// Includes requesting user action if location services is turned off or
  /// location permission is not granted for the app.
  ///
  /// If the operation fails, then a [GeolocationException] is thrown.
  Future<Geoposition> getCurrentLocation() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error(GeolocationException('service disabled'));
      }
    }

    PermissionStatus permissionGranted;
    permissionGranted = await location.hasPermission();
    if (permissionGranted != PermissionStatus.granted &&
        permissionGranted != PermissionStatus.grantedLimited) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted &&
          permissionGranted != PermissionStatus.grantedLimited) {
        return Future.error(GeolocationException('permission denied'));
      }
    }

    final LocationData locationData;
    try {
      locationData =
          await location.getLocation().timeout(const Duration(seconds: 10));
      // Rethrow any errors as GeolocationExceptions.
    } on TimeoutException {
      return Future.error(GeolocationException('timed out'));
    } catch (e) {
      return Future.error(GeolocationException(e.toString()));
    }

    if (locationData.latitude == null || locationData.longitude == null) {
      return Future.error(
        GeolocationException('unexpected response from service'),
      );
    }

    return Geoposition(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
  }
}

/// Custom exception for the [Geolocation] service.
class GeolocationException implements Exception {
  /// The error message.
  final String message;

  GeolocationException(this.message);

  @override
  String toString() => 'Geolocation service error: $message';
}
