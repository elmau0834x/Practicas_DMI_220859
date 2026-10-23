import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/favorite_videos_repository.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';

class FavoritesProvider extends VideoFeedProvider {
  FavoritesProvider({required FavoriteVideosRepository repository})
    : _repository = repository,
      super(
        loadFeed: repository.getFavoriteVideos,
        favoritesRepository: repository,
      );

  final FavoriteVideosRepository _repository;

  @override
  Future<List<VideoPost>> fetchVideos() => _repository.getFavoriteVideos();

  @override
  Future<void> toggleLike(VideoPost video) async {
    final wasLiked = videos.any(
      (favorite) => favorite.id == video.id && favorite.isLiked,
    );
    await super.toggleLike(video);
    if (wasLiked) {
      videos.removeWhere((favorite) => favorite.id == video.id);
      notifyListeners();
    }
  }
}
