import 'package:json_annotation/json_annotation.dart';

part 'json_pm2_5_model.g.dart';

/// Model of the PM2.5 data as returned (in JSON) by the weather service.
@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5Model {
  @JsonKey(name: 'region_metadata')
  final List<JsonPM2_5RegionMetadata> regionMetadata;

  final List<JsonPM2_5Item> items;

  @JsonKey(name: 'api_info')
  final JsonPM2_5ApiInfo apiInfo;

  JsonPM2_5Model({
    required this.regionMetadata,
    required this.items,
    required this.apiInfo,
  });

  factory JsonPM2_5Model.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5ModelFromJson(json);
  }
}

@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5RegionMetadata {
  final String name;

  @JsonKey(name: 'label_location')
  final JsonPM2_5LabelLocation labelLocation;

  JsonPM2_5RegionMetadata({
    required this.name,
    required this.labelLocation,
  });

  factory JsonPM2_5RegionMetadata.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5RegionMetadataFromJson(json);
  }
}

@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5LabelLocation {
  final double latitude;

  final double longitude;

  JsonPM2_5LabelLocation({
    required this.latitude,
    required this.longitude,
  });

  factory JsonPM2_5LabelLocation.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5LabelLocationFromJson(json);
  }
}

@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5Item {
  final DateTime timestamp;

  @JsonKey(name: 'update_timestamp')
  final DateTime updateTimestamp;

  final JsonPM2_5Readings readings;

  JsonPM2_5Item({
    required this.timestamp,
    required this.updateTimestamp,
    required this.readings,
  });

  factory JsonPM2_5Item.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5ItemFromJson(json);
  }
}

@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5Readings {
  @JsonKey(name: 'pm25_one_hourly')
  final Map<String, int> pm2_5OneHourly;

  JsonPM2_5Readings({required this.pm2_5OneHourly});

  factory JsonPM2_5Readings.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5ReadingsFromJson(json);
  }
}

@JsonSerializable()
// ignore: camel_case_types
class JsonPM2_5ApiInfo {
  final String status;

  JsonPM2_5ApiInfo({required this.status});

  factory JsonPM2_5ApiInfo.fromJson(Map<String, dynamic> json) {
    return _$JsonPM2_5ApiInfoFromJson(json);
  }
}
