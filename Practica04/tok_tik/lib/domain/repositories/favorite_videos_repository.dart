import 'package:tok_tik/domain/entities/video_post.dart';

abstract class FavoriteVideosRepository {
  Future<List<VideoPost>> getFavoriteVideos();
  Future<void> saveFavoriteVideo(VideoPost video);
  Future<void> removeFavoriteVideo(String videoId);
}
