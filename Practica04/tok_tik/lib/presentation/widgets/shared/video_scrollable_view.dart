import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/presentation/widgets/video/fullscreen_player.dart';

class VideoScrollableView extends StatelessWidget {
  final List<VideoPost> videos;
  final void Function(VideoPost)? onLikeToggle;
  final void Function(VideoPost)? onVideoView;

  const VideoScrollableView({
    super.key,
    required this.videos,
    this.onLikeToggle,
    this.onVideoView,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final VideoPost videoPost = videos[index];

        return SizedBox.expand(
          child: FullScreenPlayer(
            key: ValueKey(videoPost.id),
            video: videoPost,
            onLikeToggle: onLikeToggle != null
                ? () => onLikeToggle!(videoPost)
                : null,
            onVideoView: onVideoView != null
                ? () => onVideoView!(videoPost)
                : null,
          ),
        );
      },
    );
  }
}
