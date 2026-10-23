import 'package:tok_tik/domain/entities/video_post.dart';

abstract class FavoriteVideosDatasource {
  Future<void> saveFavoriteVideo(VideoPost video);
  Future<void> removeFavoriteVideo(String videoId);
  Future<List<VideoPost>> getFavoriteVideos();
}
