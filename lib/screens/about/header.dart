import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../generated/l10n.dart';

/// Draws the header (below the app bar) on the about screen.
class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  /// The app version number.
  String? version;

  @override
  void initState() {
    super.initState();

    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FittedBox(
            child: BoxedIcon(
              WeatherIcons.day_cloudy,
              size: 48.0,
            ),
            fit: BoxFit.fitHeight,
          ),
          SizedBox(width: 16.0),
          Text(
            S.of(context).appTitle + (version != null ? ' $version' : ''),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Retrieves the app version number.
  Future<void> _getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }
}
