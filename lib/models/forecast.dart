import '../config.dart' as K;
import 'condition.dart';
import 'geoposition.dart';
import 'source.dart';

/// A predicted weather condition.
class Forecast extends Condition {
  /// The type of this forecast.
  final ForecastType type;

  /// The validity period of this condition.
  @override
  Duration get validityPeriod => _validityPeriod[type]!;

  /// The expiry time of this condition.
  @override
  final DateTime expiry;

  Forecast({
    required this.type,
    required DateTime creation,
    required String condition,
    required Source source,
    required Geoposition userLocation,
  })   : expiry = creation.add(_validityPeriod[type]!),
        super(
          creation: creation,
          condition: condition,
          source: source,
          userLocation: userLocation,
        );

  /// The validity periods for each [ForecastType].
  static const Map<ForecastType, Duration> _validityPeriod = {
    ForecastType.immediate: K.forecast2HourBlockValidityPeriod,
    ForecastType.predawn: K.forecast6HourBlockValidityPeriod,
    ForecastType.morning: K.forecast6HourBlockValidityPeriod,
    ForecastType.afternoon: K.forecast6HourBlockValidityPeriod,
    ForecastType.night: K.forecast6HourBlockValidityPeriod,
  };
}

/// The types of forecast.
enum ForecastType {
  // 2-hour forecast.
  immediate,

  // 24-hour forecast.
  predawn, // 12am to 6am.
  morning, // 6am to 12pm.
  afternoon, // 12pm to 6pm.
  night, // 6pm to 6am, or 6pm to 12am if predawn is present.
}
