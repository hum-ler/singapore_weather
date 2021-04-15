import 'package:flutter/material.dart';

import '../../utils/intl_utils.dart';
import '../home/wrapped_icon.dart';

/// Draws a tile with predicted ranges for a weather reading type.
class PredictionTile extends StatelessWidget {
  /// The predicted high value for the range.
  final num high;

  /// The predicted low value for the range.
  final num low;

  /// The icon that represents the predicted type.
  final IconData icon;

  /// The unit for the predicted type.
  final String unit;

  /// The color to use for drawing the icon and text.
  final Color? color;

  const PredictionTile({
    required this.high,
    required this.low,
    required this.icon,
    required this.unit,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WrappedIcon(
                  icon,
                  size: 18.0,
                  color: color,
                ),
                Text(
                  unit,
                  style: TextStyle(color: color),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  high.format(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    height: 1.0,
                    width: 12.0,
                    color:
                        color ?? Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                Text(
                  low.format(),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
