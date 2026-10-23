import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class _VideoEndpoint {
  const _VideoEndpoint({
    required this.caption,
    required this.url,
    required this.likes,
    required this.views,
  });

  final String caption;
  final String url;
  final int likes;
  final int views;
}

class RemoteVideoDatasource implements VideoPostDatasource {
  static const _forYouEndpoints = <_VideoEndpoint>[
    _VideoEndpoint(
      caption: 'Big Buck Bunny',
      url:
          'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4',
      likes: 24800,
      views: 182300,
    ),
    _VideoEndpoint(
      caption: 'Jellyfish',
      url:
          'https://test-videos.co.uk/vids/jellyfish/mp4/h264/720/Jellyfish_720_10s_1MB.mp4',
      likes: 17300,
      views: 126500,
    ),
    _VideoEndpoint(
      caption: 'Sintel',
      url:
          'https://test-videos.co.uk/vids/sintel/mp4/h264/720/Sintel_720_10s_1MB.mp4',
      likes: 31400,
      views: 245100,
    ),
  ];

  static const _discoverEndpoints = <_VideoEndpoint>[
    _VideoEndpoint(
      caption: 'Video de muestra, 5 segundos',
      url: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
      likes: 9250,
      views: 78600,
    ),
    _VideoEndpoint(
      caption: 'Video de muestra, 10 segundos',
      url: 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
      likes: 10800,
      views: 93400,
    ),
    _VideoEndpoint(
      caption: 'Video de muestra, 15 segundos',
      url: 'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
      likes: 14100,
      views: 118200,
    ),
  ];

  static const _nearYouEndpoints = <_VideoEndpoint>[
    _VideoEndpoint(
      caption: 'Video de muestra, 20 segundos',
      url: 'https://samplelib.com/lib/preview/mp4/sample-20s.mp4',
      likes: 6200,
      views: 51200,
    ),
    _VideoEndpoint(
      caption: 'Video de muestra, 30 segundos',
      url: 'https://samplelib.com/lib/preview/mp4/sample-30s.mp4',
      likes: 20400,
      views: 161800,
    ),
    _VideoEndpoint(
      caption: 'Big Buck Bunny (versión de 2 MB)',
      url:
          'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4',
      likes: 8800,
      views: 69700,
    ),
  ];

  List<VideoPost> _mapEndpoints(List<_VideoEndpoint> endpoints) {
    return endpoints
        .map(
          (endpoint) => VideoPost(
            caption: endpoint.caption,
            videoUrl: endpoint.url,
            likes: endpoint.likes,
            views: endpoint.views,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<VideoPost>> getForYouVideos() async =>
      _mapEndpoints(_forYouEndpoints);

  @override
  Future<List<VideoPost>> getDiscoverVideos() async =>
      _mapEndpoints(_discoverEndpoints);

  @override
  Future<List<VideoPost>> getNearYouVideos() async =>
      _mapEndpoints(_nearYouEndpoints);

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) =>
      throw UnimplementedError();

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      getForYouVideos();
}
