import 'package:flutter/widgets.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';

class DiscoverProvider extends ChangeNotifier {
  bool initialLoading = true;
  List<VideoPost> videos = [];

  final VideoPostsRepository videosRepositoy;

  DiscoverProvider({required this.videosRepositoy});

  Future<void> loadNextPage() async {
    //Todo: Cargar videos
    // await Future.delayed( const Duration(seconds: 2) );

    // final List<VideoPost> newVideos = videoPosts.map(
    //   ( video ) => LocalVideoModel.fromJson(video).toVideoPostEntity()
    // ).toList();
    final newVideos = await videosRepositoy.getTrendingVideosByPage(1);

    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }
}
