import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart' as K;
import '../generated/l10n.dart';
import '../services/preferences.dart';

/// The settings screen.
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /// The selected theme.
  Color? _theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).settingsScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).settingsThemeLabel,
              style: TextStyle(fontSize: 18.0),
            ),
            Consumer<Preferences>(
              builder: (context, prefs, child) => DropdownButton<Color>(
                value: _theme ??
                    // Make sure that previously saved value is valid.
                    (K.supportedThemes[prefs.darkColor] != null
                        ? prefs.darkColor
                        : K.appDarkColor),
                items: _generateDropdownListItems(context),
                icon: Container(),
                underline: Container(),
                onChanged: (v) => _onThemeSelected(v, prefs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles a selected theme value.
  void _onThemeSelected(Color? color, Preferences prefs) {
    if (color != null) {
      setState(() {
        _theme = color;
      });

      prefs.setTheme(
        darkColor: K.supportedThemes[color]![0],
        lightColor: K.supportedThemes[color]![1],
      );
    }
  }

  /// Generates list of theme selection DropdownMenuItems based on the content
  /// in [_themes].
  List<DropdownMenuItem<Color>> _generateDropdownListItems(
    BuildContext context,
  ) {
    final Iterable<List<Color>> values = K.supportedThemes.values;

    return List.generate(
      values.length,
      (i) => DropdownMenuItem(
        value: values.elementAt(i)[0],
        child: Row(
          children: [
            Container(
              width: 64.0,
              height: 48.0,
              color: values.elementAt(i)[0],
              alignment: Alignment.center,
              child: Text(
                S.of(context).darkThemeSampleText,
                style: TextStyle(
                  fontSize: 18.0,
                  color: ThemeData.dark().textTheme.bodyText1!.color,
                ),
              ),
            ),
            Container(
              width: 64.0,
              height: 48.0,
              color: values.elementAt(i)[1],
              alignment: Alignment.center,
              child: Text(
                S.of(context).lightThemeSampleText,
                style: TextStyle(
                  fontSize: 18.0,
                  color: ThemeData.light().textTheme.bodyText1!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
