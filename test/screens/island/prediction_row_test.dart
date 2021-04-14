import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:singapore_weather/models/next_day_prediction.dart';
import 'package:singapore_weather/models/weather_model.dart';
import 'package:singapore_weather/screens/island/prediction_row.dart';
import 'package:singapore_weather/screens/island/prediction_tile.dart';

main() {
  group('PredictionRow:', () {
    testWidgets('prediction == null => no tiles', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherModel>(
          create: (context) => WeatherModel(),
          child: MaterialApp(
            home: PredictionRow(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PredictionTile), findsNothing);
    });

    testWidgets('tiles are drawn for each available range',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now(),
          temperature: null,
          humidity: null,
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherModel>.value(
          value: data,
          child: MaterialApp(
            home: PredictionRow(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PredictionTile), findsNothing);

      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now(),
          temperature: NextDayPredictionRange(
            type: NextDayPredictionType.temperature,
            high: 35,
            low: 25,
          ),
          humidity: null,
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pump();

      expect(find.byType(PredictionTile), findsOneWidget);

      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now(),
          temperature: NextDayPredictionRange(
            type: NextDayPredictionType.temperature,
            high: 35,
            low: 25,
          ),
          humidity: NextDayPredictionRange(
            type: NextDayPredictionType.humidity,
            high: 90,
            low: 50,
          ),
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pump();

      expect(find.byType(PredictionTile), findsNWidgets(2));

      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now(),
          temperature: null,
          humidity: NextDayPredictionRange(
            type: NextDayPredictionType.humidity,
            high: 90,
            low: 50,
          ),
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pump();

      expect(find.byType(PredictionTile), findsOneWidget);
    });

    testWidgets('valid prediction => tile color == null',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now(),
          temperature: NextDayPredictionRange(
            type: NextDayPredictionType.temperature,
            high: 35,
            low: 25,
          ),
          humidity: NextDayPredictionRange(
            type: NextDayPredictionType.humidity,
            high: 90,
            low: 50,
          ),
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherModel>.value(
          value: data,
          child: MaterialApp(
            home: PredictionRow(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PredictionTile), findsNWidgets(2));
      expect(
        tester
            .elementList(find.byType(PredictionTile))
            .every((e) => (e.widget as PredictionTile).color == null),
        isTrue,
      );
    });

    testWidgets('prediction expired => tile color == headline color',
        (WidgetTester tester) async {
      final WeatherModel data = WeatherModel();
      data.update(
        timestamp: DateTime.now(),
        prediction: NextDayPrediction(
          creation: DateTime.now(),
          startTime: DateTime.now().subtract(const Duration(days: 2)),
          temperature: NextDayPredictionRange(
            type: NextDayPredictionType.temperature,
            high: 35,
            low: 25,
          ),
          humidity: NextDayPredictionRange(
            type: NextDayPredictionType.humidity,
            high: 90,
            low: 50,
          ),
          windSpeed: null,
          generalWindDirection: null,
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherModel>.value(
          value: data,
          child: MaterialApp(
            home: PredictionRow(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PredictionTile), findsNWidgets(2));
      expect(
        tester.elementList(find.byType(PredictionTile)).every((e) =>
            (e.widget as PredictionTile).color ==
            ThemeData().textTheme.headline1!.color),
        isTrue,
      );
    });
  });
}
