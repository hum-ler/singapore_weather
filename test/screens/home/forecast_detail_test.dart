import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/models/forecast.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/screens/home/forecast_detail.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';

main() {
  group('ForecastDetail:', () {
    testWidgets('valid forecast => all icon / text color == null',
        (WidgetTester tester) async {
      final Forecast forecast = Forecast(
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Sources.central.location,
        condition: 'Partly Cloudy (Day)',
        type: ForecastType.morning,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastDetail(forecast),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(
        tester
            .elementList(find.byType(WrappedIcon))
            .every((e) => (e.widget as WrappedIcon).color == null),
        isTrue,
      );

      expect(find.byType(Text), findsNWidgets(3));
      expect(
        tester
            .elementList(find.byType(Text))
            .every((e) => (e.widget as Text).style!.color == null),
        isTrue,
      );
    });

    testWidgets('out-of-range => third icon / text color == headline color',
        (WidgetTester tester) async {
      final Forecast forecast = Forecast(
        creation: DateTime.now(),
        source: Sources.east,
        userLocation: Sources.west.location,
        condition: 'Partly Cloudy (Day)',
        type: ForecastType.morning,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [S.delegate],
          locale: const Locale('en'),
          home: ForecastDetail(forecast),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon = tester
          .elementList(find.byType(WrappedIcon))
          .last
          .widget as WrappedIcon;

      expect(icon.color, equals(ThemeData().textTheme.headline1!.color));

      final Text text =
          tester.elementList(find.byType(Text)).last.widget as Text;

      expect(text.style!.color, equals(ThemeData().textTheme.headline1!.color));
    });
  });
}
