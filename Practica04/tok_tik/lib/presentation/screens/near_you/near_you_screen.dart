import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/near_you_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_feed_body.dart';

class NearYouScreen extends StatelessWidget {
  const NearYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NearYouProvider>();
    return Scaffold(body: VideoFeedBody(provider: provider));
  }
}
