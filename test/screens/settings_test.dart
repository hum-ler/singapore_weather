import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:singapore_weather/config.dart';
import 'package:singapore_weather/generated/l10n.dart';
import 'package:singapore_weather/screens/settings.dart';
import 'package:singapore_weather/services/preferences.dart';

import 'settings_test.mocks.dart';

@GenerateMocks([Preferences])
main() {
  group('Settings screen:', () {
    testWidgets('all supported color themes are listed',
        (WidgetTester tester) async {
      final MockPreferences prefs = MockPreferences();
      when(prefs.darkColor).thenReturn(supportedThemes.entries.first.value[0]);
      when(prefs.lightColor).thenReturn(supportedThemes.entries.first.value[1]);
      when(prefs.dispose()).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<Preferences>(
          create: (context) => prefs,
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Settings(),
          ),
        ),
      );
      await tester.pump();

      // See https://github.com/flutter/flutter/issues/58876.
      Type typeOf<T>() => T;
      expect(
        find.byType(typeOf<DropdownMenuItem<Color>>()),
        findsNWidgets(supportedThemes.length),
      );

      // Pull the colors from the menu items.
      Iterable<List<Color>> colors = tester
          .elementList(find.byType(typeOf<DropdownMenuItem<Color>>()))
          .map((e) {
        final DropdownMenuItem menuItem = e.widget as DropdownMenuItem;
        final Row row = menuItem.child as Row;
        final Color darkColor = (row.children[0] as Container).color!;
        final Color lightColor = (row.children[1] as Container).color!;

        return [darkColor, lightColor];
      });

      expect(colors.length, equals(supportedThemes.length));
      expect(colors, equals(supportedThemes.values));
    });

    testWidgets('color theme selected => Preferences.setTheme()',
        (WidgetTester tester) async {
      final MockPreferences prefs = MockPreferences();
      when(prefs.darkColor).thenReturn(supportedThemes.entries.first.value[0]);
      when(prefs.lightColor).thenReturn(supportedThemes.entries.first.value[1]);
      when(prefs.dispose()).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<Preferences>(
          create: (context) => prefs,
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            locale: const Locale('en'),
            home: Settings(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Type typeOf<T>() => T;
      expect(
        find.byType(typeOf<DropdownMenuItem<Color>>()),
        findsNWidgets(supportedThemes.length),
      );

      // Open the menu.
      await tester.tap(find.byType(typeOf<DropdownButton<Color>>()));
      await tester.pump();

      // Tap the last menu item.
      await tester.tap(find.byType(typeOf<DropdownMenuItem<Color>>()).last);
      await tester.pump();

      verify(
        prefs.setTheme(
          darkColor: supportedThemes.entries.last.value[0],
          lightColor: supportedThemes.entries.last.value[1],
        ),
      );

      // Open the menu again.
      await tester.tap(find.byType(typeOf<DropdownButton<Color>>()));
      await tester.pump();

      // Tap the 5th menu item. There are 2 sets of menu items created, only the
      // second set works when tapped.
      assert(supportedThemes.length >= 5);
      final int fifthIndex = supportedThemes.length + 4;
      await tester
          .tap(find.byType(typeOf<DropdownMenuItem<Color>>()).at(fifthIndex));
      await tester.pump();

      verify(
        prefs.setTheme(
          darkColor: supportedThemes.values.elementAt(4)[0],
          lightColor: supportedThemes.values.elementAt(4)[1],
        ),
      );
    });
  });
}
