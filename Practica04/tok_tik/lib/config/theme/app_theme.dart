import 'package:flutter/material.dart';

enum AppSeason { normal, halloween, christmas }

class AppTheme {
  AppSeason seasonAt(DateTime date) {
    if (_isInSeason(
      date,
      const String.fromEnvironment('HALLOWEEN_START', defaultValue: '10-01'),
      const String.fromEnvironment('HALLOWEEN_END', defaultValue: '11-01'),
    )) {
      return AppSeason.halloween;
    }

    if (_isInSeason(
      date,
      const String.fromEnvironment('CHRISTMAS_START', defaultValue: '12-01'),
      const String.fromEnvironment('CHRISTMAS_END', defaultValue: '12-31'),
    )) {
      return AppSeason.christmas;
    }

    return AppSeason.normal;
  }

  ThemeData getThemeForSeason(AppSeason season) {
    switch (season) {
      case AppSeason.halloween:
        // Halloween: Naranja vibrante, Morado místico y Negro profundo
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF7A00),
            primary: const Color(0xFFFF7A00),
            secondary: const Color(0xFF8E24AA),
            surface: const Color(0xFF1C1326),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFFFF7A00),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Color(0xFFFF7A00),
            unselectedItemColor: Colors.grey,
          ),
        );

      case AppSeason.christmas:
        // Navidad: Rojo festivo, Verde pino y Blanco
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE53935),
            primary: const Color(0xFFE53935),
            secondary: const Color(0xFF2E7D32),
            tertiary: Colors.white,
            surface: const Color(0xFF1B261D),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFFE53935),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Color(0xFFE53935),
            unselectedItemColor: Colors.grey,
          ),
        );

      case AppSeason.normal:
        // Normal: Estándar oscuro elegante con acentos cyan/teal
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00BFA5),
            primary: const Color(0xFF00BFA5),
            secondary: const Color(0xFF7C4DFF),
            surface: const Color(0xFF121212),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
          ),
        );
    }
  }

  ThemeData getTheme({DateTime? date}) {
    final season = seasonAt(date ?? DateTime.now());
    return getThemeForSeason(season);
  }

  bool _isInSeason(DateTime date, String startValue, String endValue) {
    final start = _monthDay(startValue, date.year);
    final end = _monthDay(endValue, date.year);
    final currentDay = DateTime(date.year, date.month, date.day);

    if (start.isAfter(end)) {
      return !currentDay.isBefore(start) || !currentDay.isAfter(end);
    }

    return !currentDay.isBefore(start) && !currentDay.isAfter(end);
  }

  DateTime _monthDay(String value, int year) {
    final match = RegExp(r'^(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) {
      throw FormatException('Expected a season date in MM-DD format: $value');
    }

    final month = int.parse(match.group(1)!);
    final day = int.parse(match.group(2)!);
    final parsed = DateTime(year, month, day);
    if (parsed.month != month || parsed.day != day) {
      throw FormatException('Invalid season date: $value');
    }
    return parsed;
  }
}
