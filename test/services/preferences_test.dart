import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singapore_weather/services/preferences.dart';

import 'preferences_test.mocks.dart';

@GenerateMocks([SharedPreferences])
main() {
  group('Preferences:', () {
    test('modifications => notify listeners', () async {
      // Colors are saved as 3 (R, G and B) int values.
      final MockSharedPreferences shared = MockSharedPreferences();
      when(shared.getInt(any)).thenReturn(0);
      when(shared.setInt(any, any)).thenAnswer((_) async => true);

      final Preferences prefs = Preferences(shared);

      // Test setDarkColor().
      Completer completer = Completer();
      prefs.addListener(() => completer.complete());

      await prefs.setDarkColor(Colors.purple.shade800);

      expectLater(completer.isCompleted, isTrue);

      // Test setLightColor().
      completer = Completer();

      await prefs.setLightColor(Colors.purple.shade200);

      expectLater(completer.isCompleted, isTrue);

      // Test setTheme().
      completer = Completer();

      await prefs.setTheme(
        darkColor: Colors.purple.shade900,
        lightColor: Colors.purple.shade100,
      );

      expect(completer.isCompleted, isTrue);
    });

    test('sharePrefererences == null => safe when called', () async {
      final Preferences prefs = Preferences(null);

      // Test setDarkColor().
      Completer completer = Completer();
      prefs.addListener(() => completer.complete());

      await prefs.setDarkColor(Colors.purple.shade800);

      expectLater(completer.isCompleted, isFalse);

      // Test setLightColor().
      await prefs.setLightColor(Colors.purple.shade200);

      expectLater(completer.isCompleted, isFalse);

      // Test setTheme().
      await prefs.setTheme(
        darkColor: Colors.purple.shade900,
        lightColor: Colors.purple.shade100,
      );

      expect(completer.isCompleted, isFalse);

      expect(prefs.darkColor, isA<Color>());
      expect(prefs.lightColor, isA<Color>());
    });
    test('colors are loaded at startup', () {
      // Colors are saved as 3 (R, G and B) int values. The keys are found in
      // _PreferencesKey class.
      final MockSharedPreferences shared = MockSharedPreferences();
      when(shared.getInt('darkColorR')).thenReturn(11);
      when(shared.getInt('darkColorG')).thenReturn(12);
      when(shared.getInt('darkColorB')).thenReturn(13);
      when(shared.getInt('lightColorR')).thenReturn(91);
      when(shared.getInt('lightColorG')).thenReturn(92);
      when(shared.getInt('lightColorB')).thenReturn(93);

      final Preferences prefs = Preferences(shared);

      verify(shared.getInt(any)).called(6);
      expect(prefs.darkColor, equals(Color.fromARGB(255, 11, 12, 13)));
      expect(prefs.lightColor, equals(Color.fromARGB(255, 91, 92, 93)));
    });
  });

  test('Preferences.setDarkColor()', () async {
    final MockSharedPreferences shared = MockSharedPreferences();
    when(shared.getInt(any)).thenReturn(0);
    when(shared.setInt(any, any)).thenAnswer((_) async => true);

    final Preferences prefs = Preferences(shared);

    await prefs.setDarkColor(Colors.grey.shade500);

    verify(shared.setInt(any, any)).called(3);
    expect(prefs.darkColor, equals(Colors.grey.shade500));

    await prefs.setDarkColor(Colors.grey.shade900);

    verify(shared.setInt(any, any)).called(3);
    expect(prefs.darkColor, equals(Colors.grey.shade900));
  });

  test('Preferences.setLightColor()', () async {
    final MockSharedPreferences shared = MockSharedPreferences();
    when(shared.getInt(any)).thenReturn(0);
    when(shared.setInt(any, any)).thenAnswer((_) async => true);

    final Preferences prefs = Preferences(shared);

    await prefs.setLightColor(Colors.grey.shade500);

    verify(shared.setInt(any, any)).called(3);
    expect(prefs.lightColor, equals(Colors.grey.shade500));

    await prefs.setLightColor(Colors.grey.shade100);

    verify(shared.setInt(any, any)).called(3);
    expect(prefs.lightColor, equals(Colors.grey.shade100));
  });

  test('Preferences.setTheme()', () async {
    final MockSharedPreferences shared = MockSharedPreferences();
    when(shared.getInt(any)).thenReturn(0);
    when(shared.setInt(any, any)).thenAnswer((_) async => true);

    final Preferences prefs = Preferences(shared);

    await prefs.setTheme(
      darkColor: Colors.grey.shade800,
      lightColor: Colors.grey.shade200,
    );

    verify(shared.setInt(any, any)).called(6);
    expect(prefs.darkColor, equals(Colors.grey.shade800));
    expect(prefs.lightColor, equals(Colors.grey.shade200));

    await prefs.setTheme(
      darkColor: Colors.grey.shade900,
      lightColor: Colors.grey.shade100,
    );

    verify(shared.setInt(any, any)).called(6);
    expect(prefs.darkColor, equals(Colors.grey.shade900));
    expect(prefs.lightColor, equals(Colors.grey.shade100));
  });
}
