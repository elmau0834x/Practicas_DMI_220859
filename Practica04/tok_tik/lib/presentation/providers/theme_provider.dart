import 'package:flutter/material.dart';
import 'package:tok_tik/config/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final AppTheme _appTheme = AppTheme();
  late AppSeason _season;

  ThemeProvider() {
    _season = _appTheme.seasonAt(DateTime.now());
  }

  AppSeason get season => _season;
  ThemeData get currentTheme => _appTheme.getThemeForSeason(_season);

  String get seasonName {
    switch (_season) {
      case AppSeason.normal:
        return 'Normal';
      case AppSeason.halloween:
        return 'Halloween';
      case AppSeason.christmas:
        return 'Navidad';
    }
  }

  IconData get seasonIcon {
    switch (_season) {
      case AppSeason.normal:
        return Icons.palette_outlined;
      case AppSeason.halloween:
        return Icons.local_fire_department;
      case AppSeason.christmas:
        return Icons.ac_unit;
    }
  }

  /// Cambia al siguiente tema cíclicamente: Normal -> Halloween -> Navidad -> Normal
  void cycleTheme() {
    switch (_season) {
      case AppSeason.normal:
        setSeason(AppSeason.halloween);
        break;
      case AppSeason.halloween:
        setSeason(AppSeason.christmas);
        break;
      case AppSeason.christmas:
        setSeason(AppSeason.normal);
        break;
    }
  }

  /// Establece el tema estacional actual.
  void setSeason(AppSeason newSeason) {
    _season = newSeason;
    notifyListeners();
  }
}
