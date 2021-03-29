import 'package:flutter/material.dart';

import '../../models/reading.dart';
import '../../utils/date_time_ext.dart';
import '../../utils/math_utils.dart';
import '../../utils/string_ext.dart';
import 'wrapped_icon.dart';

/// Displays the information for a single reading on the main screen. This shows
/// up in the bottom sheet.
class ReadingDetail extends StatelessWidget {
  /// The reading to display.
  final Reading reading;

  const ReadingDetail(
    this.reading, {
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
            if (reading.type == ReadingType.windDirection)
              WrappedIcon(
                reading.icon,
                size: 10.0,
                rotation: degreesToRadians(reading.value.toDouble()),
              )
            else
              WrappedIcon(
                reading.icon,
                size: 10.0,
              ),
            if (reading.type == ReadingType.windDirection ||
                reading.type == ReadingType.pm2_5)
              Text(
                ' ' + // give some extra space
                    reading.value.toString() +
                    reading.unit,
                style: TextStyle(fontSize: 12.0),
              )
            else
              Text(
                ' ' + // give some extra space
                    reading.value.toStringAsFixed(1) +
                    reading.unit,
                style: TextStyle(fontSize: 12.0),
              ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
            ),
            Text(
              reading.source.name.truncate(18, ellipsis: "…").capitalize() +
                  ' (' +
                  reading.distance.toStringAsFixed(1) +
                  reading.distanceUnit +
                  ')',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.schedule,
              size: 10.0,
            ),
            Text(
              reading.creation.format('d MMM h:mm'),
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
