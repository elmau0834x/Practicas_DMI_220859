import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/presentation/widgets/shared/video_buttons.dart';
import 'package:tok_tik/presentation/widgets/shared/expandable_caption.dart';
import 'package:tok_tik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost? video;
  final String? videoUrl;
  final String? caption;
  final VoidCallback? onLikeToggle;
  final VoidCallback? onVideoView;
  final VoidCallback? onShare;
  final Widget? buttons;

  const FullScreenPlayer({
    super.key,
    this.video,
    this.videoUrl,
    this.caption,
    this.onLikeToggle,
    this.onVideoView,
    this.onShare,
    this.buttons,
  });

  String get actualVideoUrl => video?.videoUrl ?? videoUrl ?? '';
  String get actualCaption => video?.caption ?? caption ?? '';

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late final VideoPlayerController controller;
  late final Future<void> _initializeVideo;
  bool _viewRegistered = false;

  @override
  void initState() {
    super.initState();

    final uri = Uri.tryParse(widget.actualVideoUrl);
    controller = uri != null && (uri.scheme == 'http' || uri.scheme == 'https')
        ? VideoPlayerController.networkUrl(uri)
        : VideoPlayerController.asset(widget.actualVideoUrl);

    controller.addListener(_onControllerUpdate);

    _initializeVideo = controller.initialize().then((_) async {
      await controller.setVolume(1.0);
      await controller.setLooping(true);
      await controller.play();

      // Cuando el video empieza a reproducirse en pantalla, registra la vista
      if (!_viewRegistered) {
        _viewRegistered = true;
        widget.onVideoView?.call();
      }
    });
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdate);
    controller.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  Future<void> _toggleMute() async {
    final shouldMute = controller.value.volume > 0;
    await controller.setVolume(shouldMute ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideo,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('No se pudo reproducir el video: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        final isPaused = !controller.value.isPlaying;

        return GestureDetector(
          onTap: _togglePlayback,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(controller),
                VideoBackground(stops: const [0.8, 1.0]),

                // Ícono permanente de pausa en el centro cuando !controller.value.isPlaying
                Positioned.fill(
                  child: Center(
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: isPaused ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pause,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Caption en la parte inferior izquierda
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: ExpandableCaption(caption: widget.actualCaption),
                ),

                // Columna de botones alineada a la derecha inferior
                Positioned(
                  bottom: 40,
                  right: 20,
                  child:
                      widget.buttons ??
                      VideoButtons(
                        video:
                            widget.video ??
                            VideoPost(
                              caption: widget.actualCaption,
                              videoUrl: widget.actualVideoUrl,
                            ),
                        isMuted: controller.value.volume == 0,
                        onMuteToggle: _toggleMute,
                        onLikeToggle: widget.onLikeToggle,
                        onShare: widget.onShare,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
