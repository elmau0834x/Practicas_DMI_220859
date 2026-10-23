import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_source.dart';

class VideoSourceSelector extends StatelessWidget {
  const VideoSourceSelector({
    required this.selectedSource,
    required this.onChanged,
    super.key,
  });

  final VideoSource selectedSource;
  final ValueChanged<VideoSource> onChanged;

  static const _labels = {
    VideoSource.local: 'Videos Locales',
    VideoSource.youtube: 'YouTube',
    VideoSource.pixabay: 'Pixabay',
    VideoSource.tmdb: 'TMDB',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VideoSource>(
          value: selectedSource,
          dropdownColor: Colors.black87,
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          items: VideoSource.values
              .map(
                (source) => DropdownMenuItem(
                  value: source,
                  child: Text(_labels[source]!),
                ),
              )
              .toList(),
          onChanged: (source) {
            if (source != null) onChanged(source);
          },
        ),
      ),
    );
  }
}
