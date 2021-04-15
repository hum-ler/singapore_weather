import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

/// A prediction of weather readings.
@immutable
class NextDayPrediction {
  /// The time of creation of this prediction, as reported by the provider.
  final DateTime creation;

  /// The start time of the predicted period.
  final DateTime startTime;

  /// The end time of the predicted period.
  final DateTime endTime;

  /// The length of the predicted period.
  ///
  /// Defaults to 24 hours.
  final Duration period;

  /// The predicted temperature range.
  final NextDayPredictionRange? temperature;

  /// The predicted relative humidity range.
  final NextDayPredictionRange? humidity;

  /// The predicted wind speed range.
  final NextDayPredictionRange? windSpeed;

  /// The predicted general wind direction.
  final NextDayPredictionValue? generalWindDirection;

  /// Indicates whether this prediction is already expired.
  bool get isExpired => DateTime.now().isAfter(endTime);

  NextDayPrediction({
    required this.creation,
    required this.startTime,
    this.period = const Duration(days: 1),
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.generalWindDirection,
  }) : endTime = startTime.add(period);
}

/// The types of prediction.
enum NextDayPredictionType {
  temperature,
  humidity,
  windSpeed,
  generalWindDirection,
}

/// A predicted weather reading value.
@immutable
class NextDayPredictionValue {
  /// The type of this prediction.
  final NextDayPredictionType type;

  /// The predicted average value.
  final num average;

  /// The icon that represents this type.
  IconData get icon => _icons[type]!;

  /// The unit for this type.
  String get unit => _units[type]!;

  const NextDayPredictionValue({
    required this.type,
    required this.average,
  });

  /// The icons that represent each [NextDayPredictionType].
  static const Map<NextDayPredictionType, IconData> _icons = {
    NextDayPredictionType.temperature: WeatherIcons.thermometer,
    NextDayPredictionType.humidity: WeatherIcons.raindrop,
    NextDayPredictionType.windSpeed: WeatherIcons.strong_wind,
    NextDayPredictionType.generalWindDirection: Icons.navigation,
  };

  /// The units for each [NextDayPredictionType].
  static const Map<NextDayPredictionType, String> _units = {
    NextDayPredictionType.temperature: '°C',
    NextDayPredictionType.humidity: '%',
    NextDayPredictionType.windSpeed: 'm/s',
    NextDayPredictionType.generalWindDirection: '°',
  };
}

/// A predicted weather reading (maximum, minimum) range.
@immutable
class NextDayPredictionRange extends NextDayPredictionValue {
  /// The predicted high value.
  final num high;

  /// The predicted low value.
  final num low;

  // The average is calculated as the simple mean of the high and low values,
  // assuming that all values are linear.
  const NextDayPredictionRange({
    required NextDayPredictionType type,
    required this.high,
    required this.low,
  }) : super(type: type, average: (high + low) / 2);
}
