import 'dart:convert';

import 'package:http/http.dart';

import '../config.dart' as K;

/// Gets JSON data from the internet.
///
/// Caller must handle the closing of [client].
Future<dynamic> httpGetJsonData(
  Uri url,
  Client client, {
  Duration? timeout,
}) async {
  try {
    Response response = await client.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(timeout ?? K.httpGetJsonDataTimeout);

    if (response.statusCode == 200) return jsonDecode(response.body);
  } on Exception {}

  return null;
}
