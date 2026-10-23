import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/entities/video_source.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/presentation/providers/discover_provider.dart';
import 'package:tok_tik/presentation/providers/for_you_provider.dart';
import 'package:tok_tik/presentation/providers/near_you_provider.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';
import 'package:tok_tik/infrastructure/repositories/favorite_videos_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads the selected source and switches feeds', () async {
    final sourceProvider = VideoSourceProvider(
      localRepository: _SourceRepository(VideoSource.local),
      youtubeRepository: _SourceRepository(VideoSource.youtube),
      pixabayRepository: _SourceRepository(VideoSource.pixabay),
      tmdbRepository: _SourceRepository(VideoSource.tmdb),
    );
    final favoritesRepository = FavoriteVideosRepositoryImpl();
    final provider = ForYouProvider(
      sourceProvider: sourceProvider,
      favoritesRepository: favoritesRepository,
    );
    final discoverProvider = DiscoverProvider(
      sourceProvider: sourceProvider,
      favoritesRepository: favoritesRepository,
    );
    final nearYouProvider = NearYouProvider(
      sourceProvider: sourceProvider,
      favoritesRepository: favoritesRepository,
    );

    expect(sourceProvider.selectedSource, VideoSource.local);

    await Future.wait([
      provider.loadNextPage(),
      discoverProvider.loadNextPage(),
      nearYouProvider.loadNextPage(),
    ]);
    expect(provider.videos.single.id, VideoSource.local.name);
    expect(discoverProvider.videos.single.id, VideoSource.local.name);
    expect(nearYouProvider.videos.single.id, VideoSource.local.name);

    for (final source in VideoSource.values.skip(1)) {
      sourceProvider.changeVideoSource(source);
      while (provider.initialLoading ||
          discoverProvider.initialLoading ||
          nearYouProvider.initialLoading) {
        await Future<void>.delayed(Duration.zero);
      }

      expect(sourceProvider.selectedSource, source);
      expect(provider.videos.single.id, source.name);
      expect(discoverProvider.videos.single.id, source.name);
      expect(nearYouProvider.videos.single.id, source.name);
    }

    provider.dispose();
    discoverProvider.dispose();
    nearYouProvider.dispose();
    sourceProvider.dispose();
  });
}

class _SourceRepository implements VideoPostsRepository {
  _SourceRepository(this.source);

  final VideoSource source;

  @override
  Future<List<VideoPost>> getForYouVideos() async => [
    VideoPost(
      id: source.name,
      caption: source.name,
      videoUrl: 'https://example.com/${source.name}.mp4',
    ),
  ];

  @override
  Future<List<VideoPost>> getDiscoverVideos() => getForYouVideos();

  @override
  Future<List<VideoPost>> getNearYouVideos() => getForYouVideos();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      getForYouVideos();
}
