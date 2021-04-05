import 'package:flutter/material.dart';

import '../../config.dart' as K;
import '../../generated/l10n.dart';
import '../../models/forecast.dart';
import '../../utils/intl_utils.dart';
import '../../utils/string_ext.dart';
import 'wrapped_icon.dart';

/// Displays the information for a forecast on the main screen. This shows up in
/// the bottom sheet.
class ForecastDetail extends StatelessWidget {
  /// The forecast to display.
  final Forecast forecast;

  const ForecastDetail(
    this.forecast, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14.0, // limit the height of the row
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.none,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            WrappedIcon(
              Icons.schedule,
              size: 10.0,
            ),
            Text(
              ' ' + // give some extra space
                  S.of(context).forecastTypeLabel(forecast.type),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              forecast.icon,
              size: 10.0,
            ),
            Text(
              ' ' + // give some extra space
                  forecast.condition.truncate(
                    K.detailsWeatherConditionLength,
                    ellipsis: K.truncationEllipsis,
                  ),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
            ),
            Text(
              S.of(context).regionNameLabel(forecast.source.name) +
                  ' (' +
                  forecast.distance.format() +
                  forecast.distanceUnit +
                  ')',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
          ],
        ),
      ),
    );
  }
}
