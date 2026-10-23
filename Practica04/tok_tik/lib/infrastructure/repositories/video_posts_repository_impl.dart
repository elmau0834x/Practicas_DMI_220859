import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class VideoPostsRepositoryImpl implements VideoPostsRepository {

  final VideoPostDatasource videosDatasource;

  VideoPostsRepositoryImpl({
    required this.videosDatasource
  });

  @override
  Future<List<VideoPost>> getForYouVideos() {
    return videosDatasource.getForYouVideos();
  }

  @override
  Future<List<VideoPost>> getDiscoverVideos() {
    return videosDatasource.getDiscoverVideos();
  }

  @override
  Future<List<VideoPost>> getNearYouVideos() {
    return videosDatasource.getNearYouVideos();
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) {
    return videosDatasource.getFavoriteVideosByUser(userID);
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videosDatasource.getTrendingVideosByPage(page);
  }



}
