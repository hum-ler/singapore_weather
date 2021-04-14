import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/models/reading.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/screens/home/reading_detail.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';

main() {
  group('ReadingDetail:', () {
    testWidgets('valid reading => all icon / text color == null',
        (WidgetTester tester) async {
      final Reading reading = Reading(
        creation: DateTime.now(),
        source: Sources.central,
        type: ReadingType.temperature,
        userLocation: Sources.central.location,
        value: 25.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ReadingDetail(reading),
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

    testWidgets('out-of-bound => first icon / text color == headline color',
        (WidgetTester tester) async {
      final Reading reading = Reading(
        creation: DateTime.now(),
        source: Sources.central,
        type: ReadingType.temperature,
        userLocation: Sources.central.location,
        value: 99.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ReadingDetail(reading),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon =
          tester.firstElement(find.byType(WrappedIcon)).widget as WrappedIcon;

      expect(icon.color, equals(ThemeData().textTheme.headline1!.color));

      final Text text = tester.firstElement(find.byType(Text)).widget as Text;

      expect(text.style!.color, equals(ThemeData().textTheme.headline1!.color));
    });

    testWidgets('out-of-range => second icon / text color == headline color',
        (WidgetTester tester) async {
      final Reading reading = Reading(
        creation: DateTime.now(),
        source: Sources.east,
        type: ReadingType.temperature,
        userLocation: Sources.west.location,
        value: 25.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ReadingDetail(reading),
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

    testWidgets('expired => third icon / text color == headline color',
        (WidgetTester tester) async {
      final Reading reading = Reading(
        creation: DateTime.now().subtract(const Duration(days: 1)),
        source: Sources.central,
        type: ReadingType.temperature,
        userLocation: Sources.central.location,
        value: 25.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ReadingDetail(reading),
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
