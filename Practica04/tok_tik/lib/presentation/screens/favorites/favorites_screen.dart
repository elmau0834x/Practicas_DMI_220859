import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/favorites_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_feed_body.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    if (!provider.initialLoading &&
        provider.error == null &&
        provider.videos.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Aún no tienes videos favoritos. Dale like a un video para verlo aquí',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(body: VideoFeedBody(provider: provider));
  }
}
