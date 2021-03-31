import 'package:flutter_test/flutter_test.dart';
import 'package:singapore_weather/utils/date_time_ext.dart';

void main() {
  const String value = '2006-06-06T06:06:06';

  test('String.format()', () {
    expect(DateTime.parse(value).format('yyyy-MM-ddTHH:mm:ss'), equals(value));
    expect(DateTime.parse(value).format('d MMM h:mm'), equals('6 Jun 6:06'));
  });
}
