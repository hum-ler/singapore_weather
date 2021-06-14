import 'package:json_annotation/json_annotation.dart';

import 'date_time_converter.dart';

part 'json_reading_model.g.dart';

/// Model of the reading data as returned (in JSON) by the weather service.
@JsonSerializable()
class JsonReadingModel {
  final JsonReadingMetadata metadata;

  final List<JsonReadingItem> items;

  @JsonKey(name: 'api_info')
  final JsonReadingApiInfo apiInfo;

  JsonReadingModel({
    required this.metadata,
    required this.items,
    required this.apiInfo,
  });

  factory JsonReadingModel.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingModelFromJson(json);
  }
}

@JsonSerializable()
class JsonReadingMetadata {
  final List<JsonReadingStation> stations;

  @JsonKey(name: 'reading_type')
  final String? readingType;

  @JsonKey(name: 'reading_unit')
  final String? readingUnit;

  JsonReadingMetadata({
    required this.stations,
    this.readingType,
    this.readingUnit,
  });

  factory JsonReadingMetadata.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingMetadataFromJson(json);
  }
}

@JsonSerializable()
class JsonReadingStation {
  final String id;

  @JsonKey(name: 'device_id')
  final String deviceId;

  final String name;

  final JsonReadingLocation location;

  JsonReadingStation({
    required this.id,
    required this.deviceId,
    required this.name,
    required this.location,
  });

  factory JsonReadingStation.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingStationFromJson(json);
  }
}

@JsonSerializable()
class JsonReadingLocation {
  final double latitude;

  final double longitude;

  JsonReadingLocation({
    required this.latitude,
    required this.longitude,
  });

  factory JsonReadingLocation.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingLocationFromJson(json);
  }
}

@JsonSerializable()
@DateTimeConverter()
class JsonReadingItem {
  final DateTime timestamp;

  final List<JsonReadingData> readings;

  JsonReadingItem({
    required this.timestamp,
    required this.readings,
  });

  factory JsonReadingItem.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingItemFromJson(json);
  }
}

@JsonSerializable()
class JsonReadingData {
  @JsonKey(name: 'station_id')
  final String stationId;

  final num value;

  JsonReadingData({
    required this.stationId,
    required this.value,
  });

  factory JsonReadingData.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingDataFromJson(json);
  }
}

@JsonSerializable()
class JsonReadingApiInfo {
  final String status;

  JsonReadingApiInfo({required this.status});

  factory JsonReadingApiInfo.fromJson(Map<String, dynamic> json) {
    return _$JsonReadingApiInfoFromJson(json);
  }
}
