import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/condition.dart';
import 'package:singapore_weather/models/forecast.dart';
import 'package:singapore_weather/models/geoposition.dart';
import 'package:singapore_weather/models/reading.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/models/weather_model.dart';

main() {
  test('WeatherModel: modification => notify listeners', () {
    final WeatherModel weatherModel = WeatherModel();
    Completer completer = Completer();

    // WeatherModel.clear().
    weatherModel.addListener(() => completer.complete());
    weatherModel.clear();

    expect(completer.isCompleted, isTrue);

    // WeatherModel.refresh().
    completer = Completer();
    final Reading reading = Reading(
      type: ReadingType.temperature,
      creation: DateTime.now(),
      value: 25.0,
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Condition condition = Condition(
      creation: DateTime.now(),
      condition: '',
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Source region = Sources.central;
    final Map<Source, Iterable<Forecast>> forecast = {};

    weatherModel.refresh(
      timestamp: DateTime.now(),
      temperature: reading,
      rain: reading,
      humidity: reading,
      windSpeed: reading,
      windDirection: reading,
      pm2_5: reading,
      condition: condition,
      region: region,
      forecast: forecast,
    );

    expect(completer.isCompleted, isTrue);

    // WeatherModel.update().
    completer = Completer();
    weatherModel.update(
      timestamp: DateTime.now(),
      temperature: reading,
    );

    expect(completer.isCompleted, isTrue);
  });

  test('WeatherModel.clear()', () {
    final WeatherModel weatherModel = WeatherModel();
    weatherModel.clear();

    expect(weatherModel.timestamp, isNull);
    expect(weatherModel.temperature, isNull);
    expect(weatherModel.rain, isNull);
    expect(weatherModel.humidity, isNull);
    expect(weatherModel.windSpeed, isNull);
    expect(weatherModel.windDirection, isNull);
    expect(weatherModel.pm2_5, isNull);
    expect(weatherModel.condition, isNull);
    expect(weatherModel.region, isNull);
    expect(weatherModel.forecast, isNull);

    final Reading reading = Reading(
      type: ReadingType.temperature,
      creation: DateTime.now(),
      value: 25.0,
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Condition condition = Condition(
      creation: DateTime.now(),
      condition: '',
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Source region = Sources.central;
    final Map<Source, Iterable<Forecast>> forecast = {};
    weatherModel.refresh(
      timestamp: DateTime.now(),
      temperature: reading,
      rain: reading,
      humidity: reading,
      windSpeed: reading,
      windDirection: reading,
      pm2_5: reading,
      condition: condition,
      region: region,
      forecast: forecast,
    );
    weatherModel.clear();

    expect(weatherModel.timestamp, isNull);
    expect(weatherModel.temperature, isNull);
    expect(weatherModel.rain, isNull);
    expect(weatherModel.humidity, isNull);
    expect(weatherModel.windSpeed, isNull);
    expect(weatherModel.windDirection, isNull);
    expect(weatherModel.pm2_5, isNull);
    expect(weatherModel.condition, isNull);
    expect(weatherModel.region, isNull);
    expect(weatherModel.forecast, isNull);
  });

  test('WeatherModel.refresh()', () {
    final WeatherModel weatherModel = WeatherModel();
    final DateTime timestamp = DateTime.now();
    final Reading reading = Reading(
      type: ReadingType.temperature,
      creation: timestamp,
      value: 25.0,
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Condition condition = Condition(
      creation: timestamp,
      condition: '',
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Source region = Sources.central;
    final Map<Source, Iterable<Forecast>> forecast = {};
    weatherModel.refresh(
      timestamp: timestamp,
      temperature: reading,
      rain: reading,
      humidity: reading,
      windSpeed: reading,
      windDirection: reading,
      pm2_5: reading,
      condition: condition,
      region: region,
      forecast: forecast,
    );

    expect(weatherModel.timestamp, equals(timestamp));
    expect(weatherModel.temperature, equals(reading));
    expect(weatherModel.rain, equals(reading));
    expect(weatherModel.humidity, equals(reading));
    expect(weatherModel.windSpeed, equals(reading));
    expect(weatherModel.windDirection, equals(reading));
    expect(weatherModel.pm2_5, equals(reading));
    expect(weatherModel.condition, equals(condition));
    expect(weatherModel.region, equals(region));
    expect(weatherModel.forecast, equals(forecast));
  });

  test('WeatherModel.update()', () {
    final WeatherModel weatherModel = WeatherModel();
    final DateTime timestamp = DateTime.now();
    final Reading reading = Reading(
      type: ReadingType.temperature,
      creation: timestamp,
      value: 25.0,
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Condition condition = Condition(
      creation: timestamp,
      condition: '',
      source: Sources.central,
      userLocation: Geoposition(latitude: 0.0, longitude: 0.0),
    );
    final Source region = Sources.central;
    final Map<Source, Iterable<Forecast>> forecast = {};
    weatherModel.update(
      timestamp: timestamp,
      temperature: reading,
      rain: reading,
      humidity: reading,
      windSpeed: reading,
      windDirection: reading,
      pm2_5: reading,
      condition: condition,
      region: region,
      forecast: forecast,
    );

    expect(weatherModel.timestamp, equals(timestamp));
    expect(weatherModel.temperature, equals(reading));
    expect(weatherModel.rain, equals(reading));
    expect(weatherModel.humidity, equals(reading));
    expect(weatherModel.windSpeed, equals(reading));
    expect(weatherModel.windDirection, equals(reading));
    expect(weatherModel.pm2_5, equals(reading));
    expect(weatherModel.condition, equals(condition));
    expect(weatherModel.region, equals(region));
    expect(weatherModel.forecast, equals(forecast));
  });
}
