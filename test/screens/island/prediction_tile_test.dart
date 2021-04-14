import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/screens/home/wrapped_icon.dart';
import 'package:singapore_weather/screens/island/prediction_tile.dart';

main() {
  testWidgets('PredictionTile: color affects all icons, texts, spacers',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PredictionTile(
          high: 99,
          low: 1,
          icon: Icons.adb,
          unit: 'kg',
          color: null,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(WrappedIcon), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(3));

    // There should be a parent container and a spacer container.
    expect(find.byType(Container), findsNWidgets(2));

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

    // When color == null, the spacer is expected to be body text color.
    expect(
      (tester.elementList(find.byType(Container)).last.widget as Container)
              .color ==
          ThemeData().textTheme.bodyText1!.color,
      isTrue,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PredictionTile(
          high: 99,
          low: 1,
          icon: Icons.adb,
          unit: 'kg',
          color: Colors.red.shade500,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(WrappedIcon), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(3));
    expect(find.byType(Container), findsNWidgets(2));
    expect(
      tester
          .elementList(find.byType(WrappedIcon))
          .every((e) => (e.widget as WrappedIcon).color == Colors.red.shade500),
      isTrue,
    );
    expect(
      tester
          .elementList(find.byType(Text))
          .every((e) => (e.widget as Text).style!.color == Colors.red.shade500),
      isTrue,
    );
    expect(
      (tester.elementList(find.byType(Container)).last.widget as Container)
              .color ==
          Colors.red.shade500,
      isTrue,
    );
  });
}
