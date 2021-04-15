import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';
import 'models/weather_model.dart';
import 'screens/home.dart';
import 'services/geolocation.dart';
import 'services/preferences.dart';
import 'services/weather.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherModel>(
          create: (context) => WeatherModel(),
        ),
        FutureProvider<SharedPreferences?>(
          create: (context) => SharedPreferences.getInstance(),
          initialData: null,
        ),
        ChangeNotifierProxyProvider<SharedPreferences?, Preferences>(
          create: (context) => Preferences(null),
          update: (context, shared, prefs) => Preferences(shared),
        ),
        Provider<Location>(
          create: (context) => Location(),
        ),
        ProxyProvider<Location, Geolocation>(
          update: (context, location, geolocation) => Geolocation(location),
        ),
        ProxyProvider2<WeatherModel, Geolocation, Weather>(
          update: (context, data, location, weather) => Weather(data, location),
        ),
      ],
      child: Consumer<Preferences>(
        builder: (context, prefs, child) => MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: prefs.lightColor,
            accentColor: prefs.darkColor,
            snackBarTheme: SnackBarThemeData(
              backgroundColor: ThemeData.light().canvasColor,
              contentTextStyle: TextStyle(color: Colors.black),
              actionTextColor: prefs.darkColor,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: prefs.darkColor,
            accentColor: prefs.lightColor,
            snackBarTheme: SnackBarThemeData(
              backgroundColor: ThemeData.dark().canvasColor,
              contentTextStyle: TextStyle(color: Colors.white),
              actionTextColor: prefs.lightColor,
            ),
          ),
          home: Home(),
        ),
      ),
    ),
  );
}
