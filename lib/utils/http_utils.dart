import 'dart:convert';

import 'package:http/http.dart';

/// Gets JSON data from the internet.
///
/// Caller must handle the closing of [client].
Future<dynamic> httpGetJsonData(
  String url,
  Client client, {
  Duration? timeout,
}) async {
  try {
    Response response = await client.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    ).timeout(timeout ?? _httpGetJsonDataTimeout);

    if (response.statusCode == 200) return jsonDecode(response.body);
  } on Exception {}

  return null;
}

/// The timeout period for [httpGetJsonData()].
const Duration _httpGetJsonDataTimeout = Duration(seconds: 10);
