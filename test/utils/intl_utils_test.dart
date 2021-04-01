import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:singapore_weather/utils/intl_utils.dart';

void main() {
  test('String.format()', () {
    Intl.withLocale('en-US', () {
      final DateTime value = DateTime.parse('2006-06-06T06:06:06');

      expect(
        value.format(pattern: 'yyyy-MM-ddTHH:mm:ss'),
        equals('2006-06-06T06:06:06'),
      );
      expect(value.format(pattern: 'd MMM h:mm'), equals('6 Jun 6:06'));
      expect(value.format(), equals('6 Jun 6:06'));
    });
  });

  test('num.format()', () {
    Intl.withLocale('en-US', () {
      const num d = 123456.789;

      expect(d.format(pattern: '#'), '123457');
      expect(d.format(pattern: '#.0'), '123456.8');
      expect(d.format(pattern: '#.####'), '123456.789');
      expect(d.format(pattern: '#.#'), '123456.8');
      expect(d.format(), '123456.8');

      const num i = 123456;

      expect(i.format(pattern: '#'), '123456');
      expect(i.format(pattern: '#.0'), '123456.0');
      expect(i.format(pattern: '#.####'), '123456');
      expect(i.format(pattern: '#.#'), '123456');
      expect(i.format(), '123456');
    });
  });
}
