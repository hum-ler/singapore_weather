import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_model.dart';
import 'prediction_tile.dart';

/// Draws a row of prediction tiles.
class PredictionRow extends StatelessWidget {
  const PredictionRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<WeatherModel>(
        builder: (context, data, child) => Row(
          children: [
            if (data.prediction != null && data.prediction!.temperature != null)
              PredictionTile(
                high: data.prediction!.temperature!.high,
                low: data.prediction!.temperature!.low,
                unit: data.prediction!.temperature!.unit,
                icon: data.prediction!.temperature!.icon,
                color: !data.prediction!.isExpired
                    ? null
                    : Theme.of(context).textTheme.headline1!.color,
              ),
            if (data.prediction != null && data.prediction!.humidity != null)
              PredictionTile(
                high: data.prediction!.humidity!.high,
                low: data.prediction!.humidity!.low,
                unit: data.prediction!.humidity!.unit,
                icon: data.prediction!.humidity!.icon,
                color: !data.prediction!.isExpired
                    ? null
                    : Theme.of(context).textTheme.headline1!.color,
              )
          ],
        ),
      ),
    );
  }
}
