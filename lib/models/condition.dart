import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../config.dart' as K;
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
  Duration get validityPeriod => K.conditionValidityPeriod;

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
  AssetImage get background => _backgrounds[condition] ?? K.defaultAssetImage;

  Condition({
    required this.creation,
    required this.condition,
    required this.source,
    required this.userLocation,
  })   : expiry = creation.add(K.conditionValidityPeriod),
        distance = userLocation.distanceFrom(source.location);

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

  /// The background images that represent each [condition].
  static const Map<String, AssetImage> _backgrounds = {
    'Cloudy': K.cloudAssetImage,
    'Fair (Day)': K.dayAssetImage,
    'Fair (Night)': K.nightAssetImage,
    'Fair & Warm': K.dayAssetImage,
    'Hazy (Day)': K.dayAssetImage,
    'Hazy (Night)': K.nightAssetImage,
    'Heavy Thundery Showers': K.lightningAssetImage,
    'Heavy Thundery Showers with Gusty Winds': K.lightningAssetImage,
    'Light Rain': K.rainAssetImage,
    'Light Showers': K.rainAssetImage,
    'Moderate Rain': K.rainAssetImage,
    'Heavy Rain': K.rainAssetImage,
    'Overcast': K.cloudAssetImage,
    'Partly Cloudy': K.cloudAssetImage,
    'Partly Cloudy (Day)': K.cloudAssetImage,
    'Partly Cloudy (Night)': K.cloudAssetImage,
    'Passing Showers': K.rainAssetImage,
    'Rain': K.rainAssetImage,
    'Rain (Day)': K.rainAssetImage,
    'Rain (Night)': K.rainAssetImage,
    'Showers': K.rainAssetImage,
    'Showers (Day)': K.rainAssetImage,
    'Showers (Night)': K.rainAssetImage,
    'Thundery Showers': K.lightningAssetImage,
    'Thundery Showers (Day)': K.lightningAssetImage,
    'Thundery Showers (Night)': K.lightningAssetImage,
    'Windy': K.windAssetImage,
  };
}
