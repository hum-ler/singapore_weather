import 'package:json_annotation/json_annotation.dart';

part 'json_2_hour_forecast_model.g.dart';

/// Model of the 2-hour forecast data as returned (in JSON) by the weather
/// service.
@JsonSerializable()
class Json2HourForecastModel {
  @JsonKey(name: 'area_metadata')
  final List<Json2HourForecastAreaMetadata> areaMetadata;

  final List<Json2HourForecastItem> items;

  @JsonKey(name: 'api_info')
  final Json2HourForecastApiInfo apiInfo;

  Json2HourForecastModel({
    required this.areaMetadata,
    required this.items,
    required this.apiInfo,
  });

  factory Json2HourForecastModel.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastModelFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastAreaMetadata {
  final String name;

  @JsonKey(name: 'label_location')
  final Json2HourForecastLabelLocation labelLocation;

  Json2HourForecastAreaMetadata({
    required this.name,
    required this.labelLocation,
  });

  factory Json2HourForecastAreaMetadata.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastAreaMetadataFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastLabelLocation {
  final double latitude;

  final double longitude;

  Json2HourForecastLabelLocation({
    required this.latitude,
    required this.longitude,
  });

  factory Json2HourForecastLabelLocation.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastLabelLocationFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastItem {
  @JsonKey(name: 'update_timestamp')
  final DateTime updateTimestamp;

  final DateTime timestamp;

  @JsonKey(name: 'valid_period')
  final Json2HourForecastValidPeriod validPeriod;

  final List<Json2HourForecastData> forecasts;

  Json2HourForecastItem({
    required this.updateTimestamp,
    required this.timestamp,
    required this.validPeriod,
    required this.forecasts,
  });

  factory Json2HourForecastItem.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastItemFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastValidPeriod {
  final DateTime start;

  final DateTime end;

  Json2HourForecastValidPeriod({
    required this.start,
    required this.end,
  });

  factory Json2HourForecastValidPeriod.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastValidPeriodFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastData {
  final String area;

  final String forecast;

  Json2HourForecastData({
    required this.area,
    required this.forecast,
  });

  factory Json2HourForecastData.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastDataFromJson(json);
  }
}

@JsonSerializable()
class Json2HourForecastApiInfo {
  final String status;

  Json2HourForecastApiInfo({required this.status});

  factory Json2HourForecastApiInfo.fromJson(Map<String, dynamic> json) {
    return _$Json2HourForecastApiInfoFromJson(json);
  }
}
