import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../models/weather_model.dart';
import 'about.dart';
import 'home/background.dart';
import 'home/details.dart';
import 'home/handle.dart';
import 'home/island_button.dart';
import 'home/summary.dart';
import 'island.dart';
import 'settings.dart';

/// The main screen.
///
/// If the injected weather data is empty, a load is triggered after building.
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _onSettingsPressed(context),
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => _onAboutPressed(context),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // The background image.
          Background(),

          // The main body.
          Consumer<WeatherModel>(
            builder: (context, data, child) {
              // Force the recreation of ExpandableBottomSheet every time the
              // orientation is changed.
              return MediaQuery.of(context).orientation == Orientation.portrait
                  ? ExpandableBottomSheet(
                      key: UniqueKey(),
                      animationCurveExpand: Curves.elasticOut,
                      animationDurationExtend:
                          const Duration(milliseconds: 300),
                      animationCurveContract: Curves.elasticOut,
                      animationDurationContract:
                          const Duration(milliseconds: 300),

                      // Load data if it is empty.
                      background:
                          Summary(refreshDataAtStartUp: data.timestamp == null),

                      persistentHeader: Handle(),
                      expandableContent: Details(),
                    )
                  : ExpandableBottomSheet(
                      key: UniqueKey(),
                      animationCurveExpand: Curves.elasticOut,
                      animationDurationExtend:
                          const Duration(milliseconds: 300),
                      animationCurveContract: Curves.elasticOut,
                      animationDurationContract:
                          const Duration(milliseconds: 300),

                      // Load data if it is empty.
                      background:
                          Summary(refreshDataAtStartUp: data.timestamp == null),

                      persistentHeader: Handle(),
                      expandableContent: Details(),
                    );
            },
          ),

          // The island button.
          Positioned(
            top: 20.0,
            right: 20.0,
            child: IslandButton(
              size: 56.0,
              onPressed: () => _onIslandPressed(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles a tap on the settings icon in the app bar.
  void _onSettingsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  /// Handles a tap on the about icon in the app bar.
  void _onAboutPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => About()),
    );
  }

  /// Handles a tap on the island button.
  void _onIslandPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Island()),
    );
  }
}
