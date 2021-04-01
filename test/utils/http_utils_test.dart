import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:singapore_weather/utils/http_utils.dart';

import 'http_utils_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('httpGetJsonData():', () {
    const String someUrl = 'https://some.url';
    const String someHtml = '<!DOCTYPE html><html />';
    const String someJson = '{"key": "value"}';

    test('no such host => null', () {
      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenThrow(SocketException(''));

      expect(httpGetJsonData(someUrl, client), completion(isNull));
    });

    test('404 => null', () {
      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', HttpStatus.notFound));

      expect(httpGetJsonData(someUrl, client), completion(isNull));
    });

    test('non-JSON result => null', () {
      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(someHtml, HttpStatus.ok));

      expect(httpGetJsonData(someUrl, client), completion(isNull));
    });

    test('JSON result', () {
      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(someJson, HttpStatus.ok));

      expect(
        httpGetJsonData(someUrl, client),
        completion(allOf([isNotNull, isNotEmpty])),
      );
    });

    test('timeout => null', () {
      final MockClient client = MockClient();
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) => Future<Response>.delayed(
                const Duration(seconds: 20),
                () => Response(someJson, HttpStatus.ok),
              ));

      expect(
        httpGetJsonData(
          someUrl,
          client,
          timeout: const Duration(milliseconds: 250),
        ),
        completion(isNull),
      );
    });
  });
}
