import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/infrastructure/datasources/movie_video_datasource.dart';
import 'package:tok_tik/infrastructure/repositories/movie_video_repository_impl.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';

class DiscoverProvider extends VideoFeedProvider {
  DiscoverProvider({
    super.sourceProvider,
    required super.favoritesRepository,
    super.onFavoritesChanged,
    VideoPostsRepository? repository,
    VideoPostsRepository? videosRepositoy,
  }) : super(
         loadFeed:
             sourceProvider?.getDiscoverVideos ??
             (repository ??
                     videosRepositoy ??
                     MovieVideoRepositoryImpl(
                       datasource: MovieVideoDatasource(),
                     ))
                 .getDiscoverVideos,
       );
}
