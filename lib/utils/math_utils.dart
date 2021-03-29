import 'dart:math';

/// Converts from degrees to radians.
double degreesToRadians(double deg) => deg * pi / 180;

/// Converts from knots to meters per second.
///
/// See https://en.wikipedia.org/wiki/Knot_(unit).
double knotsToMetersPerSecond(double knots) => knots * 0.514444;

/// Converts from degree Celsius to Fahrenheit.
///
/// See https://en.wikipedia.org/wiki/Conversion_of_units_of_temperature.
double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;

/// Calculates the haversin of a value.
double haversin(double rad) => (1 - cos(rad)) / 2;
