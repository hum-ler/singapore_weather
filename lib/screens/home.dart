import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'about.dart';
import 'home/details.dart';
import 'home/handle.dart';
import 'home/summary.dart';

/// The main screen.
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Singapore Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => _onAboutPressed(context),
          ),
        ],
      ),
      body: ExpandableBottomSheet(
        animationCurveExpand: Curves.elasticOut,
        animationDurationExtend: const Duration(milliseconds: 300),
        animationCurveContract: Curves.elasticOut,
        animationDurationContract: const Duration(milliseconds: 300),
        background: Summary(),
        persistentHeader: Handle(),
        expandableContent: Details(),
      ),
    );
  }

  /// Handles a tap on the about icon in the app bar.
  void _onAboutPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => About()),
    );
  }
}
