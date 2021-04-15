import 'package:flutter/material.dart';
import 'wrapped_icon.dart';

/// Displays an icon with a label underneath.
class ForecastTile extends StatelessWidget {
  /// The icon to display.
  ///
  /// Usually the icon for a forecast.
  final IconData icon;

  /// The label text to display.
  ///
  /// Usually the type of a forecast.
  final String label;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// The style of the label.
  final TextStyle? labelStyle;

  /// The size of the space between the icon and the label.
  ///
  /// Defaults to 4.0.
  final double? spacerSize;

  /// The minimun width for the tile.
  ///
  /// Defaults to 74.0.
  final double? minWidth;

  /// The minimum height for the tile.
  ///
  /// Defaults to 74.0.
  final double? minHeight;

  ForecastTile(
    this.icon,
    this.label, {
    this.iconSize,
    this.iconColor,
    this.labelStyle,
    this.spacerSize,
    this.minWidth,
    this.minHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 74.0,
        minHeight: minHeight ?? 74.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          WrappedIcon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          SizedBox(height: spacerSize ?? 4.0),
          Text(
            label,
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}
