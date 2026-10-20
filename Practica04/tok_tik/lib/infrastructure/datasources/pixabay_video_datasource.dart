import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tok_tik/domain/datasources/video_post_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/models/pixabay_video_model.dart';

class PixabayVideoDatasource implements VideoPostDatasource {
  final http.Client? httpClient;

  PixabayVideoDatasource({this.httpClient});

  @override
  Future<List<VideoPost>> getNearYouVideos() async {
    final apiKey = dotenv.env['PIXABAY_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw Exception('PIXABAY_API_KEY no está configurada en el archivo .env');
    }

    final client = httpClient ?? http.Client();
    final uri = Uri.https('pixabay.com', '/api/videos/', {
      'key': apiKey,
      'per_page': '10',
      'video_type': 'all',
    });

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al consultar Pixabay Video API (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final hits = (data['hits'] as List<dynamic>?) ?? [];

    return hits
        .map((json) => PixabayVideoModel.fromJson(json as Map<String, dynamic>))
        .where((model) => model.videoUrl.isNotEmpty)
        .map((model) => model.toVideoPostEntity())
        .toList();
  }

  @override
  Future<List<VideoPost>> getForYouVideos() => getNearYouVideos();

  @override
  Future<List<VideoPost>> getDiscoverVideos() => getNearYouVideos();

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) => getNearYouVideos();
}
