import 'package:flutter/material.dart';
import 'package:tok_tik/config/helpers/human_formats.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class VideoButtons extends StatelessWidget {
  final VideoPost video;
  final VoidCallback? onLikeToggle;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onShare;
  final bool isMuted;

  const VideoButtons({
    super.key,
    required this.video,
    this.onLikeToggle,
    this.onMuteToggle,
    this.onShare,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Corazón (Likes) con cambio de color y estado
        _CustomIconButton(
          value: video.likes,
          iconData: video.isLiked ? Icons.favorite : Icons.favorite_border,
          iconColor: video.isLiked ? Colors.red : Colors.white,
          onPressed: onLikeToggle,
        ),
        const SizedBox(height: 20),

        // 2. Vistas
        _CustomIconButton(
          value: video.views,
          iconData: Icons.remove_red_eye_outlined,
          iconColor: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(height: 20),

        // 3. Compartir (Share)
        _CustomIconButton(
          value: 0,
          iconData: Icons.share,
          iconColor: Colors.white,
          onPressed: onShare ?? () {},
        ),
        const SizedBox(height: 20),

        // 4. Silenciar / Sonido (Mute)
        _CustomIconButton(
          value: 0,
          iconData: isMuted ? Icons.volume_off : Icons.volume_up,
          iconColor: Colors.white,
          onPressed: onMuteToggle,
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? color;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    this.onPressed,
    Color? iconColor,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(iconData, color: color, size: 30),
        ),
        if (value > 0)
          Text(
            HumanFormats.humanReadbleNumber(value.toDouble()),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}