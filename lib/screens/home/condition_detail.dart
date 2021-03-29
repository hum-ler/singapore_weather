import 'package:flutter/material.dart';

import '../../models/condition.dart';
import '../../utils/date_time_ext.dart';
import '../../utils/string_ext.dart';
import 'wrapped_icon.dart';

/// Displays the information for the weather condition on the main screen. This
/// shows up in the bottom sheet.
class ConditionDetail extends StatelessWidget {
  /// The condition to display.
  final Condition condition;

  const ConditionDetail(
    this.condition, {
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
              condition.icon,
              size: 10.0,
            ),
            Text(
              ' ' + // give some extra space
                  condition.condition.truncate(24, ellipsis: '...'),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
            ),
            Text(
              condition.source.name.truncate(18, ellipsis: "…") +
                  ' (' +
                  condition.distance.toStringAsFixed(1) +
                  condition.distanceUnit +
                  ')',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.schedule,
              size: 10.0,
            ),
            Text(
              condition.creation.format('d MMM h:mm'),
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
