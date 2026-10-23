import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/datasources/muxed_stream_selector.dart';
import 'package:tok_tik/infrastructure/models/youtube_video_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideoDatasource implements VideoPostDatasource {
  final http.Client? httpClient;
  final YoutubeExplode? ytExplode;

  YoutubeVideoDatasource({this.httpClient, this.ytExplode});

  @override
  Future<List<VideoPost>> getForYouVideos() async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw Exception('YOUTUBE_API_KEY no está configurada en el archivo .env');
    }

    final client = httpClient ?? http.Client();
    final yt = ytExplode ?? YoutubeExplode();

    try {
      final uri = Uri.https('www.googleapis.com', '/youtube/v3/search', {
        'part': 'snippet',
        'maxResults': '10',
        'q': 'shorts',
        'type': 'video',
        'videoDuration': 'short',
        'key': apiKey,
      });

      final response = await client.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          'Error al consultar YouTube Data API (${response.statusCode}): ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>?) ?? [];

      final models = items
          .map(
            (item) => YoutubeVideoModel.fromJson(item as Map<String, dynamic>),
          )
          .where((m) => m.videoId.isNotEmpty)
          .toList();

      // Extraer streams directos .mp4 (muxed con audio) usando youtube_explode_dart
      final videoPosts = await Future.wait(
        models.map((model) async {
          try {
            final manifest = await yt.videos.streamsClient.getManifest(
              model.videoId,
            );
            final muxedStreams = manifest.muxed;
            if (muxedStreams.isEmpty) return null;

            final bestStream = selectMuxedStreamForPlayback(muxedStreams);
            if (bestStream == null) return null;
            final directUrl = bestStream.url.toString();

            return VideoPost(
              id: 'youtube_${model.videoId}',
              caption: model.title,
              videoUrl: directUrl,
              likes: 12500 + (model.videoId.hashCode.abs() % 20000),
              views: 98000 + (model.videoId.hashCode.abs() % 150000),
            );
          } catch (_) {
            // Si algún video particular tiene restricciones de reproducción o región, se descarta
            return null;
          }
        }),
      );

      final validVideos = videoPosts.whereType<VideoPost>().toList();

      if (validVideos.isEmpty && items.isNotEmpty) {
        throw Exception(
          'No se pudieron extraer streams de video reproducibles.',
        );
      }

      return validVideos;
    } finally {
      if (ytExplode == null) {
        yt.close();
      }
    }
  }

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
