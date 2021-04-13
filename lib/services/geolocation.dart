import 'dart:async';

import 'package:location/location.dart';

import '../config.dart' as K;
import '../generated/l10n.dart';
import '../models/geoposition.dart';

/// The service that retrieves geolocation.
class Geolocation {
  /// Location library.
  final Location _location;

  const Geolocation(Location location) : _location = location;

  /// Retrieves the current geolocation.
  ///
  /// Includes requesting user action if location services is turned off or
  /// location permission is not granted for the app.
  ///
  /// If the operation fails, then a [GeolocationException] is thrown.
  Future<Geoposition> getCurrentLocation() async {
    bool serviceEnabled;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return Future.error(
          GeolocationException(S.current.geolocationExceptionServiceDisabled),
        );
      }
    }

    PermissionStatus permissionGranted;
    permissionGranted = await _location.hasPermission();
    if (permissionGranted != PermissionStatus.granted &&
        permissionGranted != PermissionStatus.grantedLimited) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted &&
          permissionGranted != PermissionStatus.grantedLimited) {
        return Future.error(
          GeolocationException(S.current.geolocationExceptionPermissionDenied),
        );
      }
    }

    final LocationData locationData;
    try {
      locationData =
          await _location.getLocation().timeout(K.getLocationTimeout);
      // Rethrow any errors as GeolocationExceptions.
    } on TimeoutException {
      return Future.error(
        GeolocationException(S.current.geolocationExceptionTimeout),
      );
    } catch (e) {
      return Future.error(GeolocationException(e.toString()));
    }

    if (locationData.latitude == null || locationData.longitude == null) {
      return Future.error(
        GeolocationException(S.current.geolocationExceptionUnexpectedResponse),
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
  String toString() => S.current.geolocationExceptionToString(message);
}
