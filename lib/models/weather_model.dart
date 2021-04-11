import 'package:flutter/foundation.dart';

import 'condition.dart';
import 'forecast.dart';
import 'reading.dart';
import 'source.dart';

/// Collection of weather data to be maintained in state.
class WeatherModel extends ChangeNotifier {
  /// The timestamp of the last modification.
  DateTime? _timestamp;

  /// The temperature reading.
  Reading? _temperature;

  /// The rainfall reading.
  Reading? _rain;

  /// The relative humidity reading.
  Reading? _humidity;

  /// The wind speed reading.
  Reading? _windSpeed;

  /// The wind direction reading.
  Reading? _windDirection;

  /// The PM2.5 reading.
  Reading? _pm2_5;

  /// The weather condition.
  Condition? _condition;

  /// The nearest region.
  Source? _region;

  /// The weather forecast.
  Map<Source, Iterable<Forecast>>? _forecast;

  /// The timestamp of the last modification.
  DateTime? get timestamp => _timestamp;

  /// The temperature reading.
  Reading? get temperature => _temperature;

  /// The rainfall reading.
  Reading? get rain => _rain;

  /// The relative humidity reading.
  Reading? get humidity => _humidity;

  /// The wind speed reading.
  Reading? get windSpeed => _windSpeed;

  /// The wind direction reading.
  Reading? get windDirection => _windDirection;

  /// The PM2.5 reading.
  Reading? get pm2_5 => _pm2_5;

  /// The weather condition.
  Condition? get condition => _condition;

  /// The nearest region.
  Source? get region => _region;

  /// The weather forecast.
  Map<Source, Iterable<Forecast>>? get forecast => _forecast;

  /// Resets all fields to null.
  void clear() {
    _timestamp = null;
    _temperature = null;
    _rain = null;
    _humidity = null;
    _windSpeed = null;
    _windDirection = null;
    _pm2_5 = null;
    _condition = null;
    _region = null;
    _forecast = null;

    notifyListeners();
  }

  /// Sets all the fields at once.
  void refresh({
    required DateTime timestamp,
    required Reading? temperature,
    required Reading? rain,
    required Reading? humidity,
    required Reading? windSpeed,
    required Reading? windDirection,
    required Reading? pm2_5,
    required Condition? condition,
    required Source? region,
    required Map<Source, Iterable<Forecast>>? forecast,
  }) {
    _timestamp = timestamp;
    _temperature = temperature;
    _rain = rain;
    _humidity = humidity;
    _windSpeed = windSpeed;
    _windDirection = windDirection;
    _pm2_5 = pm2_5;
    _condition = condition;
    _region = region;
    _forecast = forecast;

    notifyListeners();
  }

  /// Updates only the given fields.
  ///
  /// If a given argument is null, the underlying field will not be updated. To
  /// set a field to null, use [clear()] or [refresh()] instead.
  void update({
    required DateTime timestamp,
    Reading? temperature,
    Reading? rain,
    Reading? humidity,
    Reading? windSpeed,
    Reading? windDirection,
    Reading? pm2_5,
    Condition? condition,
    Source? region,
    Map<Source, Iterable<Forecast>>? forecast,
  }) {
    _timestamp = timestamp;
    if (temperature != null) _temperature = temperature;
    if (rain != null) _rain = rain;
    if (humidity != null) _humidity = humidity;
    if (windSpeed != null) _windSpeed = windSpeed;
    if (windDirection != null) _windDirection = windDirection;
    if (pm2_5 != null) _pm2_5 = pm2_5;
    if (condition != null) _condition = condition;
    if (region != null) _region = region;
    if (forecast != null) _forecast = forecast;

    notifyListeners();
  }
}
