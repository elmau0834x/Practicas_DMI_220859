import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/favorite_videos_repository.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';

typedef VideoFeedLoader = Future<List<VideoPost>> Function();

class VideoFeedProvider extends ChangeNotifier {
  VideoFeedProvider({
    required this.loadFeed,
    required this.favoritesRepository,
    this.sourceProvider,
    this.onFavoritesChanged,
  }) {
    sourceProvider?.addListener(_onVideoSourceChanged);
  }

  final VideoFeedLoader loadFeed;
  final VideoSourceProvider? sourceProvider;
  final FavoriteVideosRepository favoritesRepository;
  final Future<void> Function()? onFavoritesChanged;
  bool initialLoading = true;
  Object? error;
  List<VideoPost> videos = [];
  int _loadRequestId = 0;

  Future<List<VideoPost>> fetchVideos() => loadFeed();

  void _onVideoSourceChanged() {
    videos.clear();
    initialLoading = true;
    error = null;
    notifyListeners();
    unawaited(loadNextPage());
  }

  Future<void> loadNextPage() async {
    final requestId = ++_loadRequestId;
    initialLoading = true;
    error = null;
    notifyListeners();

    try {
      final loadedVideos = await fetchVideos();
      final prefs = await SharedPreferences.getInstance();

      final restoredVideos = loadedVideos.map((video) {
        final storedViews = prefs.getInt('views_${video.id}');
        final storedLikes = prefs.getInt('likes_${video.id}');
        final storedIsLiked =
            prefs.getBool('isLiked_${video.id}') ?? video.isLiked;

        return video.copyWith(
          views: storedViews ?? video.views,
          likes: storedLikes ?? video.likes,
          isLiked: storedIsLiked,
        );
      }).toList();

      if (requestId == _loadRequestId) {
        videos = restoredVideos;
      }
    } catch (exception) {
      if (requestId == _loadRequestId) {
        error = exception;
      }
    } finally {
      if (requestId == _loadRequestId) {
        initialLoading = false;
        notifyListeners();
      }
    }
  }

  /// Incrementa 1 a las vistas cuando el video se reproduce en pantalla
  /// y persiste el nuevo valor en SharedPreferences con la llave views_${id}.
  Future<void> incrementViews(VideoPost video) async {
    final index = videos.indexWhere((v) => v.id == video.id);
    if (index == -1) return;

    final currentVideo = videos[index];
    final newViews = currentVideo.views + 1;

    videos[index] = currentVideo.copyWith(views: newViews);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('views_${video.id}', newViews);
    } catch (e) {
      debugPrint('Error al guardar vistas en SharedPreferences: $e');
    }
  }

  /// Conmuta el estado de like (corazón): si se activa suma 1 like e isLiked = true,
  /// si se desactiva descuenta 1 like e isLiked = false.
  /// Persiste los cambios en SharedPreferences bajo likes_${id} e isLiked_${id}.
  Future<void> toggleLike(VideoPost video) async {
    final index = videos.indexWhere((v) => v.id == video.id);
    if (index == -1) return;

    final currentVideo = videos[index];
    final newIsLiked = !currentVideo.isLiked;
    final newLikes = newIsLiked
        ? currentVideo.likes + 1
        : (currentVideo.likes > 0 ? currentVideo.likes - 1 : 0);

    videos[index] = currentVideo.copyWith(isLiked: newIsLiked, likes: newLikes);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLiked_${video.id}', newIsLiked);
      await prefs.setInt('likes_${video.id}', newLikes);
      if (newIsLiked) {
        await favoritesRepository.saveFavoriteVideo(videos[index]);
      } else {
        await favoritesRepository.removeFavoriteVideo(video.id);
      }
      await onFavoritesChanged?.call();
    } catch (e) {
      debugPrint('Error al guardar el estado de favorito: $e');
      videos[index] = currentVideo;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    sourceProvider?.removeListener(_onVideoSourceChanged);
    super.dispose();
  }
}
