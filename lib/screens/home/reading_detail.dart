import 'package:flutter/material.dart';

import '../../config.dart' as K;
import '../../models/reading.dart';
import '../../utils/intl_utils.dart';
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
            WrappedIcon(
              reading.icon,
              size: 10.0,
              rotation: reading.type == ReadingType.windDirection
                  ? degreesToRadians(reading.value.toDouble())
                  : null,
              color: reading.isInBounds ? null : K.detailsProblemColor,
            ),
            Text(
              ' ' + // give some extra space
                  reading.value.format() +
                  reading.unit,
              style: TextStyle(
                fontSize: 12.0,
                color: reading.isInBounds ? null : K.detailsProblemColor,
              ),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
              color: reading.isNearby ? null : K.detailsProblemColor,
            ),
            Text(
              reading.source.name
                      .truncate(
                        K.detailsSourceNameLength,
                        ellipsis: K.truncationEllipsis,
                      )
                      .capitalize() +
                  ' (' +
                  reading.distance.format() +
                  reading.distanceUnit +
                  ')',
              style: TextStyle(
                fontSize: 12.0,
                color: reading.isNearby ? null : K.detailsProblemColor,
              ),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.schedule,
              size: 10.0,
              color: reading.isExpired ? K.detailsProblemColor : null,
            ),
            Text(
              reading.creation.format(),
              style: TextStyle(
                fontSize: 12.0,
                color: reading.isExpired ? K.detailsProblemColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
