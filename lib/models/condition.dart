import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import 'geoposition.dart';
import 'source.dart';

/// A weather condition.
///
/// Conditions are qualitative descriptions, for instance, "sunny".
@immutable
class Condition {
  /// The time of creation of this condition, as reported by the provider.
  final DateTime creation;

  /// The literal weather condition.
  final String condition;

  /// The source of this condition.
  final Source source;

  /// The location of the user that requested this condition.
  final Geoposition userLocation;

  /// The validity period of this condition.
  Duration get validityPeriod => _validityPeriod;

  /// The expiry time of this condition.
  final DateTime expiry;

  /// Indicates whether this condition is already expired.
  bool get isExpired => DateTime.now().isAfter(expiry);

  /// The distance of the user from the source.
  final double distance;

  /// The unit for [distance].
  String get distanceUnit => 'km';

  /// Indicates whether [distance] is within reasonable range.
  bool get isNearby => distance <= source.effectiveRange;

  /// Indicates whether this condition is healthy overall.
  bool get isValid => !isExpired && isNearby;

  /// The icon that represents this condition.
  ///
  /// Provided by WeatherIcons. Use [BoxedIcon()] to ensure correct display.
  IconData get icon => _icons[condition] ?? WeatherIcons.na;

  /// The background image that represents this condition.
  ///
  /// Images must be found inside the assets/images folder.
  AssetImage get background =>
      AssetImage(_backgrounds[condition] ?? 'assets/images/default.webp');

  Condition({
    required this.creation,
    required this.condition,
    required this.source,
    required this.userLocation,
  })   : expiry = creation.add(_validityPeriod),
        distance = userLocation.distanceFrom(source.location);

  /// The validity period for a condition.
  static const Duration _validityPeriod = Duration(hours: 2);

  /// The icons that represent each [condition].
  static const Map<String, IconData> _icons = {
    'Cloudy': WeatherIcons.cloudy,
    'Fair (Day)': WeatherIcons.day_sunny,
    'Fair (Night)': WeatherIcons.night_clear,
    'Fair & Warm': WeatherIcons.hot,
    'Hazy': WeatherIcons.dust,
    'Hazy (Day)': WeatherIcons.day_haze,
    'Hazy (Night)': WeatherIcons.dust,
    'Heavy Thundery Showers': WeatherIcons.storm_showers,
    'Heavy Thundery Showers with Gusty Winds': WeatherIcons.storm_showers,
    'Light Rain': WeatherIcons.rain,
    'Light Showers': WeatherIcons.showers,
    'Moderate Rain': WeatherIcons.rain,
    'Heavy Rain': WeatherIcons.rain,
    'Overcast': WeatherIcons.cloudy,
    'Partly Cloudy': WeatherIcons.cloud,
    'Partly Cloudy (Day)': WeatherIcons.day_sunny_overcast,
    'Partly Cloudy (Night)': WeatherIcons.night_alt_partly_cloudy,
    'Passing Showers': WeatherIcons.showers,
    'Rain': WeatherIcons.rain,
    'Rain (Day)': WeatherIcons.day_rain,
    'Rain (Night)': WeatherIcons.night_alt_rain,
    'Showers': WeatherIcons.showers,
    'Showers (Day)': WeatherIcons.day_showers,
    'Showers (Night)': WeatherIcons.night_alt_showers,
    'Thundery Showers': WeatherIcons.storm_showers,
    'Thundery Showers (Day)': WeatherIcons.day_storm_showers,
    'Thundery Showers (Night)': WeatherIcons.night_alt_storm_showers,
    'Windy': WeatherIcons.strong_wind,
  };

  /// The background images (as asset names) that represent each [condition].
  static const Map<String, String> _backgrounds = {
    'Cloudy': 'assets/images/cloud.webp',
    'Fair (Day)': 'assets/images/day.webp',
    'Fair (Night)': 'assets/images/night.webp',
    'Fair & Warm': 'assets/images/day.webp',
    'Hazy (Day)': 'assets/images/day.webp',
    'Hazy (Night)': 'assets/images/night.webp',
    'Heavy Thundery Showers': 'assets/images/lightning.webp',
    'Heavy Thundery Showers with Gusty Winds': 'assets/images/lightning.webp',
    'Light Rain': 'assets/images/rain.webp',
    'Light Showers': 'assets/images/rain.webp',
    'Moderate Rain': 'assets/images/rain.webp',
    'Heavy Rain': 'assets/images/rain.webp',
    'Overcast': 'assets/images/cloud.webp',
    'Partly Cloudy': 'assets/images/cloud.webp',
    'Partly Cloudy (Day)': 'assets/images/cloud.webp',
    'Partly Cloudy (Night)': 'assets/images/cloud.webp',
    'Passing Showers': 'assets/images/rain.webp',
    'Rain': 'assets/images/rain.webp',
    'Rain (Day)': 'assets/images/rain.webp',
    'Rain (Night)': 'assets/images/rain.webp',
    'Showers': 'assets/images/rain.webp',
    'Showers (Day)': 'assets/images/rain.webp',
    'Showers (Night)': 'assets/images/rain.webp',
    'Thundery Showers': 'assets/images/lightning.webp',
    'Thundery Showers (Day)': 'assets/images/lightning.webp',
    'Thundery Showers (Night)': 'assets/images/lightning.webp',
    'Windy': 'assets/images/wind.webp',
  };
}
