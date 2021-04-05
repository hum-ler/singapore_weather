import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

/// Wraps an icon in a similar fashion to [BoxedIcon].
///
/// Can be used to wrap the usual Flutter icons as well as WeatherIcons. In the
/// latter case, an actual [BoxedIcon] will be created.
class WrappedIcon extends StatelessWidget {
  /// The icon to be displayed.
  final IconData icon;

  /// The size of the icon.
  final double? size;

  /// The color of the icon.
  final Color? color;

  /// The angle of rotation (in radians) of the icon.
  final double? rotation;

  WrappedIcon(
    this.icon, {
    this.size,
    this.color,
    this.rotation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get a default size if one is not provided.
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size!;

    final Widget iconWidget;
    if (icon.fontFamily == 'WeatherIcons') {
      iconWidget = BoxedIcon(
        icon,
        size: iconSize,
        color: color,
      );
    } else {
      iconWidget = SizedBox(
        width: iconSize * 1.5,
        height: iconSize * 1.4,
        child: Icon(
          icon,
          size: iconSize,
          color: color,
        ),
      );
    }

    if (rotation != null) {
      return Transform.rotate(
        angle: rotation!,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
