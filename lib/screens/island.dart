import 'package:flutter/material.dart';

import '../config.dart' as K;
import '../generated/l10n.dart';
import 'island/forecast_grid.dart';

/// The island-wide forecast screen.
class Island extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).islandScreenTitle),
      ),
      body: Stack(
        children: [
          // The background color.
          Container(color: Theme.of(context).accentColor),

          // The map image.
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Hero(
              tag: K.islandImageTag,
              child: Image(
                image: K.islandImage,
                fit: BoxFit.fitHeight,
                color: Theme.of(context).primaryColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),

          // The forecast icons.
          ForecastGrid(),
        ],
      ),
    );
  }
}
