import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/config/helpers/dynamic_icon_helper.dart';
import 'package:tok_tik/config/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const _seasonPreferenceKey = 'app_season';

  final AppTheme _appTheme = AppTheme();
  final Future<void> Function(String asset)? _playSoundOverride;
  AudioPlayer? _audioPlayer;
  late AppSeason _season;

  ThemeProvider({Future<void> Function(String asset)? playSound})
    : _playSoundOverride = playSound {
    _season = _appTheme.seasonAt(DateTime.now());
  }

  ThemeProvider._withSeason(this._season, this._playSoundOverride);

  static Future<ThemeProvider> load({
    Future<void> Function(String asset)? playSound,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final savedSeason = preferences.getString(_seasonPreferenceKey);
    for (final season in AppSeason.values) {
      if (season.name == savedSeason) {
        final provider = ThemeProvider._withSeason(season, playSound);
        await DynamicIconHelper.changeIcon(season.name);
        return provider;
      }
    }

    final season = AppTheme().seasonAt(DateTime.now());
    final provider = ThemeProvider._withSeason(season, playSound);
    await DynamicIconHelper.changeIcon(season.name);
    return provider;
  }

  AppSeason get season => _season;
  ThemeData get currentTheme => _appTheme.getThemeForSeason(_season);
  String get soundAsset => _appTheme.getSoundAssetForSeason(_season);
  String get iconAsset => _appTheme.getIconAssetForSeason(_season);

  String get seasonName {
    switch (_season) {
      case AppSeason.normal:
        return 'Normal';
      case AppSeason.halloween:
        return 'Halloween';
      case AppSeason.christmas:
        return 'Navidad';
      case AppSeason.valentine:
        return 'San Valentín';
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
      case AppSeason.valentine:
        return Icons.favorite;
    }
  }

  /// Cambia al siguiente tema cíclicamente y conserva la selección del usuario.
  Future<void> cycleTheme({Duration iconChangeDelay = Duration.zero}) async {
    switch (_season) {
      case AppSeason.normal:
        await setSeason(AppSeason.halloween, iconChangeDelay: iconChangeDelay);
        break;
      case AppSeason.halloween:
        await setSeason(AppSeason.christmas, iconChangeDelay: iconChangeDelay);
        break;
      case AppSeason.christmas:
        await setSeason(AppSeason.valentine, iconChangeDelay: iconChangeDelay);
        break;
      case AppSeason.valentine:
        await setSeason(AppSeason.normal, iconChangeDelay: iconChangeDelay);
        break;
    }
  }

  /// Establece el tema estacional actual.
  Future<void> setSeason(
    AppSeason newSeason, {
    Duration iconChangeDelay = Duration.zero,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _seasonPreferenceKey,
      newSeason.name,
    );
    if (!saved) {
      throw StateError('No se pudo guardar el tema seleccionado.');
    }

    final changed = _season != newSeason;
    if (changed) {
      _season = newSeason;
      notifyListeners();
    }
    final soundPlayback = changed ? _playSeasonSound() : Future<void>.value();
    if (changed && iconChangeDelay > Duration.zero) {
      await Future<void>.delayed(iconChangeDelay);
    }
    await DynamicIconHelper.changeIcon(newSeason.name);
    await soundPlayback;
  }

  Future<void> _playSeasonSound() async {
    try {
      final playSound = _playSoundOverride;
      if (playSound != null) {
        await playSound(soundAsset);
      } else {
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer!.play(AssetSource(soundAsset));
      }
    } catch (error, stackTrace) {
      debugPrint(
        'No se pudo reproducir el audio del tema seleccionado: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    final audioPlayer = _audioPlayer;
    if (audioPlayer != null) unawaited(audioPlayer.dispose());
    super.dispose();
  }
}
