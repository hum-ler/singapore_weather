import 'package:flutter/material.dart';

/// Draws the handle to pull up the bottom sheet on the main screen.
class Handle extends StatelessWidget {
  const Handle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250.0,
          color: Colors.transparent,
        ),
        Icon(Icons.drag_handle),
      ],
    );
  }
}
