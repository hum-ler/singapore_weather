import 'package:flutter/material.dart';

import '../../models/forecast.dart';
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
                  forecast.type.toString().asEnumLabel().capitalize(),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              forecast.icon,
              size: 10.0,
            ),
            Text(
              ' ' + // give some extra space
                  forecast.condition.truncate(24, ellipsis: '…'),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
            ),
            Text(
              forecast.source.name.capitalize() +
                  ' (' +
                  forecast.distance.toStringAsFixed(1) +
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
