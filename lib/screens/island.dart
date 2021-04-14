import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart' as K;
import '../generated/l10n.dart';
import '../models/source.dart';
import '../models/weather_model.dart';
import 'island/forecast_row.dart';

/// The island-wide forecast screen.
class Island extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).islandScreenTitle),
      ),
      body: Stack(
        children: [
          // The background color.
          Container(color: Theme.of(context).accentColor),

          // The map image.
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Hero(
              tag: K.islandImageTag,
              child: Image(
                image: K.islandImage,
                fit: BoxFit.fitHeight,
                color: Theme.of(context).primaryColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),

          // The forecast icons.
          Center(
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
                  SizedBox(width: 8.0),
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
                  SizedBox(width: 8.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(),
                      if (data.forecast != null &&
                          data.forecast![Sources.west] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: ForecastRow(data.forecast![Sources.west]!),
                        )
                      else
                        Container(),
                      Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
