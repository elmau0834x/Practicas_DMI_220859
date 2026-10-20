class TmdbMovieModel {
  final int id;
  final String title;
  final String overview;
  final int voteCount;
  final double popularity;

  TmdbMovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteCount,
    required this.popularity,
  });

  factory TmdbMovieModel.fromJson(Map<String, dynamic> json) {
    return TmdbMovieModel(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?) ??
          (json['original_title'] as String?) ??
          (json['name'] as String?) ??
          'Película',
      overview: (json['overview'] as String?) ?? '',
      voteCount: (json['vote_count'] as int?) ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TmdbVideoClipModel {
  final String id;
  final String name;
  final String key;
  final String site;
  final String type;
  final String? directUrl;

  TmdbVideoClipModel({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
    required this.type,
    this.directUrl,
  });

  factory TmdbVideoClipModel.fromJson(Map<String, dynamic> json) {
    return TmdbVideoClipModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? 'Trailer',
      key: (json['key'] as String?) ?? '',
      site: (json['site'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      directUrl: (json['url'] as String?) ?? (json['video_url'] as String?),
    );
  }
}
