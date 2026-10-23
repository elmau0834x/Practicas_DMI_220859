import 'package:flutter/material.dart';
import 'package:tok_tik/presentation/providers/video_feed_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_scrollable_view.dart';

class VideoFeedBody extends StatelessWidget {
  const VideoFeedBody({required this.provider, super.key});

  final VideoFeedProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final error = provider.error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No se pudieron cargar los videos.\n$error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.loadNextPage,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.videos.isEmpty) {
      return const Center(child: Text('No hay videos disponibles.'));
    }

    return VideoScrollableView(
      videos: provider.videos,
      onLikeToggle: provider.toggleLike,
      onVideoView: provider.incrementViews,
    );
  }
}
