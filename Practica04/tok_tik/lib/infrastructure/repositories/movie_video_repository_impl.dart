import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/infrastructure/datasources/movie_video_datasource.dart';
import 'package:tok_tik/infrastructure/repositories/video_posts_repository_impl.dart';

class MovieVideoRepositoryImpl extends VideoPostsRepositoryImpl {
  MovieVideoRepositoryImpl({VideoPostDatasource? datasource})
      : super(videosDatasource: datasource ?? MovieVideoDatasource());
}
