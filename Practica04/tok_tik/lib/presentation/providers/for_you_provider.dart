import 'package:tok_tik/presentation/providers/video_feed_provider.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';

class ForYouProvider extends VideoFeedProvider {
  ForYouProvider({
    required VideoSourceProvider sourceProvider,
    required super.favoritesRepository,
    super.onFavoritesChanged,
  }) : super(
         loadFeed: sourceProvider.getForYouVideos,
         sourceProvider: sourceProvider,
       );
}
