import 'dart:convert';

class VideoPost {
  final String id;
  final String caption;
  final String videoUrl;
  final int likes;
  final int views;
  final bool isLiked;

  VideoPost({
    String? id,
    required this.caption,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
    this.isLiked = false,
  }) : id = id ?? videoUrl,
       assert(caption.trim().isNotEmpty, 'caption cannot be empty'),
       assert(likes >= 0, 'likes cannot be negative'),
       assert(views >= 0, 'views cannot be negative');

  Map<String, dynamic> toMap() => {
    'id': id,
    'caption': caption,
    'videoUrl': videoUrl,
    'likes': likes,
    'views': views,
    'isLiked': isLiked,
  };

  factory VideoPost.fromMap(Map<String, dynamic> map) {
    return VideoPost(
      id: map['id'] as String?,
      caption: map['caption'] as String,
      videoUrl: map['videoUrl'] as String,
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      views: (map['views'] as num?)?.toInt() ?? 0,
      isLiked: map['isLiked'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory VideoPost.fromJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('VideoPost JSON must contain an object.');
    }
    return VideoPost.fromMap(decoded);
  }

  VideoPost copyWith({
    String? id,
    String? caption,
    String? videoUrl,
    int? likes,
    int? views,
    bool? isLiked,
  }) {
    return VideoPost(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
