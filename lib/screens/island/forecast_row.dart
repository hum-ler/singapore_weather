import 'package:flutter/material.dart';

import '../../config.dart' as K;
import '../../generated/l10n.dart';
import '../../models/forecast.dart';
import '../home/forecast_tile.dart';

/// Draws a row of forecast tiles for a region.
class ForecastRow extends StatelessWidget {
  /// The forecast for the region.
  final Iterable<Forecast> forecast;

  const ForecastRow(
    this.forecast, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final Forecast f in forecast)
          ForecastTile(
            f.icon,
            S.of(context).shortForecastTypeLabel(f.type),
            iconSize: forecast.length == 4 ? 20.0 : 24.0,
            iconColor: f.isValid ? null : K.islandProblemColor,
            labelStyle: TextStyle(
              fontSize: 12.0,
              color: f.isValid ? null : K.islandProblemColor,
            ),
            spacerSize: 2.0,
            minWidth: forecast.length == 4 ? 20.0 : 24.0,
            minHeight: 52.0,
          ),
      ],
    );
  }
}
