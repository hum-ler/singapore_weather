import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/forecast.dart';
import '../../models/weather_model.dart';
import 'condition_detail.dart';
import 'forecast_detail.dart';
import 'reading_detail.dart';

/// Draws the detailed information in the bottom sheet on the main screen.
class Details extends StatelessWidget {
  const Details({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Container(
        height: 170.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black.withOpacity(0.4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Consumer<WeatherModel>(
          builder: (context, data, child) => ListView(
            shrinkWrap: true,
            children: [
              if (data.temperature != null) ReadingDetail(data.temperature!),
              if (data.rain != null) ReadingDetail(data.rain!),
              if (data.humidity != null) ReadingDetail(data.humidity!),
              if (data.windSpeed != null) ReadingDetail(data.windSpeed!),
              if (data.windDirection != null)
                ReadingDetail(data.windDirection!),
              if (data.pm2_5 != null) ReadingDetail(data.pm2_5!),
              if (data.condition != null) ConditionDetail(data.condition!),
              if (data.forecast != null)
                for (Forecast forecast in data.forecast!)
                  ForecastDetail(forecast),
            ],
          ),
        ),
      ),
    );
  }
}
