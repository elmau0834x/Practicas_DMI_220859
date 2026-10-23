import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/discover_provider.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_feed_body.dart';
import 'package:tok_tik/presentation/widgets/shared/video_source_selector.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverProvider = context.watch<DiscoverProvider>();
    final sourceProvider = context.watch<VideoSourceProvider>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          VideoFeedBody(provider: discoverProvider),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: VideoSourceSelector(
                  selectedSource: sourceProvider.selectedSource,
                  onChanged: sourceProvider.changeVideoSource,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
