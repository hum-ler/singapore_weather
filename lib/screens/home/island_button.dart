import 'package:flutter/material.dart';

import '../../config.dart' as K;

/// Draws a circular button with the silhouette of Singapore inside it.
class IslandButton extends StatelessWidget {
  /// The size of the button.
  ///
  /// Defaults to 48.0.
  final double size;

  /// The callback function when the button is pressed.
  final void Function()? onPressed;

  const IslandButton({
    this.size = 48.0,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(side: BorderSide.none),
      constraints: BoxConstraints(
        maxHeight: size,
        minHeight: size,
        maxWidth: size,
        minWidth: size,
      ),
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? K.appLightColor
          : K.appDarkColor,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: size,
        child: Hero(
          tag: K.islandImageTag,
          child: Image(
            image: K.islandImage,
            color: Theme.of(context).brightness == Brightness.dark
                ? K.appDarkColor
                : K.appLightColor,
            colorBlendMode: BlendMode.srcIn,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
