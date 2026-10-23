import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/infrastructure/datasources/pixabay_video_datasource.dart';
import 'package:tok_tik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';

class NearYouProvider extends VideoFeedProvider {
  NearYouProvider({
    super.sourceProvider,
    required super.favoritesRepository,
    VideoPostsRepository? repository,
  }) : super(
         loadFeed:
             sourceProvider?.getNearYouVideos ??
             (repository ??
                     VideoPostsRepositoryImpl(
                       videosDatasource: PixabayVideoDatasource(),
                     ))
                 .getNearYouVideos,
       );
}
