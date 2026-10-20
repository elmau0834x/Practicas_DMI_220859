import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/datasources/muxed_stream_selector.dart';
import 'package:tok_tik/infrastructure/models/movie_video_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MovieVideoDatasource implements VideoPostDatasource {
  final http.Client? httpClient;
  final YoutubeExplode? ytExplode;

  MovieVideoDatasource({this.httpClient, this.ytExplode});

  @override
  Future<List<VideoPost>> getDiscoverVideos() async {
    final apiKey = dotenv.env['MOVIE_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw Exception('MOVIE_API_KEY no está configurada en el archivo .env');
    }

    final client = httpClient ?? http.Client();
    final yt = ytExplode ?? YoutubeExplode();

    try {
      final headers = <String, String>{};
      if (apiKey.length > 50) {
        headers['Authorization'] = 'Bearer $apiKey';
      }

      final queryParams = <String, String>{'language': 'es-MX', 'page': '1'};
      if (apiKey.length <= 50) {
        queryParams['api_key'] = apiKey;
      }

      final uri = Uri.https(
        'api.themoviedb.org',
        '/3/movie/popular',
        queryParams,
      );
      final response = await client.get(uri, headers: headers);

      if (response.statusCode != 200) {
        throw Exception(
          'Error al consultar Movie API (${response.statusCode}): ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>?) ?? [];

      final movies = results
          .map((item) => TmdbMovieModel.fromJson(item as Map<String, dynamic>))
          .where((m) => m.id > 0)
          .take(
            8,
          ) // Limitamos a las primeras 8 películas para optimizar la extracción
          .toList();

      final videoPosts = <VideoPost>[];

      for (final movie in movies) {
        try {
          final videoParams = <String, String>{};
          if (apiKey.length <= 50) {
            videoParams['api_key'] = apiKey;
          }

          // Consultar videos/trailers de la película
          final videoUri = Uri.https(
            'api.themoviedb.org',
            '/3/movie/${movie.id}/videos',
            videoParams,
          );

          final videoResponse = await client.get(videoUri, headers: headers);
          if (videoResponse.statusCode != 200) continue;

          final videoData =
              jsonDecode(videoResponse.body) as Map<String, dynamic>;
          final clipList = (videoData['results'] as List<dynamic>?) ?? [];

          final clips = clipList
              .map(
                (c) => TmdbVideoClipModel.fromJson(c as Map<String, dynamic>),
              )
              .toList();

          // Priorizar Trailers o Teasers
          TmdbVideoClipModel? selectedClip = clips.firstWhere(
            (c) =>
                c.type.toLowerCase() == 'trailer' &&
                (c.key.isNotEmpty || (c.directUrl?.isNotEmpty ?? false)),
            orElse: () => clips.firstWhere(
              (c) => c.key.isNotEmpty || (c.directUrl?.isNotEmpty ?? false),
              orElse: () => TmdbVideoClipModel(
                id: '',
                name: '',
                key: '',
                site: '',
                type: '',
              ),
            ),
          );

          if (selectedClip.id.isEmpty &&
              selectedClip.key.isEmpty &&
              (selectedClip.directUrl?.isEmpty ?? true)) {
            continue;
          }

          String? directMp4Url = selectedClip.directUrl;

          // Si devuelve ID de YouTube, usamos youtube_explode_dart para extraer el stream directo mp4
          if ((directMp4Url == null || directMp4Url.isEmpty) &&
              (selectedClip.site.toLowerCase() == 'youtube' ||
                  selectedClip.key.isNotEmpty)) {
            try {
              final manifest = await yt.videos.streamsClient.getManifest(
                selectedClip.key,
              );
              final muxedStreams = manifest.muxed;
              if (muxedStreams.isNotEmpty) {
                final bestStream = selectMuxedStreamForPlayback(muxedStreams);
                if (bestStream != null) {
                  directMp4Url = bestStream.url.toString();
                }
              }
            } catch (_) {
              // Si falla la extracción particular de YouTube (ej. restricciones de región), continuamos
              continue;
            }
          }

          if (directMp4Url != null && directMp4Url.isNotEmpty) {
            videoPosts.add(
              VideoPost(
                id: 'movie_${movie.id}_${selectedClip.key.isNotEmpty ? selectedClip.key : selectedClip.id}',
                caption: '${movie.title} • ${selectedClip.name}',
                videoUrl: directMp4Url,
                likes: movie.voteCount > 0 ? movie.voteCount : 1250,
                views: (movie.popularity * 100).toInt() + 10000,
                isLiked: false,
              ),
            );
          }
        } catch (_) {
          continue;
        }
      }

      if (videoPosts.isEmpty && movies.isNotEmpty) {
        throw Exception(
          'No se pudieron extraer videos mp4 reproducibles de las películas.',
        );
      }

      return videoPosts;
    } finally {
      if (ytExplode == null) {
        yt.close();
      }
    }
  }

  @override
  Future<List<VideoPost>> getForYouVideos() => getDiscoverVideos();

  @override
  Future<List<VideoPost>> getNearYouVideos() => getDiscoverVideos();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      getDiscoverVideos();
}
