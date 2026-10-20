import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';
import 'package:tok_tik/infrastructure/datasources/local_video_datasource_implementation.dart';
import 'package:tok_tik/infrastructure/datasources/youtube_video_datasource.dart';

class ForYouVideoRepositoryImpl implements VideoPostsRepository {
  final VideoPostDatasource localDatasource;
  final VideoPostDatasource youtubeDatasource;

  ForYouVideoRepositoryImpl({
    VideoPostDatasource? localDatasource,
    VideoPostDatasource? youtubeDatasource,
  })  : localDatasource = localDatasource ?? LocalVideoDatasource(),
        youtubeDatasource = youtubeDatasource ?? YoutubeVideoDatasource();

  @override
  Future<List<VideoPost>> getForYouVideos() async {
    final localVideos = await localDatasource.getForYouVideos();
    List<VideoPost> ytVideos = [];

    try {
      ytVideos = await youtubeDatasource.getForYouVideos();
    } catch (_) {
      // Si falla la API de YouTube, la app continúa funcionando con los videos locales
    }

    // Mezclar ambas fuentes de datos (intercalando local y YouTube para scroll continuo)
    final mergedVideos = <VideoPost>[];
    final maxLength = localVideos.length > ytVideos.length
        ? localVideos.length
        : ytVideos.length;

    for (int i = 0; i < maxLength; i++) {
      if (i < localVideos.length) {
        mergedVideos.add(localVideos[i]);
      }
      if (i < ytVideos.length) {
        mergedVideos.add(ytVideos[i]);
      }
    }

    return mergedVideos;
  }

  @override
  Future<List<VideoPost>> getDiscoverVideos() => getForYouVideos();

  @override
  Future<List<VideoPost>> getNearYouVideos() => getForYouVideos();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) => getForYouVideos();
}
