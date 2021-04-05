import 'package:json_annotation/json_annotation.dart';

part 'json_24_hour_forecast_model.g.dart';

/// Model of the 24-hour forecast data as returned (in JSON) by the weather
/// service.
@JsonSerializable()
class Json24HourForecastModel {
  final List<Json24HourForecastItem> items;

  @JsonKey(name: 'api_info')
  final Json24HourForecastApiInfo apiInfo;

  Json24HourForecastModel({
    required this.items,
    required this.apiInfo,
  });

  factory Json24HourForecastModel.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastModelFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastItem {
  @JsonKey(name: 'update_timestamp')
  final DateTime updateTimestamp;

  final DateTime timestamp;

  @JsonKey(name: 'valid_period')
  final Json24HourForecastStartEnd validPeriod;

  final Json24HourForecastGeneral general;

  final List<Json24HourForecastPeriod> periods;

  Json24HourForecastItem({
    required this.updateTimestamp,
    required this.timestamp,
    required this.validPeriod,
    required this.general,
    required this.periods,
  });

  factory Json24HourForecastItem.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastItemFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastStartEnd {
  final DateTime start;

  final DateTime end;

  Json24HourForecastStartEnd({
    required this.start,
    required this.end,
  });

  factory Json24HourForecastStartEnd.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastStartEndFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastGeneral {
  final String forecast;

  @JsonKey(name: 'relative_humidity')
  final Json24HourForecastLowHigh relativeHumidity;

  final Json24HourForecastLowHigh temperature;

  final Json24HourForecastWind wind;

  Json24HourForecastGeneral({
    required this.forecast,
    required this.relativeHumidity,
    required this.temperature,
    required this.wind,
  });

  factory Json24HourForecastGeneral.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastGeneralFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastLowHigh {
  final int low;

  final int high;

  Json24HourForecastLowHigh({
    required this.low,
    required this.high,
  });

  factory Json24HourForecastLowHigh.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastLowHighFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastWind {
  final Json24HourForecastLowHigh speed;

  final String direction;

  Json24HourForecastWind({
    required this.speed,
    required this.direction,
  });

  factory Json24HourForecastWind.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastWindFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastPeriod {
  final Json24HourForecastStartEnd time;

  final Map<String, String> regions;

  Json24HourForecastPeriod({
    required this.time,
    required this.regions,
  });

  factory Json24HourForecastPeriod.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastPeriodFromJson(json);
  }
}

@JsonSerializable()
class Json24HourForecastApiInfo {
  final String status;

  Json24HourForecastApiInfo({required this.status});

  factory Json24HourForecastApiInfo.fromJson(Map<String, dynamic> json) {
    return _$Json24HourForecastApiInfoFromJson(json);
  }
}
