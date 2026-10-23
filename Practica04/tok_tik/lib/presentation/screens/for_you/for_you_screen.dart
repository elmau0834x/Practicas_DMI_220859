import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_feed_body.dart';
import 'package:tok_tik/presentation/widgets/shared/video_source_selector.dart';
import 'package:tok_tik/presentation/providers/for_you_provider.dart';

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForYouProvider>();
    final sourceProvider = context.watch<VideoSourceProvider>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          VideoFeedBody(provider: provider),
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
