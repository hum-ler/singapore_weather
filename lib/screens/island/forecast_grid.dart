import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/source.dart';
import '../../models/weather_model.dart';
import 'forecast_row.dart';

// Draws the forecast icons on the island screen.
class ForecastGrid extends StatelessWidget {
  const ForecastGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<WeatherModel>(
        builder: (context, data, child) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(),
                if (data.forecast != null &&
                    data.forecast![Sources.west] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ForecastRow(data.forecast![Sources.west]!),
                  )
                else
                  Container(),
                Container(),
              ],
            ),
            SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (data.forecast != null &&
                    data.forecast![Sources.north] != null)
                  ForecastRow(data.forecast![Sources.north]!)
                else
                  Container(),
                if (data.forecast != null &&
                    data.forecast![Sources.central] != null)
                  ForecastRow(data.forecast![Sources.central]!)
                else
                  Container(),
                if (data.forecast != null &&
                    data.forecast![Sources.south] != null)
                  ForecastRow(data.forecast![Sources.south]!)
                else
                  Container(),
              ],
            ),
            SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(),
                if (data.forecast != null &&
                    data.forecast![Sources.east] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: ForecastRow(data.forecast![Sources.east]!),
                  )
                else
                  Container(),
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
