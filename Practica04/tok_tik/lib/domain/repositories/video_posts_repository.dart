import 'package:tok_tik/domain/entities/video_post.dart';
//Consumir 3 apis diferentes de video 
abstract class VideoPostsRepository {
  Future<List<VideoPost>> getForYouVideos();
  Future<List<VideoPost>> getDiscoverVideos();
  Future<List<VideoPost>> getNearYouVideos();
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID);
  Future<List<VideoPost>> getTrendingVideosByPage(int page);
}