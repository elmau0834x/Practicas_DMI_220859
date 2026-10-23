class YoutubeVideoModel {
  final String videoId;
  final String title;
  final String description;

  YoutubeVideoModel({
    required this.videoId,
    required this.title,
    required this.description,
  });

  factory YoutubeVideoModel.fromJson(Map<String, dynamic> json) {
    final idMap = json['id'] as Map<String, dynamic>?;
    final snippetMap = json['snippet'] as Map<String, dynamic>?;

    final rawTitle = snippetMap?['title'] as String? ?? 'YouTube Short';

    return YoutubeVideoModel(
      videoId: idMap?['videoId'] as String? ?? '',
      title: _unescapeHtml(rawTitle),
      description: snippetMap?['description'] as String? ?? '',
    );
  }

  static String _unescapeHtml(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}
