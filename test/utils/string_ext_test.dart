import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/utils/string_ext.dart';

void main() {
  group('String.truncate():', () {
    const String longString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    test('invalid maxLength => ArgumentError', () {
      expect(() => longString.truncate(0), throwsArgumentError);
      expect(() => longString.truncate(-1), throwsArgumentError);
    });

    test('null ellipsis equals no ellipsis', () {
      expect(
        longString.truncate(10),
        equals(longString.substring(0, 10)),
      );

      expect(
        longString.truncate(10, ellipsis: null),
        equals(longString.substring(0, 10)),
      );

      expect(
        longString.truncate(10, ellipsis: ''),
        equals(longString.substring(0, 10)),
      );
    });

    test('invalid ellipsis => ArgumentError', () {
      expect(() => 'abc'.truncate(2, ellipsis: '...'), throwsArgumentError);
      expect(() => 'abc'.truncate(3, ellipsis: '...'), throwsArgumentError);
      expect(() => 'abc'.truncate(3, ellipsis: '....'), throwsArgumentError);
    });

    test('valid input', () {
      const String shortString = 'abcde';

      expect(longString.truncate(5), equals('ABCDE'));

      expect(shortString.truncate(5), equals(shortString));
      expect(shortString.truncate(10), equals(shortString));

      expect(shortString.truncate(6, ellipsis: '...'), equals('abcde'));
      expect(shortString.truncate(5, ellipsis: '...'), equals('abcde'));
      expect(shortString.truncate(4, ellipsis: '.'), equals('abc.'));
      expect(shortString.truncate(4, ellipsis: '..'), equals('ab..'));
      expect(shortString.truncate(4, ellipsis: '...'), equals('a...'));
    });
  });

  test('String.asEnumLabel()', () {
    expect(''.asEnumLabel(), equals(''));
    expect('a'.asEnumLabel(), equals('a'));
    expect('aa'.asEnumLabel(), equals('aa'));
    expect('aa.b'.asEnumLabel(), equals('b'));
    expect('aa.bb'.asEnumLabel(), equals('bb'));
    expect('a.b.c'.asEnumLabel(), equals('b.c'));
  });

  test('String.capitalize()', () {
    expect(''.capitalize(), equals(''));
    expect('a'.capitalize(), equals('A'));
    expect('A'.capitalize(), equals('A'));
    expect('ab'.capitalize(), equals('Ab'));
    expect('abc'.capitalize(), equals('Abc'));
    expect('.abc'.capitalize(), equals('.abc'));
  });
}
