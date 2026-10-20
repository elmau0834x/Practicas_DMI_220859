import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/infrastructure/repositories/for_you_video_repository_impl.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';

class ForYouProvider extends VideoFeedProvider {
  ForYouProvider({VideoPostsRepository? repository})
      : super(
          loadFeed: (repository ?? ForYouVideoRepositoryImpl()).getForYouVideos,
        );
}
