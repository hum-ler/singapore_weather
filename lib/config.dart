import 'package:flutter/material.dart';

//#region models/condition

/// The validity period for a condition.
const Duration conditionValidityPeriod = Duration(hours: 2);

/// The default background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage defaultAssetImage = AssetImage('assets/images/default.webp');

/// The cloudy background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage cloudAssetImage = AssetImage('assets/images/cloud.webp');

/// The daytime background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage dayAssetImage = AssetImage('assets/images/day.webp');

/// The lightning background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage lightningAssetImage =
    AssetImage('assets/images/lightning.webp');

/// The nighttime background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage nightAssetImage = AssetImage('assets/images/night.webp');

/// The rainy background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage rainAssetImage = AssetImage('assets/images/rain.webp');

/// The windy background image asset.
///
/// Image must be found inside the assets/images folder.
const AssetImage windAssetImage = AssetImage('assets/images/wind.webp');

//#endregion

//#region models/forecast

/// The validity period for a 2-hour-block forecast.
const Duration forecast2HourBlockValidityPeriod = Duration(hours: 2);

/// The validity period for a 6-hour-block forecast.
const Duration forecast6HourBlockValidityPeriod = Duration(hours: 6);

//#endregion

//#region models/source

/// The effective range (in km) for a station source.
const double stationEffectiveRange = 10.0;

/// The effective range (in km) for an area source.
const double areaEffectiveRange = 10.0;

/// The effective range (in km) for a region source.
const double regionEffectiveRange = 20.0;

//#endregion

//#region models/reading

/// The validity period for a temperature reading.
const Duration temperatureReadingValidityPeriod = Duration(minutes: 10);

/// The validity period for a rainfall reading.
const Duration rainReadingValidityPeriod = Duration(minutes: 20);

/// The validity period for a relative humidity reading.
const Duration humidityReadingValidityPeriod = Duration(minutes: 10);

/// The validity period for a wind speed reading.
const Duration windSpeedReadingValidityPeriod = Duration(minutes: 10);

/// The validity period for a wind direction reading.
const Duration windDirectionReadingValidityPeriod = Duration(minutes: 10);

/// The validity period for a PM2.5 reading.
const Duration pm2_5ReadingValidityPeriod = Duration(hours: 1, minutes: 10);

//#endregion

//#region screens/home/details

/// The maximum length for a weather condition when displayed in the details.
///
/// A condition that is longer than this value will be truncated.
///
/// Note that this length *includes* the size of [truncationEllipsis].
const int detailsWeatherConditionLength = 24;

/// The maximum length for a source name when displayed in the details.
///
/// A name that is longer than this value will be truncated.
///
/// Note that this length *includes* the size of [truncationEllipsis].
const int detailsSourceNameLength = 18;

/// The ellipsis that is displayed when a string is truncated.
const String truncationEllipsis = '???';

//#endregion

//#region screens/island

/// The island image asset.
///
/// This is a transparent PNG of the silhouette of Singapore island.
const AssetImage islandImage = AssetImage('assets/images/island.png');

/// The hero tag for [islandImage].
const String islandImageTag = 'island';

//#endregion

//#region screens/settings

/// The supported themes for the app.
///
/// This is a map of (key) dark color => \[dark color, light color\].
///
/// To force all values to be Colors, not MaterialColor (this is important for
/// the map keys), use the 500 shade for MaterialColors.
final Map<Color, List<Color>> supportedThemes = {
  Colors.black: [
    Colors.black,
    Colors.white,
  ],
  Colors.pink.shade600: [
    Colors.pink.shade600,
    Colors.pink.shade100,
  ],
  Colors.red.shade500: [
    Colors.red.shade500,
    Colors.red.shade100,
  ],
  appDarkColor: [
    appDarkColor, // Colors.deepOrange.shade500
    appLightColor, // Colors.deepOrange.shade200
  ],
  Colors.green.shade700: [
    Colors.green.shade700,
    Colors.green.shade200,
  ],
  Colors.lightBlue.shade900: [
    Colors.lightBlue.shade900,
    Colors.lightBlue.shade200,
  ],
  Colors.blueGrey.shade700: [
    Colors.blueGrey.shade700,
    Colors.blueGrey.shade200,
  ],
  Colors.grey.shade800: [
    Colors.grey.shade800,
    Colors.grey.shade400,
  ],
};

//#endregion

//#region services/geolocation

/// The timeout when calling Location.getLocation().
const Duration getLocationTimeout = Duration(seconds: 10);

//#endregion

//#region services/preferences

/// The default dark color for the app.
///
/// Used as the primary color in the dark theme, and the accent color in the
/// light theme.
///
/// Guaranteed to be inside [supportedThemes].
final Color appDarkColor = Colors.deepOrange.shade500;

/// The default light color for the app.
///
/// Used as the primary color in the light theme, and the accent color in the
/// dark theme.
///
/// Guaranteed to be inside [supportedThemes].
final Color appLightColor = Colors.deepOrange.shade200;

//#endregion

//#region services/weather

/// The URL of realtime air temperature readings API (at Data.gov.sg).
///
/// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is ??C.
///
/// See https://data.gov.sg/dataset/realtime-weather-readings.
final Uri temperatureUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/air-temperature');

/// The URL of realtime rainfall readings API (at Data.gov.sg).
///
/// Updates every 5 minutes. Takes parameter date_time=<ISO8601>. Unit is mm.
///
/// See https://data.gov.sg/dataset/realtime-weather-readings.
final Uri rainUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/rainfall');

/// The URL of realtime relative humidity readings API (at Data.gov.sg).
///
/// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is %.
///
/// See https://data.gov.sg/dataset/realtime-weather-readings.
final Uri humidityUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/relative-humidity');

/// The URL of realtime wind speed readings API (at Data.gov.sg).
///
/// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is knot.
///
/// See https://data.gov.sg/dataset/realtime-weather-readings.
final Uri windSpeedUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/wind-speed');

/// The URL of realtime wind direction readings API (at Data.gov.sg).
///
/// Updates every 1 minute. Takes parameter date_time=<ISO8601>. Unit is ??.
///
/// See https://data.gov.sg/dataset/realtime-weather-readings.
final Uri windDirectionUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/wind-direction');

/// The URL of the PM2.5 API (at Data.gov.sg).
///
/// Takes parameter date_time=<ISO8601>.
///
/// See https://data.gov.sg/dataset/pm2-5.
final Uri pm2_5Url = Uri.parse('https://api.data.gov.sg/v1/environment/pm25');

/// The URL of the 2-hour weather forecast API (at Data.gov.sg).
///
/// Updates every 30 minutes. Takes parameter date_time=<ISO8601>.
///
/// See https://data.gov.sg/dataset/weather-forecast.
final Uri forecast2HourUrl =
    Uri.parse('https://api.data.gov.sg/v1/environment/2-hour-weather-forecast');

/// The URL of the 24-hour weather forecast API (at Data.gov.sg).
///
/// Takes parameter date_time=<ISO8601>.
///
/// See https://data.gov.sg/dataset/weather-forecast.
final Uri forecast24HourUrl = Uri.parse(
    'https://api.data.gov.sg/v1/environment/24-hour-weather-forecast');

//#endregion

//#region utils/http_utils

/// The default timeout when calling Client.get().
const Duration httpGetJsonDataTimeout = Duration(seconds: 10);

//#endregion
