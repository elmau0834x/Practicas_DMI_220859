import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/datasources/shared_preferences_favorite_videos_datasource.dart';
import 'package:tok_tik/infrastructure/repositories/favorite_videos_repository_impl.dart';
import 'package:tok_tik/presentation/providers/favorites_provider.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('liked videos are persisted and appear in FavoritesProvider', () async {
    final repository = FavoriteVideosRepositoryImpl();
    final favoritesProvider = FavoritesProvider(repository: repository);
    final feedProvider = VideoFeedProvider(
      loadFeed: () async => [
        VideoPost(
          id: 'liked-video',
          caption: 'A video to like',
          videoUrl: 'https://example.com/video.mp4',
        ),
      ],
      favoritesRepository: repository,
      onFavoritesChanged: favoritesProvider.loadNextPage,
    );

    await favoritesProvider.loadNextPage();
    await feedProvider.loadNextPage();
    await feedProvider.toggleLike(feedProvider.videos.single);

    expect(favoritesProvider.videos.single.id, 'liked-video');
    expect(favoritesProvider.videos.single.isLiked, isTrue);

    await favoritesProvider.toggleLike(favoritesProvider.videos.single);
    expect(favoritesProvider.videos, isEmpty);
    expect(await repository.getFavoriteVideos(), isEmpty);

    feedProvider.dispose();
    favoritesProvider.dispose();
  });

  test('VideoPost serialization preserves every entity property', () {
    final video = VideoPost(
      id: 'serialized-video',
      caption: 'A serialized caption',
      videoUrl: 'https://example.com/video.mp4',
      likes: 12,
      views: 34,
      isLiked: true,
    );

    final restored = VideoPost.fromJson(video.toJson());
    expect(restored.id, video.id);
    expect(restored.caption, video.caption);
    expect(restored.videoUrl, video.videoUrl);
    expect(restored.likes, video.likes);
    expect(restored.views, video.views);
    expect(restored.isLiked, video.isLiked);
  });

  test('favorite datasource stores JSON strings and removes by id', () async {
    final repository = FavoriteVideosRepositoryImpl();
    final video = VideoPost(
      id: 'stored-video',
      caption: 'Stored video',
      videoUrl: 'https://example.com/stored.mp4',
    );

    await repository.saveFavoriteVideo(video);
    expect((await repository.getFavoriteVideos()).single.id, video.id);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('favorite_videos'), hasLength(1));

    await repository.removeFavoriteVideo(video.id);
    expect(await repository.getFavoriteVideos(), isEmpty);
  });

  test('favorite datasource migrates the previous JSON-string cache', () async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      'favorite_videos',
      '[{"id":"legacy","caption":"Legacy video",'
          '"videoUrl":"https://example.com/legacy.mp4","likes":3,"views":9}]',
    );

    final datasource = SharedPreferencesFavoriteVideosDatasource();
    final migrated = await datasource.getFavoriteVideos();

    expect(migrated.single.id, 'legacy');
    expect(migrated.single.isLiked, isTrue);
    expect(preferences.getStringList('favorite_videos'), hasLength(1));
  });
}
