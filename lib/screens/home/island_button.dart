import 'package:flutter/material.dart';

import '../../config.dart' as K;

/// Draws a circular button with the silhouette of Singapore inside it.
///
/// The button is 48.0 wide.
class IslandButton extends StatelessWidget {
  final void Function()? onPressed;

  const IslandButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(side: BorderSide.none),
      constraints: BoxConstraints(
        maxHeight: 48.0,
        minHeight: 48.0,
        maxWidth: 48.0,
        minWidth: 48.0,
      ),
      fillColor: K.appSecondaryColor,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 48.0,
        child: Hero(
          tag: K.islandImageTag,
          child: Image(
            image: K.islandImage,
            color: K.appPrimaryColor,
            colorBlendMode: BlendMode.srcIn,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
