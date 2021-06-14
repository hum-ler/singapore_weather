import 'package:json_annotation/json_annotation.dart';

/// Converts a DateTime from JSON.
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    // The weather service will sometimes return an empty string.
    if (json.isEmpty) return DateTime.now().toUtc();

    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) => throw UnimplementedError();
}
