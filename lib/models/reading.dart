import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../config.dart' as K;
import 'geoposition.dart';
import 'source.dart';

/// A weather reading.
///
/// Readings are quantitative, for instance, a temperature of 25°C.
@immutable
class Reading {
  /// The type of this reading.
  final ReadingType type;

  /// The time of creation of this reading, as reported by the provider.
  final DateTime creation;

  /// The numerical value of this reading.
  final num value;

  /// The unit of this reading.
  String get unit => _units[type]!;

  /// The source of this reading.
  final Source source;

  /// The location of the user that requested this reading.
  final Geoposition userLocation;

  /// The maximum (reasonable) value for this reading type.
  num get upperBound => _upperBounds[type]!;

  /// The minimum (reasonable) value for this reading type.
  num get lowerBound => _lowerBounds[type]!;

  /// Indicates whether the value is within reasonable boundaries.
  bool get isInBounds => lowerBound <= value && upperBound >= value;

  /// The validity period for this reading type.
  Duration get validityPeriod => _validityPeriods[type]!;

  /// The expiry time of this reading.
  final DateTime expiry;

  /// Indicates whether this reading is already expired.
  bool get isExpired => DateTime.now().isAfter(expiry);

  /// The distance of the user from the source.
  final double distance;

  /// The unit for [distance].
  String get distanceUnit => 'km';

  /// Indicates whether [distance] is within reasonable range.
  bool get isNearby => distance <= source.effectiveRange;

  /// Indicates whether this reading is healthy overall.
  bool get isValid => isInBounds && !isExpired && isNearby;

  /// The icon that represents this reading type.
  IconData get icon => _icons[type] ?? WeatherIcons.na;

  Reading({
    required this.type,
    required this.creation,
    required this.value,
    required this.source,
    required this.userLocation,
  })   : expiry = creation.add(_validityPeriods[type]!),
        distance = userLocation.distanceFrom(source.location);

  /// The validaty periods for each [ReadingType].
  static const Map<ReadingType, Duration> _validityPeriods = {
    ReadingType.temperature: K.temperatureReadingValidityPeriod,
    ReadingType.rain: K.rainReadingValidityPeriod,
    ReadingType.humidity: K.humidityReadingValidityPeriod,
    ReadingType.windSpeed: K.windSpeedReadingValidityPeriod,
    ReadingType.windDirection: K.windDirectionReadingValidityPeriod,
    ReadingType.pm2_5: K.pm2_5ReadingValidityPeriod,
  };

  /// The minimum (reasonable) values for each [ReadingType].
  static const Map<ReadingType, num> _lowerBounds = {
    ReadingType.temperature: 19.0,
    ReadingType.rain: 0.0,
    ReadingType.humidity: 30.0,
    ReadingType.windSpeed: 0.0,
    ReadingType.windDirection: 0,
    ReadingType.pm2_5: 0,
  };

  /// The maximum (reasonable) values for each [ReadingType].
  static const Map<ReadingType, num> _upperBounds = {
    ReadingType.temperature: 37.0,
    ReadingType.rain: 96.0,
    ReadingType.humidity: 100.0,
    ReadingType.windSpeed: 25.2,
    ReadingType.windDirection: 360,
    ReadingType.pm2_5: 471,
  };

  /// The units for each [ReadingType].
  static const Map<ReadingType, String> _units = {
    ReadingType.temperature: '°C',
    ReadingType.rain: 'mm',
    ReadingType.humidity: '%',
    ReadingType.windSpeed: 'm/s',
    ReadingType.windDirection: '°',
    ReadingType.pm2_5: 'µg/m³',
  };

  /// The icons that represent each [ReadingType].
  static const Map<ReadingType, IconData> _icons = {
    ReadingType.temperature: WeatherIcons.thermometer,
    ReadingType.rain: WeatherIcons.umbrella,
    ReadingType.humidity: WeatherIcons.raindrop,
    ReadingType.windSpeed: WeatherIcons.strong_wind,
    ReadingType.windDirection: Icons.navigation,
    ReadingType.pm2_5: Icons.grain,
  };
}

/// The types of reading.
enum ReadingType {
  temperature,
  rain,
  humidity,
  windSpeed,
  windDirection,
  pm2_5,
}
