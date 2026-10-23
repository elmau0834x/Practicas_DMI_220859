import 'package:flutter/foundation.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/entities/video_source.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';

class VideoSourceProvider extends ChangeNotifier {
  VideoSourceProvider({
    required this.localRepository,
    required this.youtubeRepository,
    required this.pixabayRepository,
    required this.tmdbRepository,
  });

  final VideoPostsRepository localRepository;
  final VideoPostsRepository youtubeRepository;
  final VideoPostsRepository pixabayRepository;
  final VideoPostsRepository tmdbRepository;

  VideoSource selectedSource = VideoSource.local;

  Future<List<VideoPost>> getForYouVideos() =>
      _getVideos((repository) => repository.getForYouVideos());

  Future<List<VideoPost>> getDiscoverVideos() =>
      _getVideos((repository) => repository.getDiscoverVideos());

  Future<List<VideoPost>> getNearYouVideos() =>
      _getVideos((repository) => repository.getNearYouVideos());

  Future<List<VideoPost>> _getVideos(
    Future<List<VideoPost>> Function(VideoPostsRepository) load,
  ) {
    final repository = switch (selectedSource) {
      VideoSource.local => localRepository,
      VideoSource.youtube => youtubeRepository,
      VideoSource.pixabay => pixabayRepository,
      VideoSource.tmdb => tmdbRepository,
    };
    return load(repository);
  }

  void changeVideoSource(VideoSource newSource) {
    if (selectedSource == newSource) return;

    selectedSource = newSource;
    notifyListeners();
  }
}
