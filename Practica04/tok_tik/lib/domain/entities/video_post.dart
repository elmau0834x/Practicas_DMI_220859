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
  }) : id = id ?? videoUrl;

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