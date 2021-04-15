import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart' as K;
import '../../models/weather_model.dart';

/// Draws the background image on the main screen.
class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherModel>(
      builder: (context, data, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: data.condition?.background ?? K.defaultAssetImage,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white.withOpacity(0.6),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }
}
