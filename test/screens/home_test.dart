import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/weather_model.dart';
import 'package:singapore_weather/screens/about.dart';
import 'package:singapore_weather/screens/home.dart';
import 'package:singapore_weather/screens/home/island_button.dart';
import 'package:singapore_weather/screens/island.dart';
import 'package:singapore_weather/services/geolocation.dart';
import 'package:singapore_weather/services/weather.dart';

import 'home_test.mocks.dart';

@GenerateMocks([Geolocation, Weather])
main() {
  group('Home screen:', () {
    testWidgets('handle drag upwards => expose details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Geolocation>(
              create: (context) => MockGeolocation(),
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Home(refreshDataAtStartUp: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.drag_handle), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      final Offset initialOffset = tester.getTopLeft(find.byType(ListView));

      await tester.drag(find.byIcon(Icons.drag_handle), Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      final Offset expandedOffset = tester.getTopLeft(find.byType(ListView));

      // The ListView should be empty and therefore smaller than when populated
      // because shrinkWrap is set to true. Nonetheless, we expect its new
      // position to be above the initial position.
      final double minimumOffset = 100.0;
      expect(expandedOffset.dx, moreOrLessEquals(initialOffset.dx));
      expect(expandedOffset.dy, lessThan(initialOffset.dy - minimumOffset));

      await tester.drag(find.byIcon(Icons.drag_handle), Offset(0.0, 200.0));
      await tester.pumpAndSettle();

      final Offset contractedOffset = tester.getTopLeft(find.byType(ListView));

      expect(contractedOffset.dx, moreOrLessEquals(initialOffset.dx));
      expect(contractedOffset.dy, moreOrLessEquals(initialOffset.dy));
    });

    testWidgets('help button tap => about screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Geolocation>(
              create: (context) => MockGeolocation(),
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Home(refreshDataAtStartUp: false),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.byType(About), findsNothing);

      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();

      expect(find.byType(About), findsOneWidget);
    });

    testWidgets('island button tap => about screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Geolocation>(
              create: (context) => MockGeolocation(),
            ),
            Provider<Weather>(
              create: (context) => MockWeather(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Home(refreshDataAtStartUp: false),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(IslandButton), findsOneWidget);
      expect(find.byType(Island), findsNothing);

      await tester.tap(find.byType(IslandButton));
      await tester.pumpAndSettle();

      expect(find.byType(Island), findsOneWidget);
    });

    testWidgets('screen drag downwards => Weather.refresh()',
        (WidgetTester tester) async {
      MockWeather weather = MockWeather();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherModel>(
              create: (context) => WeatherModel(),
            ),
            Provider<Geolocation>(
              create: (context) => MockGeolocation(),
            ),
            Provider<Weather>.value(
              value: weather,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Home(refreshDataAtStartUp: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      verifyNever(weather.refresh(any));

      final TestGesture gesture =
          await tester.startGesture(Offset(200.0, 200.0));
      await gesture.moveTo(Offset(200.0, 300.0));
      await gesture.up();
      await tester.pumpAndSettle();

      verify(weather.refresh(any)).called(1);
    });
  });
}
