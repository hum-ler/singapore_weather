import 'package:flutter/foundation.dart';

import 'condition.dart';
import 'forecast.dart';
import 'reading.dart';

/// Collection of weather data to be maintained in state.
class WeatherModel extends ChangeNotifier {
  DateTime? _timestamp;

  Reading? _temperature;

  Reading? _rain;

  Reading? _humidity;

  Reading? _windSpeed;

  Reading? _windDirection;

  Reading? _pm2_5;

  Condition? _condition;

  Iterable<Forecast>? _forecast;

  DateTime? get timestamp => _timestamp;

  Reading? get temperature => _temperature;

  Reading? get rain => _rain;

  Reading? get humidity => _humidity;

  Reading? get windSpeed => _windSpeed;

  Reading? get windDirection => _windDirection;

  Reading? get pm2_5 => _pm2_5;

  Condition? get condition => _condition;

  Iterable<Forecast>? get forecast => _forecast;

  void clear() {
    _timestamp = null;
    _temperature = null;
    _rain = null;
    _humidity = null;
    _windSpeed = null;
    _windDirection = null;
    _pm2_5 = null;
    _condition = null;
    _forecast = null;

    notifyListeners();
  }

  void refresh({
    required DateTime timestamp,
    required Reading? temperature,
    required Reading? rain,
    required Reading? humidity,
    required Reading? windSpeed,
    required Reading? windDirection,
    required Reading? pm2_5,
    required Condition? condition,
    required Iterable<Forecast>? forecast,
  }) {
    _timestamp = timestamp;
    _temperature = temperature;
    _rain = rain;
    _humidity = humidity;
    _windSpeed = windSpeed;
    _windDirection = windDirection;
    _pm2_5 = pm2_5;
    _condition = condition;
    _forecast = forecast;

    notifyListeners();
  }

  void update({
    required DateTime timestamp,
    Reading? temperature,
    Reading? rain,
    Reading? humidity,
    Reading? windSpeed,
    Reading? windDirection,
    Reading? pm2_5,
    Condition? condition,
    Iterable<Forecast>? forecast,
  }) {
    _timestamp = timestamp;
    if (temperature != null) _temperature = temperature;
    if (rain != null) _rain = rain;
    if (humidity != null) _humidity = humidity;
    if (windSpeed != null) _windSpeed = windSpeed;
    if (windDirection != null) _windDirection = windDirection;
    if (pm2_5 != null) _pm2_5 = pm2_5;
    if (condition != null) _condition = condition;
    if (forecast != null) _forecast = forecast;

    notifyListeners();
  }
}
