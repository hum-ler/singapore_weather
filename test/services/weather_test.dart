import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/geoposition.dart';
import 'package:singapore_weather/models/weather_model.dart';
import 'package:singapore_weather/services/geolocation.dart';
import 'package:singapore_weather/services/weather.dart';

import 'weather_test.mocks.dart';

@GenerateMocks([Client, Geolocation, WeatherModel])
main() {
  setUp(() async => await S.load(const Locale('en')));

  group('Weather.refresh():', () {
    test('GeolocationException => passthrough', () {
      final WeatherModel data = MockWeatherModel();
      final Geolocation location = MockGeolocation();
      when(location.getCurrentLocation()).thenThrow(GeolocationException(''));

      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"key": "value"}', HttpStatus.ok));

      final Weather weather = Weather(data, location);
      expect(weather.refresh(client), throwsA(isA<GeolocationException>()));
    });

    test('client error => WeatherException', () {
      final WeatherModel data = MockWeatherModel();
      final Geolocation location = MockGeolocation();
      when(location.getCurrentLocation()).thenAnswer((_) async => Geoposition(
            latitude: 111.111111,
            longitude: 222.222222,
          ));

      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenThrow(Exception(''));

      final Weather weather = Weather(data, location);
      expect(weather.refresh(client), throwsA(isA<WeatherException>()));
    });

    test('invalid JSON => WeatherException', () {
      final WeatherModel data = MockWeatherModel();
      final Geolocation location = MockGeolocation();
      when(location.getCurrentLocation()).thenAnswer((_) async => Geoposition(
            latitude: 111.111111,
            longitude: 222.222222,
          ));

      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"key": "value"}', HttpStatus.ok));

      final Weather weather = Weather(data, location);
      expect(weather.refresh(client), throwsA(isA<WeatherException>()));
    });

    test('success => WeatherModel.refresh()', () async {
      final String jsonReading = '''
{
  "metadata": {
    "stations": [
      {
        "id": "test",
        "device_id": "test",
        "name": "test",
        "location": {
          "latitude": 111.111111,
          "longitude": 222.222222
        }
      }
    ],
    "reading_type": "test",
    "reading_unit": "test"
  },
  "items": [
    {
      "timestamp": "2020-06-06T06:06:06+08:00",
      "readings": [
        {
          "station_id": "test",
          "value": 25
        }
      ]
    }
  ],
  "api_info": {
    "status": "healthy"
  }
}
''';
      final String jsonPM2_5 = '''
{
  "region_metadata": [
    {
      "name": "west",
      "label_location": {
        "latitude": 1.35735,
        "longitude": 103.7
      }
    },
    {
      "name": "east",
      "label_location": {
        "latitude": 1.35735,
        "longitude": 103.94
      }
    },
    {
      "name": "central",
      "label_location": {
        "latitude": 1.35735,
        "longitude": 103.82
      }
    },
    {
      "name": "south",
      "label_location": {
        "latitude": 1.29587,
        "longitude": 103.82
      }
    },
    {
      "name": "north",
      "label_location": {
        "latitude": 1.41803,
        "longitude": 103.82
      }
    }
  ],
  "items": [
    {
      "update_timestamp": "2020-06-06T06:06:06+08:00",
      "timestamp": "2020-06-06T06:06:06+08:00",
      "readings": {
        "pm25_one_hourly": {
          "west": 6,
          "east": 6,
          "central": 6,
          "south": 6,
          "north": 6
        }
      }
    }
  ],
  "api_info": {
    "status": "healthy"
  }
}
''';
      final String json2Hour = '''
{
  "area_metadata": [
    {
      "name": "test",
      "label_location": {
        "latitude": 111.111111,
        "longitude": 222.222222
      }
    }
  ],
  "items": [
    {
      "update_timestamp": "2020-06-06T06:06:06+08:00",
      "timestamp": "2020-06-06T06:06:06+08:00",
      "valid_period": {
        "start": "2020-06-06T06:06:06+08:00",
        "end": "2020-06-06T08:06:06+08:00"
      },
      "forecasts": [
        {
          "area": "test",
          "forecast": "test"
        }
      ]
    }
  ],
  "api_info": {
    "status": "healthy"
  }
}
''';
      final String json24Hour = '''
{
  "items": [
    {
      "update_timestamp": "2020-06-06T06:06:06+08:00",
      "timestamp": "2020-06-06T06:06:06+08:00",
      "valid_period": {
        "start": "2020-06-06T06:06:06+08:00",
        "end": "2020-06-07T06:06:06+08:00"
      },
      "general": {
        "forecast": "test",
        "relative_humidity": {
          "low": 70,
          "high": 90
        },
        "temperature": {
          "low": 20,
          "high": 30
        },
        "wind": {
          "speed": {
            "low": 10,
            "high": 20
          },
          "direction": "N"
        }
      },
      "periods": [
        {
          "time": {
            "start": "2020-06-06T06:06:06+08:00",
            "end": "2020-06-06T12:06:06+08:00"
          },
          "regions": {
            "west": "test",
            "east": "test",
            "central": "test",
            "south": "test",
            "north": "test"
          }
        }
      ]
    }
  ],
  "api_info": {
    "status": "healthy"
  }
}
''';

      final MockWeatherModel data = MockWeatherModel();
      final MockGeolocation location = MockGeolocation();
      when(location.getCurrentLocation()).thenAnswer((_) async => Geoposition(
            latitude: 111.111111,
            longitude: 222.222222,
          ));

      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((invocation) async {
        String url = (invocation.positionalArguments[0] as Uri).path;
        if (url.contains('pm25')) return Response(jsonPM2_5, HttpStatus.ok);
        if (url.contains('2-hour')) return Response(json2Hour, HttpStatus.ok);
        if (url.contains('24-hour')) return Response(json24Hour, HttpStatus.ok);
        return Response(jsonReading, HttpStatus.ok);
      });

      final Weather weather = Weather(data, location);
      await weather.refresh(client);

      verify(data.refresh(
        timestamp: anyNamed('timestamp'),
        temperature: anyNamed('temperature'),
        rain: anyNamed('rain'),
        humidity: anyNamed('humidity'),
        windSpeed: anyNamed('windSpeed'),
        windDirection: anyNamed('windDirection'),
        pm2_5: anyNamed('pm2_5'),
        condition: anyNamed('condition'),
        forecast: anyNamed('forecast'),
      ));
    });
  });
}
