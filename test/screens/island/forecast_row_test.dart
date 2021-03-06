import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/forecast.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';
import 'package:singapore_weather/screens/island/forecast_row.dart';

main() {
  group('ForecastRow:', () {
    testWidgets('!Forecast.isExpired => all icon / text color == null',
        (WidgetTester tester) async {
      final List<Forecast> forecast = [
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
          source: Sources.south,
          userLocation: Sources.north.location,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastRow(forecast),
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

    testWidgets('Forecast.isExpired => all icon / text color == headline color',
        (WidgetTester tester) async {
      final List<Forecast> forecast = [
        Forecast(
          type: ForecastType.morning,
          creation: DateTime.now(),
          condition: 'Partly Cloudy (Day)',
          source: Sources.central,
          userLocation: Sources.central.location,
        ),
        Forecast(
          type: ForecastType.afternoon,
          creation: DateTime.now().subtract(const Duration(days: 1)),
          condition: 'Partly Cloudy (Day)',
          source: Sources.east,
          userLocation: Sources.west.location,
        ),
        Forecast(
          type: ForecastType.night,
          creation: DateTime.now(),
          condition: 'Partly Cloudy (Night)',
          source: Sources.south,
          userLocation: Sources.north.location,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastRow(forecast),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      WrappedIcon icon = tester
          .elementList(find.byType(WrappedIcon))
          .elementAt(1)
          .widget as WrappedIcon;

      expect(icon.color, equals(ThemeData().textTheme.headline1!.color));

      Text text =
          tester.elementList(find.byType(Text)).elementAt(1).widget as Text;

      expect(text.style!.color, equals(ThemeData().textTheme.headline1!.color));

      // Test isExpired && !isNearby.
      icon = tester.elementList(find.byType(WrappedIcon)).elementAt(2).widget
          as WrappedIcon;

      expect(icon.color, isNull);

      text = tester.elementList(find.byType(Text)).elementAt(2).widget as Text;

      expect(text.style!.color, isNull);
    });

    testWidgets('icon size is smaller when forecast.length == 4',
        (WidgetTester tester) async {
      // The test is not really that meaningful, as what we really want to
      // ascertain is that there is no major overflow.

      // Note that if WrappedIcon.size is nullable, so if the size not set for
      // either case (length == 3 or length == 4), this test would fail.

      // Get the icon size when length == 3.
      final List<Forecast> forecast = [
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
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastRow(forecast),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon3 =
          tester.firstElement(find.byType(WrappedIcon)).widget as WrappedIcon;

      // Repeat for length == 4.
      forecast.add(
        Forecast(
          type: ForecastType.predawn,
          creation: DateTime.now(),
          condition: 'Partly Cloudy (Night)',
          source: Sources.central,
          userLocation: Sources.central.location,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastRow(forecast),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(4));
      expect(find.byType(Text), findsNWidgets(4));

      final WrappedIcon icon4 =
          tester.firstElement(find.byType(WrappedIcon)).widget as WrappedIcon;

      expect(icon4.size, lessThan(icon3.size));
    });
  });
}
