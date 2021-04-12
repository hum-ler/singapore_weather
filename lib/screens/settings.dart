import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../services/preferences.dart';

/// The settings screen.
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /// Hardcoded set of support themes.
  ///
  /// The dark color is used as the key.
  static final Map<Color, List<Color>> _themes = {
    Colors.black: [
      Colors.black,
      Colors.white,
    ],
    Colors.deepOrange.shade500: [
      Colors.deepOrange.shade500,
      Colors.deepOrange.shade200,
    ],
    Colors.grey.shade800: [
      Colors.grey.shade800,
      Colors.grey.shade400,
    ],
  };

  /// The list of DropdownMenuItems for theme selection.
  late final List<DropdownMenuItem<Color>> _items;

  /// The selected theme.
  Color? _theme;

  @override
  void initState() {
    super.initState();

    _items = _generateDropdownListItems();
  }

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
                value: _theme ?? prefs.darkColor,
                items: _items,
                icon: Container(),
                underline: Container(),
                onChanged: (v) => _onThemeSelected(v!, prefs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles a selected theme value.
  void _onThemeSelected(Color color, Preferences prefs) {
    setState(() {
      _theme = color;
    });
    prefs.setTheme(
      darkColor: _themes[color]![0],
      lightColor: _themes[color]![1],
    );
  }

  /// Generates list of theme selection DropdownMenuItems based on the content
  /// in [_themes].
  List<DropdownMenuItem<Color>> _generateDropdownListItems() {
    Iterable<List<Color>> values = _themes.values;

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
            ),
            Container(
              width: 64.0,
              height: 48.0,
              color: values.elementAt(i)[1],
            ),
          ],
        ),
      ),
    );
  }
}
