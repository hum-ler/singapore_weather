import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart' as K;

/// The user preferences service.
class Preferences extends ChangeNotifier {
  /// Instance of SharedPreferences.
  late final SharedPreferences _sharedPreferences;

  /// The dark color for the app.
  ///
  /// Used as the primary color in the dark theme, and the accent color in the
  /// light theme.
  Color _darkColor = K.appDarkColor;

  /// The light color for the app.
  ///
  /// Used as the primary color in the light theme, and the accent color in the
  /// dark theme.
  Color _lightColor = K.appLightColor;

  /// The dark color for the app.
  ///
  /// Used as the primary color in the dark theme, and the accent color in the
  /// light theme.
  Color get darkColor => _darkColor;

  /// The light color for the app.
  ///
  /// Used as the primary color in the light theme, and the accent color in the
  /// dark theme.
  Color get lightColor => _lightColor;

  /// The dark color for the app.
  ///
  /// Used as the primary color in the dark theme, and the accent color in the
  /// light theme.
  set darkColor(Color color) => _setDarkColor(color);

  /// The light color for the app.
  ///
  /// Used as the primary color in the light theme, and the accent color in the
  /// dark theme.
  set lightColor(Color color) => _setLightColor(color);

  Preferences() {
    _initPreferences();
  }

  /// Loads preferences from disk.
  Future<void> _initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    // Read darkColor.
    final int? darkColorR =
        _sharedPreferences.getInt(_PreferenceKeys.darkColorR);
    final int? darkColorG =
        _sharedPreferences.getInt(_PreferenceKeys.darkColorG);
    final int? darkColorB =
        _sharedPreferences.getInt(_PreferenceKeys.darkColorB);
    if (darkColorR != null && darkColorG != null && darkColorB != null) {
      _darkColor = Color.fromRGBO(darkColorR, darkColorG, darkColorB, 1.0);
    }

    // Read lightColor.
    final int? lightColorR =
        _sharedPreferences.getInt(_PreferenceKeys.lightColorR);
    final int? lightColorG =
        _sharedPreferences.getInt(_PreferenceKeys.lightColorG);
    final int? lightColorB =
        _sharedPreferences.getInt(_PreferenceKeys.lightColorB);
    if (lightColorR != null && lightColorG != null && lightColorB != null) {
      _lightColor = Color.fromRGBO(lightColorR, lightColorG, lightColorB, 1.0);
    }

    notifyListeners();
  }

  /// Sets [darkColor] and saves to disk.
  Future<void> _setDarkColor(Color color) async {
    await _sharedPreferences.setInt(_PreferenceKeys.darkColorR, color.red);
    await _sharedPreferences.setInt(_PreferenceKeys.darkColorG, color.green);
    await _sharedPreferences.setInt(_PreferenceKeys.darkColorB, color.blue);

    _darkColor = darkColor;

    notifyListeners();
  }

  /// Sets [lightColor] and saves to disk.
  Future<void> _setLightColor(Color color) async {
    await _sharedPreferences.setInt(_PreferenceKeys.lightColorR, color.red);
    await _sharedPreferences.setInt(_PreferenceKeys.lightColorG, color.green);
    await _sharedPreferences.setInt(_PreferenceKeys.lightColorB, color.blue);

    _lightColor = lightColor;

    notifyListeners();
  }

  /// Sets both [darkColor] and [lightColor] and saves to disk.
  ///
  /// This method will only notify listeners one time.
  Future<void> setTheme({
    required Color darkColor,
    required Color lightColor,
  }) async {
    await _sharedPreferences.setInt(_PreferenceKeys.darkColorR, darkColor.red);
    await _sharedPreferences.setInt(
      _PreferenceKeys.darkColorG,
      darkColor.green,
    );
    await _sharedPreferences.setInt(_PreferenceKeys.darkColorB, darkColor.blue);

    await _sharedPreferences.setInt(
      _PreferenceKeys.lightColorR,
      lightColor.red,
    );
    await _sharedPreferences.setInt(
      _PreferenceKeys.lightColorG,
      lightColor.green,
    );
    await _sharedPreferences.setInt(
      _PreferenceKeys.lightColorB,
      lightColor.blue,
    );

    _darkColor = darkColor;
    _lightColor = lightColor;

    notifyListeners();
  }
}

/// The keys for saving preferences to disk.
abstract class _PreferenceKeys {
  // Prevent instantiation and extension.
  _PreferenceKeys._();

  /// The dark color red channel value.
  static const String darkColorR = 'darkColorR';

  /// The dark color green channel value.
  static const String darkColorG = 'darkColorG';

  /// The dark color blue channel value.
  static const String darkColorB = 'darkColorB';

  /// The light color red channel value.
  static const String lightColorR = 'lightColorR';

  /// The light color green channel value.
  static const String lightColorG = 'lightColorG';

  /// The light color blue channel value.
  static const String lightColorB = 'lightColorB';
}
