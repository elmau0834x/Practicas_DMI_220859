import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/domain/datasources/favorite_videos_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class SharedPreferencesFavoriteVideosDatasource
    implements FavoriteVideosDatasource {
  static const _favoritesKey = 'favorite_videos';

  @override
  Future<void> saveFavoriteVideo(VideoPost video) async {
    final preferences = await SharedPreferences.getInstance();
    final favoriteJson = video.copyWith(isLiked: true).toJson();
    final favorites = await _readFavoriteJson(preferences);
    final updatedFavorites = [
      ...favorites.where((storedJson) {
        return VideoPost.fromJson(storedJson).id != video.id;
      }),
      favoriteJson,
    ];
    final saved = await preferences.setStringList(
      _favoritesKey,
      updatedFavorites,
    );
    if (!saved) {
      throw StateError('No se pudo guardar el video en favoritos.');
    }
  }

  @override
  Future<void> removeFavoriteVideo(String videoId) async {
    final preferences = await SharedPreferences.getInstance();
    final favorites = await _readFavoriteJson(preferences);
    final updatedFavorites = favorites.where((storedJson) {
      return VideoPost.fromJson(storedJson).id != videoId;
    }).toList();
    final saved = await preferences.setStringList(
      _favoritesKey,
      updatedFavorites,
    );
    if (!saved) {
      throw StateError('No se pudo quitar el video de favoritos.');
    }
  }

  @override
  Future<List<VideoPost>> getFavoriteVideos() async {
    final preferences = await SharedPreferences.getInstance();
    final favorites = await _readFavoriteJson(preferences);
    return favorites.map(VideoPost.fromJson).toList(growable: false);
  }

  Future<List<String>> _readFavoriteJson(SharedPreferences preferences) async {
    final storedFavorites = preferences.get(_favoritesKey);
    if (storedFavorites == null) return <String>[];
    if (storedFavorites is List<String>) return storedFavorites;

    if (storedFavorites is String) {
      final decoded = jsonDecode(storedFavorites);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Stored favorites must be a JSON list.');
      }
      final migratedFavorites = decoded
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException(
                'Stored favorite must be a JSON object.',
              );
            }
            return VideoPost.fromMap({
              ...item,
              'isLiked': item['isLiked'] ?? true,
            }).toJson();
          })
          .toList(growable: false);
      final saved = await preferences.setStringList(
        _favoritesKey,
        migratedFavorites,
      );
      if (!saved) {
        throw StateError(
          'No se pudieron migrar los videos favoritos guardados.',
        );
      }
      return migratedFavorites;
    }

    throw const FormatException(
      'Stored favorites must be a list of JSON strings.',
    );
  }
}
