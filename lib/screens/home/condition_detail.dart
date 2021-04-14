import 'package:flutter/material.dart';

import '../../config.dart' as K;
import '../../models/condition.dart';
import '../../utils/intl_utils.dart';
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
                  condition.condition.truncate(
                    K.detailsWeatherConditionLength,
                    ellipsis: K.truncationEllipsis,
                  ),
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.place,
              size: 10.0,
              color: condition.isNearby
                  ? null
                  : Theme.of(context).textTheme.headline1!.color,
            ),
            Text(
              condition.source.name.truncate(
                    K.detailsSourceNameLength,
                    ellipsis: K.truncationEllipsis,
                  ) +
                  ' (' +
                  condition.distance.format() +
                  condition.distanceUnit +
                  ')',
              style: TextStyle(
                fontSize: 12.0,
                color: condition.isNearby
                    ? null
                    : Theme.of(context).textTheme.headline1!.color,
              ),
            ),
            SizedBox(width: 4.0),
            WrappedIcon(
              Icons.schedule,
              size: 10.0,
              color: !condition.isExpired
                  ? null
                  : Theme.of(context).textTheme.headline1!.color,
            ),
            Text(
              condition.creation.format(),
              style: TextStyle(
                fontSize: 12.0,
                color: !condition.isExpired
                    ? null
                    : Theme.of(context).textTheme.headline1!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
