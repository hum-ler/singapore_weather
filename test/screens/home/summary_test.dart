import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/weather_model.dart';
import 'package:singapore_weather/screens/home/summary.dart';
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
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<WeatherModel>(
                create: (context) => WeatherModel(),
              ),
              Provider<Weather>(
                create: (context) => weather,
              ),
            ],
            child: Scaffold(
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
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<WeatherModel>(
                create: (context) => WeatherModel(),
              ),
              Provider<Weather>(
                create: (context) => weather,
              ),
            ],
            child: Scaffold(
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
  });
}
