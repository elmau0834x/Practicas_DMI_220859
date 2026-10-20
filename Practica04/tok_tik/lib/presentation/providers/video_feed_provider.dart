import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

typedef VideoFeedLoader = Future<List<VideoPost>> Function();

class VideoFeedProvider extends ChangeNotifier {
  VideoFeedProvider({required this.loadFeed});

  final VideoFeedLoader loadFeed;
  bool initialLoading = true;
  Object? error;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    initialLoading = true;
    error = null;
    notifyListeners();

    try {
      final loadedVideos = await loadFeed();
      final prefs = await SharedPreferences.getInstance();

      videos = loadedVideos.map((video) {
        final storedViews = prefs.getInt('views_${video.id}');
        final storedLikes = prefs.getInt('likes_${video.id}');
        final storedIsLiked = prefs.getBool('isLiked_${video.id}') ?? false;

        return video.copyWith(
          views: storedViews ?? video.views,
          likes: storedLikes ?? video.likes,
          isLiked: storedIsLiked,
        );
      }).toList();
    } catch (exception) {
      error = exception;
    } finally {
      initialLoading = false;
      notifyListeners();
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

    videos[index] = currentVideo.copyWith(
      isLiked: newIsLiked,
      likes: newLikes,
    );
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLiked_${video.id}', newIsLiked);
      await prefs.setInt('likes_${video.id}', newLikes);
    } catch (e) {
      debugPrint('Error al guardar like en SharedPreferences: $e');
    }
  }
}
