import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppSeason { normal, halloween, christmas, valentine }

class AppTheme {
  AppSeason seasonAt(DateTime date) {
    if (_isInSeason(
      date,
      _seasonDate('VALENTINE_START', '02-01'),
      _seasonDate('VALENTINE_END', '02-14'),
    )) {
      return AppSeason.valentine;
    }

    if (_isInSeason(
      date,
      _seasonDate('HALLOWEEN_START', '10-01'),
      _seasonDate('HALLOWEEN_END', '11-01'),
    )) {
      return AppSeason.halloween;
    }

    if (_isInSeason(
      date,
      _seasonDate('CHRISTMAS_START', '12-01'),
      _seasonDate('CHRISTMAS_END', '12-31'),
    )) {
      return AppSeason.christmas;
    }

    return AppSeason.normal;
  }

  ThemeData getThemeForSeason(AppSeason season) {
    switch (season) {
      case AppSeason.halloween:
        return ThemeData(
          useMaterial3: true,
          fontFamily: 'monospace',
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
        return ThemeData(
          useMaterial3: true,
          fontFamily: 'serif',
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

      case AppSeason.valentine:
        return ThemeData(
          useMaterial3: true,
          fontFamily: 'cursive',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            primary: const Color(0xFFFF4081),
            secondary: const Color(0xFFAD1457),
            surface: const Color(0xFF29121D),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFFFF80AB),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Color(0xFFFF80AB),
            unselectedItemColor: Colors.grey,
          ),
        );

      case AppSeason.normal:
        return ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
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

  String getSoundAssetForSeason(AppSeason season) {
    return switch (season) {
      AppSeason.normal => 'audios/base_sound.mp3',
      AppSeason.halloween => 'audios/halloween_sound.mp3',
      AppSeason.christmas => 'audios/christmas_sound.mp3',
      AppSeason.valentine => 'audios/valentine_sound.wav',
    };
  }

  String getIconAssetForSeason(AppSeason season) {
    return switch (season) {
      AppSeason.normal => 'assets/icons/icon_normal.png',
      AppSeason.halloween => 'assets/icons/icon_halloween.png',
      AppSeason.christmas => 'assets/icons/icon_christmas.png',
      AppSeason.valentine => 'assets/icons/icon_valentine.png',
    };
  }

  ThemeData getTheme({DateTime? date}) {
    final season = seasonAt(date ?? DateTime.now());
    return getThemeForSeason(season);
  }

  bool _isInSeason(DateTime date, String startValue, String endValue) {
    final currentYear = date.year;
    final startParts = _monthDayParts(startValue, currentYear);
    final endParts = _monthDayParts(endValue, currentYear);
    final crossesYear = endParts.$1 < startParts.$1;
    final currentDay = DateTime(date.year, date.month, date.day);

    bool isWithinSeasonStartingIn(int year) {
      final start = DateTime(year, startParts.$1, startParts.$2);
      final end = DateTime(
        year + (crossesYear ? 1 : 0),
        endParts.$1,
        endParts.$2,
      );
      final isAtOrAfterStart =
          currentDay.isAfter(start) || currentDay.isAtSameMomentAs(start);
      final isAtOrBeforeEnd =
          currentDay.isBefore(end) || currentDay.isAtSameMomentAs(end);
      return isAtOrAfterStart && isAtOrBeforeEnd;
    }

    return isWithinSeasonStartingIn(currentYear) ||
        (crossesYear && isWithinSeasonStartingIn(currentYear - 1));
  }

  (int, int) _monthDayParts(String value, int year) {
    final match = RegExp(r'^(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) {
      throw FormatException('Expected a season date in MM-DD format: $value');
    }

    final month = int.parse(match.group(1)!);
    final day = int.parse(match.group(2)!);
    final parsed = DateTime.parse('$year-$value');
    if (parsed.month != month || parsed.day != day) {
      throw FormatException('Invalid season date: $value');
    }
    return (month, day);
  }

  String _seasonDate(String key, String defaultValue) {
    return dotenv.isInitialized
        ? dotenv.env[key] ?? defaultValue
        : defaultValue;
  }
}
