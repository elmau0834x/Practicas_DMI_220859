import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/models/pexels_video_model.dart';

class PexelsVideoDatasource implements VideoPostDatasource {
  final http.Client? httpClient;

  PexelsVideoDatasource({this.httpClient});

  @override
  Future<List<VideoPost>> getDiscoverVideos() async {
    final apiKey = dotenv.env['PEXELS_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw Exception('PEXELS_API_KEY no está configurada en el archivo .env');
    }

    final client = httpClient ?? http.Client();
    final uri = Uri.parse('https://api.pexels.com/videos/popular?per_page=10');

    final response = await client.get(
      uri,
      headers: {
        'Authorization': apiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al consultar Pexels Video API (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final videosJson = (data['videos'] as List<dynamic>?) ?? [];

    return videosJson
        .map((json) => PexelsVideoModel.fromJson(json as Map<String, dynamic>))
        .where((model) => model.videoUrl.isNotEmpty)
        .map((model) => model.toVideoPostEntity())
        .toList();
  }

  @override
  Future<List<VideoPost>> getForYouVideos() => getDiscoverVideos();

  @override
  Future<List<VideoPost>> getNearYouVideos() => getDiscoverVideos();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) => getDiscoverVideos();
}
