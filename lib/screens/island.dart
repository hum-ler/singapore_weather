import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart' as K;
import '../generated/l10n.dart';
import '../models/forecast.dart';
import '../models/source.dart';
import '../models/weather_model.dart';
import 'home/wrapped_icon.dart';

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
          Container(color: K.appSecondaryColor),

          // The map image.
          Container(
            height: double.infinity,
            child: Hero(
              tag: K.islandImageTag,
              child: Image(
                image: K.islandImage,
                fit: BoxFit.fitHeight,
                color: K.appPrimaryColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),

          // The forecast icons.
          Center(
            child: Consumer<WeatherModel>(
              builder: (context, data, child) => GridView.count(
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (data.forecast != null &&
                          data.forecast![Sources.north] != null)
                        for (final Forecast forecast
                            in data.forecast![Sources.north]!)
                          WrappedIcon(
                            forecast.icon,
                            size: 24.0,
                          ),
                    ],
                  ),
                  Container(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (data.forecast != null &&
                            data.forecast![Sources.west] != null)
                          for (final Forecast forecast
                              in data.forecast![Sources.west]!)
                            WrappedIcon(
                              forecast.icon,
                              size: 24.0,
                            ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (data.forecast != null &&
                          data.forecast![Sources.central] != null)
                        for (final Forecast forecast
                            in data.forecast![Sources.central]!)
                          WrappedIcon(
                            forecast.icon,
                            size: 24.0,
                          ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (data.forecast != null &&
                            data.forecast![Sources.east] != null)
                          for (final Forecast forecast
                              in data.forecast![Sources.east]!)
                            WrappedIcon(
                              forecast.icon,
                              size: 24.0,
                            ),
                      ],
                    ),
                  ),
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (data.forecast != null &&
                          data.forecast![Sources.south] != null)
                        for (final Forecast forecast
                            in data.forecast![Sources.south]!)
                          WrappedIcon(
                            forecast.icon,
                            size: 24.0,
                          ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
