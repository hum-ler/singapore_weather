import 'package:http/http.dart';

import '../models/condition.dart';
import '../models/forecast.dart';
import '../models/geoposition.dart';
import '../models/json_24_hour_forecast_model.dart';
import '../models/json_2_hour_forecast_model.dart';
import '../models/json_pm2_5_model.dart';
import '../models/json_reading_model.dart';
import '../models/reading.dart';
import '../models/source.dart';
import '../models/weather_model.dart';
import '../utils/http_utils.dart';
import '../utils/math_utils.dart';
import '../utils/string_ext.dart';
import 'geolocation.dart';

/// The service that retrieves weather data.
class Weather {
  /// Weather data object to populate.
  final WeatherModel data;

  /// Geolocation service.
  final Geolocation location;

  const Weather(this.data, this.location);

  Future<void> refresh() async {
    final Geoposition userLocation = await location.getCurrentLocation();

    Client client = Client();
    final JsonReadingModel temperatureModel;
    final JsonReadingModel rainModel;
    final JsonReadingModel humidityModel;
    final JsonReadingModel windSpeedModel;
    final JsonReadingModel windDirectionModel;
    final JsonPM2_5Model pm2_5Model;
    final Json2HourForecastModel conditionModel;
    final Json24HourForecastModel forecastModel;
    try {
      temperatureModel = await _fetchJsonReadingModel(
        client: client,
        url: _temperatureUrl,
      );
      rainModel = await _fetchJsonReadingModel(
        client: client,
        url: _rainUrl,
      );
      humidityModel = await _fetchJsonReadingModel(
        client: client,
        url: _humidityUrl,
      );
      windSpeedModel = await _fetchJsonReadingModel(
        client: client,
        url: _windSpeedUrl,
      );
      windDirectionModel = await _fetchJsonReadingModel(
        client: client,
        url: _windDirectionUrl,
      );
      pm2_5Model = await _fetchJsonPM25Model(
        client: client,
        url: _pm2_5Url,
      );
      conditionModel = await _fetchJson2HourForecastModel(
        client: client,
        url: _2HourForecastUrl,
      );
      forecastModel = await _fetchJson24HourForecastModel(
        client: client,
        url: _24HourForecastUrl,
      );
    } finally {
      client.close();
    }

    final Reading temperature = _deriveNearestReading(
      type: ReadingType.temperature,
      data: temperatureModel,
      userLocation: userLocation,
    );
    final Reading rain = _deriveNearestReading(
      type: ReadingType.rain,
      data: rainModel,
      userLocation: userLocation,
    );
    final Reading humidity = _deriveNearestReading(
      type: ReadingType.humidity,
      data: humidityModel,
      userLocation: userLocation,
    );
    final Reading windSpeed = _deriveNearestReading(
      type: ReadingType.windSpeed,
      data: windSpeedModel,
      userLocation: userLocation,
    );
    final Reading windDirection = _deriveNearestReading(
      type: ReadingType.windDirection,
      data: windDirectionModel,
      userLocation: userLocation,
    );
    final Reading pm2_5 = _deriveNearestPM2_5Reading(
      data: pm2_5Model,
      userLocation: userLocation,
    );
    final Condition condition = _deriveNearestCondition(
      data: conditionModel,
      userLocation: userLocation,
    );
    final Iterable<Forecast> forecast = _deriveNearestForecast(
      data: forecastModel,
      userLocation: userLocation,
    );

    data.refresh(
      timestamp: DateTime.now(),
      temperature: temperature,
      rain: rain,
      humidity: humidity,
      windSpeed: windSpeed,
      windDirection: windDirection,
      pm2_5: pm2_5,
      condition: condition,
      forecast: forecast,
    );
  }

  /// Pulls raw reading data from the given data service [url] and returns it as
  /// a [JsonReadingModel].
  ///
  /// If the operation fails, a [WeatherException] will be thrown.
  Future<JsonReadingModel> _fetchJsonReadingModel({
    required Client client,
    required String url,
  }) async {
    try {
      return JsonReadingModel.fromJson(await httpGetJsonData(url, client));
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }

  /// Pulls raw reading data for PM2.5 from the given data service [url] and
  /// returns it as a [JsonPM2_5Model].
  ///
  /// This is analogous to [_fetchJsonReadingModel] except that it handles PM2.5
  /// data, because the underlying data format is different.
  ///
  /// If the operation fails, a [WeatherException] will be thrown.
  Future<JsonPM2_5Model> _fetchJsonPM25Model({
    required Client client,
    required String url,
  }) async {
    try {
      return JsonPM2_5Model.fromJson(await httpGetJsonData(url, client));
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }

  /// Pulls raw 2-hour forecast data from the given data service [url] and
  /// returns it as a [Json2HourForecastModel].
  ///
  /// If the operation fails, a [WeatherException] will be thrown.
  Future<Json2HourForecastModel> _fetchJson2HourForecastModel({
    required Client client,
    required String url,
  }) async {
    try {
      return Json2HourForecastModel.fromJson(
        await httpGetJsonData(url, client),
      );
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }

  /// Pulls raw 24-hour forecast data from the given data service [url] and
  /// returns it as a [Json24HourForecastModel].
  ///
  /// If the operation fails, a [WeatherException] will be thrown.
  Future<Json24HourForecastModel> _fetchJson24HourForecastModel({
    required Client client,
    required String url,
  }) async {
    try {
      return Json24HourForecastModel.fromJson(
        await httpGetJsonData(url, client),
      );
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }

  /// Forms the reading for [type] that is closest to [userLocation].
  ///
  /// If [data] contains invalid content, a [WeatherException] will be thrown.
  Reading _deriveNearestReading({
    required ReadingType type,
    required JsonReadingModel data,
    required Geoposition userLocation,
  }) {
    // Catch bad raw data.
    if (data.apiInfo.status != 'healthy') {
      throw WeatherException(
        'unexpected ${type.toString().asEnumLabel()} readings',
      );
    }
    if (data.items.isEmpty) {
      throw WeatherException(
        'unexpected ${type.toString().asEnumLabel()} readings',
      );
    }

    final DateTime creation = data.items.first.timestamp.toLocal();

    return data.items.first.readings.map((e) {
      // Create all the Readings first, then reduce to the nearest one.

      // Find the matching station.
      final JsonReadingStation station =
          data.metadata.stations.firstWhere((s) => s.id == e.stationId);

      return Reading(
        type: type,
        creation: creation,
        source: Source.station(
          id: station.id,
          name: station.name,
          location: Geoposition(
            latitude: station.location.latitude,
            longitude: station.location.longitude,
          ),
        ),
        userLocation: userLocation,
        // Wind speed requires conversion from knots to m/s.
        value: type == ReadingType.windSpeed
            ? knotsToMetersPerSecond(e.value.toDouble())
            : e.value,
      );
    }).reduce((v, e) => v.distance < e.distance ? v : e);
  }

  /// Forms the PM2.5 reading that is closest to [userLocation].
  ///
  /// This is analogous to [_deriveNearestReading] except that it handles PM2.5
  /// data, because the underlying data format is different.
  ///
  /// If [data] contains invalid content, a [WeatherException] will be thrown.
  Reading _deriveNearestPM2_5Reading({
    required JsonPM2_5Model data,
    required Geoposition userLocation,
  }) {
    // Catch bad raw data.
    if (data.apiInfo.status != 'healthy') {
      throw WeatherException(
        'unexpected PM2.5 readings',
      );
    }
    if (data.items.isEmpty) {
      throw WeatherException(
        'unexpected PM2.5 readings',
      );
    }

    final DateTime creation = data.items.first.timestamp.toLocal();

    return ['central', 'north', 'east', 'south', 'west'].map((e) {
      // Create the Reading for each region, then reduce to the nearest one.

      final JsonPM2_5RegionMetadata region =
          data.regionMetadata.firstWhere((r) => r.name == e);

      return Reading(
        type: ReadingType.pm2_5,
        creation: creation,
        source: Source.station(
          id: region.name,
          name: region.name,
          location: Geoposition(
            latitude: region.labelLocation.latitude,
            longitude: region.labelLocation.longitude,
          ),
        ),
        userLocation: userLocation,
        value: data.items.first.readings.pm2_5OneHourly[e]!,
      );
    }).reduce((v, e) => v.distance < e.distance ? v : e);
  }

  /// Forms the condition that is closest to [userLocation].
  ///
  /// If [data] contains invalid content, a [WeatherException] will be thrown.
  Condition _deriveNearestCondition({
    required Json2HourForecastModel data,
    required Geoposition userLocation,
  }) {
    // Catch bad raw data.
    if (data.apiInfo.status != 'healthy') {
      throw WeatherException(
        'unexpected weather condition data',
      );
    }
    if (data.items.isEmpty) {
      throw WeatherException(
        'unexpected weather condition data',
      );
    }

    final DateTime creation = data.items.first.timestamp.toLocal();

    return data.items.first.forecasts.map((e) {
      // Create the Forecast for each area, then reduce to the nearest one.

      final Json2HourForecastAreaMetadata area =
          data.areaMetadata.firstWhere((a) => a.name == e.area);

      return Forecast(
        type: ForecastType.immediate,
        creation: creation,
        source: Source.area(
          id: area.name,
          name: area.name,
          location: Geoposition(
            latitude: area.labelLocation.latitude,
            longitude: area.labelLocation.longitude,
          ),
        ),
        userLocation: userLocation,
        condition: e.forecast,
      );
    }).reduce((v, e) => v.distance < e.distance ? v : e);
  }

  /// Forms the set of forecasts that is closest to [userLocation].
  ///
  /// If [data] contains invalid content, a [WeatherException] will be thrown.
  Iterable<Forecast> _deriveNearestForecast({
    required Json24HourForecastModel data,
    required Geoposition userLocation,
  }) {
    // Catch bad raw data.
    if (data.apiInfo.status != 'healthy') {
      throw WeatherException(
        'unexpected weather forecast data',
      );
    }
    if (data.items.isEmpty) {
      throw WeatherException(
        'unexpected weather forecast data',
      );
    }

    final DateTime creation = data.items.first.timestamp.toLocal();

    // Get the region (predefined in Sources) that is closest to userLocation.
    Source nearestRegion = [
      Sources.central,
      Sources.north,
      Sources.east,
      Sources.south,
      Sources.west
    ].reduce(
      (v, e) => v.location.distanceFrom(userLocation) <
              e.location.distanceFrom(userLocation)
          ? v
          : e,
    );

    final List<Forecast> forecast = [];
    data.items.first.periods.forEach((e) {
      // Determine the forecast type.
      ForecastType type = ForecastType.immediate;
      DateTime startTime = e.time.start.toLocal();
      switch (startTime.hour) {
        case 0:
          type = ForecastType.predawn;
          break;

        case 6:
          type = ForecastType.morning;
          break;

        case 12:
          type = ForecastType.afternoon;
          break;

        case 18:
          type = ForecastType.night;
          break;

        default:
          throw WeatherException('unexpected weather forecast data');
      }

      forecast.add(Forecast(
        type: type,
        creation: creation,
        source: nearestRegion,
        userLocation: userLocation,
        condition: e.regions[nearestRegion.name]!,
      ));
    });

    return forecast;
  }

  /// The URL of realtime air temperature readings API (at Data.gov.sg).
  ///
  /// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is °C.
  ///
  /// See https://data.gov.sg/dataset/realtime-weather-readings.
  static const String _temperatureUrl =
      'https://api.data.gov.sg/v1/environment/air-temperature';

  /// The URL of realtime rainfall readings API (at Data.gov.sg).
  ///
  /// Updates every 5 minutes. Takes parameter date_time=<ISO8601>. Unit is mm.
  ///
  /// See https://data.gov.sg/dataset/realtime-weather-readings.
  static const String _rainUrl =
      'https://api.data.gov.sg/v1/environment/rainfall';

  /// The URL of realtime relative humidity readings API (at Data.gov.sg).
  ///
  /// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is %.
  ///
  /// See https://data.gov.sg/dataset/realtime-weather-readings.
  static const String _humidityUrl =
      'https://api.data.gov.sg/v1/environment/relative-humidity';

  /// The URL of realtime wind speed readings API (at Data.gov.sg).
  ///
  /// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is knot.
  ///
  /// See https://data.gov.sg/dataset/realtime-weather-readings.
  static const String _windSpeedUrl =
      'https://api.data.gov.sg/v1/environment/wind-speed';

  /// The URL of realtime wind direction readings API (at Data.gov.sg).
  ///
  /// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is °.
  ///
  /// See https://data.gov.sg/dataset/realtime-weather-readings.
  static const String _windDirectionUrl =
      'https://api.data.gov.sg/v1/environment/wind-direction';

  /// The URL of the PM2.5 API (at Data.gov.sg).
  ///
  /// Takes parameter date_time=<ISO8601>.
  ///
  /// See https://data.gov.sg/dataset/pm2-5.
  static const String _pm2_5Url = 'https://api.data.gov.sg/v1/environment/pm25';

  /// The URL of the 2-hour weather forecast API (at Data.gov.sg).
  ///
  /// Updates every 30 minutes. Takes parameter date_time=<ISO8601>.
  ///
  /// See https://data.gov.sg/dataset/weather-forecast.
  static const String _2HourForecastUrl =
      'https://api.data.gov.sg/v1/environment/2-hour-weather-forecast';

  /// The URL of the 24-hour weather forecast API (at Data.gov.sg).
  ///
  /// Takes parameter date_time=<ISO8601>.
  ///
  /// See https://data.gov.sg/dataset/weather-forecast.
  static const String _24HourForecastUrl =
      'https://api.data.gov.sg/v1/environment/24-hour-weather-forecast';
}

/// Custom exception for the [Weather] service.
class WeatherException implements Exception {
  /// The error message.
  final String message;

  WeatherException(this.message);

  @override
  String toString() => 'Weather service error: $message';
}
