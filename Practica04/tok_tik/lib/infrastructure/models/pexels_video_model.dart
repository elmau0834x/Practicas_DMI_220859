import 'package:tok_tik/domain/entities/video_post.dart';

class PexelsVideoModel {
  final int id;
  final String author;
  final String videoUrl;
  final int duration;
  final int width;
  final int height;

  PexelsVideoModel({
    required this.id,
    required this.author,
    required this.videoUrl,
    required this.duration,
    required this.width,
    required this.height,
  });

  factory PexelsVideoModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;
    final authorName = userMap?['name'] as String? ?? 'Pexels Creator';
    final duration = json['duration'] as int? ?? 10;
    final id = json['id'] as int? ?? 0;

    final videoFiles = (json['video_files'] as List<dynamic>?) ?? [];

    String bestUrl = '';
    int maxResolution = -1;
    int bestWidth = 0;
    int bestHeight = 0;

    for (final file in videoFiles) {
      if (file is! Map<String, dynamic>) continue;

      final fileType = (file['file_type'] as String? ?? '').toLowerCase();
      final link = file['link'] as String? ?? '';
      if (link.isEmpty) continue;

      // Nos aseguramos de seleccionar archivos mp4
      final isMp4 = fileType.contains('mp4') || link.contains('.mp4');
      if (!isMp4) continue;

      final width = file['width'] as int? ?? 0;
      final height = file['height'] as int? ?? 0;
      final resolution = width * height;

      if (resolution > maxResolution) {
        maxResolution = resolution;
        bestUrl = link;
        bestWidth = width;
        bestHeight = height;
      }
    }

    // Si no encontró por resolución o filtro mp4, toma el primer link disponible
    if (bestUrl.isEmpty && videoFiles.isNotEmpty) {
      final first = videoFiles.first as Map<String, dynamic>;
      bestUrl = first['link'] as String? ?? '';
      bestWidth = first['width'] as int? ?? 0;
      bestHeight = first['height'] as int? ?? 0;
    }

    return PexelsVideoModel(
      id: id,
      author: authorName,
      videoUrl: bestUrl,
      duration: duration,
      width: bestWidth,
      height: bestHeight,
    );
  }

  VideoPost toVideoPostEntity() {
    return VideoPost(
      caption: 'Video por $author en Pexels',
      videoUrl: videoUrl,
      likes: (duration * 142) + (id % 1000),
      views: (duration * 980) + (id % 5000),
    );
  }
}
