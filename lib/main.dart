import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'config.dart' as K;
import 'generated/l10n.dart';
import 'models/weather_model.dart';
import 'screens/home.dart';
import 'services/geolocation.dart';
import 'services/weather.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherModel>(
          create: (context) => WeatherModel(),
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
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: K.appLightColor,
          accentColor: K.appDarkColor,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: ThemeData.light().canvasColor,
            contentTextStyle: TextStyle(color: Colors.black),
            actionTextColor: K.appDarkColor,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: K.appDarkColor,
          accentColor: K.appLightColor,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: ThemeData.dark().canvasColor,
            contentTextStyle: TextStyle(color: Colors.white),
            actionTextColor: K.appLightColor,
          ),
        ),
        home: Home(),
      ),
    ),
  );
}
