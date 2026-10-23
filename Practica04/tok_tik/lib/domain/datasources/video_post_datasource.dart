import 'package:tok_tik/domain/entities/video_post.dart';

abstract class VideoPostDatasource {
  Future<List<VideoPost>> getForYouVideos();
  Future<List<VideoPost>> getDiscoverVideos();
  Future<List<VideoPost>> getNearYouVideos();
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID);
  Future<List<VideoPost>> getTrendingVideosByPage(int page);
}