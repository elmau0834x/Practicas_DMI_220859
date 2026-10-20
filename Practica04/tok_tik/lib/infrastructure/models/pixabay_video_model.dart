import 'package:tok_tik/domain/entities/video_post.dart';

class PixabayVideoModel {
  final int id;
  final String tags;
  final String user;
  final String videoUrl;
  final int likes;
  final int views;

  PixabayVideoModel({
    required this.id,
    required this.tags,
    required this.user,
    required this.videoUrl,
    required this.likes,
    required this.views,
  });

  factory PixabayVideoModel.fromJson(Map<String, dynamic> json) {
    final videos = json['videos'] as Map<String, dynamic>? ?? {};

    // Extraer mp4 de videos.medium.url (o fallback a large, small, tiny)
    final medium = videos['medium'] as Map<String, dynamic>?;
    final large = videos['large'] as Map<String, dynamic>?;
    final small = videos['small'] as Map<String, dynamic>?;
    final tiny = videos['tiny'] as Map<String, dynamic>?;

    final videoUrl = medium?['url'] as String? ??
        large?['url'] as String? ??
        small?['url'] as String? ??
        tiny?['url'] as String? ??
        '';

    final rawTags = json['tags'] as String? ?? '';
    final formattedCaption = rawTags.isNotEmpty
        ? rawTags.split(',').map((tag) => '#${tag.trim()}').join(' ')
        : 'Video de Pixabay';

    return PixabayVideoModel(
      id: json['id'] as int? ?? 0,
      tags: formattedCaption,
      user: json['user'] as String? ?? 'Pixabay Creator',
      videoUrl: videoUrl,
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
    );
  }

  VideoPost toVideoPostEntity() {
    return VideoPost(
      id: 'pixabay_$id',
      caption: tags,
      videoUrl: videoUrl,
      likes: likes,
      views: views,
    );
  }
}
