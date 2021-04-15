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

/// Converts from direction string to degrees clockwise from North.
///
/// Returns null if [direction] is not recognized.
num? cardinalDirectionToAzimuth(String direction) {
  return {
    'n': 0,
    'nne': 22.5,
    'ne': 45,
    'ene': 67.5,
    'e': 90,
    'ese': 112.5,
    'se': 135,
    'sse': 157.5,
    's': 180,
    'ssw': 202.5,
    'sw': 225,
    'wsw': 247.5,
    'w': 270,
    'wnw': 292.5,
    'nw': 315,
    'nnw': 337.5,
  }[direction.toLowerCase()];
}
