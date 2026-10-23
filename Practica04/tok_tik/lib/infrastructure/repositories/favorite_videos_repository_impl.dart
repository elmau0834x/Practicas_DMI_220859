import 'package:tok_tik/domain/datasources/favorite_videos_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/favorite_videos_repository.dart';
import 'package:tok_tik/infrastructure/datasources/shared_preferences_favorite_videos_datasource.dart';

class FavoriteVideosRepositoryImpl implements FavoriteVideosRepository {
  FavoriteVideosRepositoryImpl({FavoriteVideosDatasource? datasource})
    : _datasource = datasource ?? SharedPreferencesFavoriteVideosDatasource();

  final FavoriteVideosDatasource _datasource;

  @override
  Future<List<VideoPost>> getFavoriteVideos() =>
      _datasource.getFavoriteVideos();

  @override
  Future<void> saveFavoriteVideo(VideoPost video) =>
      _datasource.saveFavoriteVideo(video);

  @override
  Future<void> removeFavoriteVideo(String videoId) =>
      _datasource.removeFavoriteVideo(videoId);
}
