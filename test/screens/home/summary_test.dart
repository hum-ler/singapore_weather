import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/condition.dart';
import 'package:singapore_weather/models/forecast.dart';
import 'package:singapore_weather/models/reading.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/models/weather_model.dart';
import 'package:singapore_weather/screens/home/summary.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';
import 'package:singapore_weather/services/geolocation.dart';
import 'package:singapore_weather/services/weather.dart';

import 'summary_test.mocks.dart';

@GenerateMocks([Weather])
main() {
  group('Summary:', () {
    testWidgets('GeolocationException => snack bar',
        (WidgetTester tester) async {
      final MockWeather weather = MockWeather();
      when(weather.refresh(any)).thenThrow(GeolocationException(''));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Weather>.value(
              value: weather,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expect a snack bar with Geolocation error message and retry button.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(S.current.snackBarGeolocationExceptionPrefix),
        findsOneWidget,
      );
      expect(find.text(S.current.snackBarRetryButtonLabel), findsOneWidget);
    });

    testWidgets('WeatherException => snack bar', (WidgetTester tester) async {
      final MockWeather weather = MockWeather();
      when(weather.refresh(any)).thenThrow(WeatherException(''));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Weather>.value(
              value: weather,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expect a snack bar with Weather error message and retry button.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(S.current.snackBarWeatherExceptionPrefix),
        findsOneWidget,
      );
      expect(find.text(S.current.snackBarRetryButtonLabel), findsOneWidget);
    });

    testWidgets('valid temperature => text color == null',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        temperature: Reading(
          creation: DateTime.now(),
          source: Sources.central,
          type: ReadingType.temperature,
          userLocation: Sources.central.location,
          value: 25.0,
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('25°'), findsOneWidget);

      final Text text = tester.element(find.text('25°')).widget as Text;

      expect(text.style!.color, isNull);
    });

    testWidgets('invalid temperature => text color == headline color',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        temperature: Reading(
          creation: DateTime.now(),
          source: Sources.central,
          type: ReadingType.temperature,
          userLocation: Sources.central.location,
          value: 99.0,
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('99°'), findsOneWidget);

      final Text text = tester.element(find.text('99°')).widget as Text;

      expect(text.style!.color, equals(ThemeData().textTheme.headline1!.color));
    });

    testWidgets('valid condition => icon color == null',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        condition: Condition(
          creation: DateTime.now(),
          condition: 'Partly Cloudy (Day)',
          source: Sources.central,
          userLocation: Sources.central.location,
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsOneWidget);

      final WrappedIcon icon =
          tester.element(find.byType(WrappedIcon)).widget as WrappedIcon;

      expect(icon.color, isNull);
    });

    testWidgets('invalid condition => icon color == headline color',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        condition: Condition(
          creation: DateTime.now(),
          condition: 'Partly Cloudy (Day)',
          source: Sources.east,
          userLocation: Sources.west.location,
        ),
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsOneWidget);

      final WrappedIcon icon =
          tester.element(find.byType(WrappedIcon)).widget as WrappedIcon;

      expect(icon.color, equals(ThemeData().textTheme.headline1!.color));
    });

    testWidgets('valid forecast => all icon / text color == null',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        region: Sources.central,
        forecast: {
          Sources.central: [
            Forecast(
              type: ForecastType.morning,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Day)',
              source: Sources.central,
              userLocation: Sources.central.location,
            ),
            Forecast(
              type: ForecastType.afternoon,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Day)',
              source: Sources.central,
              userLocation: Sources.central.location,
            ),
            Forecast(
              type: ForecastType.night,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Night)',
              source: Sources.central,
              userLocation: Sources.central.location,
            ),
          ],
        },
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));
      expect(
        tester
            .elementList(find.byType(WrappedIcon))
            .every((e) => (e.widget as WrappedIcon).color == null),
        isTrue,
      );
      expect(
        tester
            .elementList(find.byType(Text))
            .every((e) => (e.widget as Text).style!.color == null),
        isTrue,
      );
    });

    testWidgets('invalid forecast => icon / text color == headline color',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        region: Sources.central,
        forecast: {
          Sources.central: [
            Forecast(
              type: ForecastType.morning,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Day)',
              source: Sources.central,
              userLocation: Sources.central.location,
            ),
            Forecast(
              type: ForecastType.afternoon,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Day)',
              source: Sources.east,
              userLocation: Sources.west.location,
            ),
            Forecast(
              type: ForecastType.night,
              creation: DateTime.now(),
              condition: 'Partly Cloudy (Night)',
              source: Sources.central,
              userLocation: Sources.central.location,
            ),
          ],
        },
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>.value(
              value: data,
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Scaffold(
              body: Summary(refreshDataAtStartUp: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon = tester
          .elementList(find.byType(WrappedIcon))
          .elementAt(1)
          .widget as WrappedIcon;

      expect(icon.color, equals(ThemeData().textTheme.headline1!.color));

      final Text text =
          tester.elementList(find.byType(Text)).elementAt(1).widget as Text;

      expect(text.style!.color, equals(ThemeData().textTheme.headline1!.color));
    });
  });
}
