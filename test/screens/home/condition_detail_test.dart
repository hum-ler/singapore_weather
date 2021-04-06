import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/config.dart';
import 'package:singapore_weather/models/condition.dart';
import 'package:singapore_weather/models/source.dart';
import 'package:singapore_weather/screens/home/condition_detail.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';

main() {
  group('ConditionDetail:', () {
    testWidgets('valid condition => all icon / text color == null',
        (WidgetTester tester) async {
      final Condition condition = Condition(
        creation: DateTime.now(),
        source: Sources.central,
        userLocation: Sources.central.location,
        condition: 'Partly Cloudy (Day)',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ConditionDetail(condition),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(
        tester
            .elementList(find.byType(WrappedIcon))
            .any((e) => (e.widget as WrappedIcon).color != null),
        isFalse,
      );

      expect(find.byType(Text), findsNWidgets(3));
      expect(
        tester
            .elementList(find.byType(Text))
            .any((e) => (e.widget as Text).style!.color != null),
        isFalse,
      );
    });

    testWidgets(
        'out-of-range => second icon / text color == detailsProblemColor',
        (WidgetTester tester) async {
      final Condition condition = Condition(
        creation: DateTime.now(),
        source: Sources.east,
        userLocation: Sources.west.location,
        condition: 'Partly Cloudy (Day)',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ConditionDetail(condition),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon = tester
          .elementList(find.byType(WrappedIcon))
          .elementAt(1)
          .widget as WrappedIcon;

      expect(icon.color, equals(detailsProblemColor));

      final Text text =
          tester.elementList(find.byType(Text)).elementAt(1).widget as Text;

      expect(text.style!.color, equals(detailsProblemColor));
    });

    testWidgets('expired => third icon / text color == detailsProblemColor',
        (WidgetTester tester) async {
      final Condition condition = Condition(
        creation: DateTime.now().subtract(const Duration(days: 1)),
        source: Sources.central,
        userLocation: Sources.central.location,
        condition: 'Partly Cloudy (Day)',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ConditionDetail(condition),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WrappedIcon), findsNWidgets(3));
      expect(find.byType(Text), findsNWidgets(3));

      final WrappedIcon icon = tester
          .elementList(find.byType(WrappedIcon))
          .last
          .widget as WrappedIcon;

      expect(icon.color, equals(detailsProblemColor));

      final Text text =
          tester.elementList(find.byType(Text)).last.widget as Text;

      expect(text.style!.color, equals(detailsProblemColor));
    });
  });
}
