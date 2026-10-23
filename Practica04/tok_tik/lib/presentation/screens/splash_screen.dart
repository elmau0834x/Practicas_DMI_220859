import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    this.duration = const Duration(milliseconds: 3500),
    this.playIntroSound,
    this.homeBuilder,
    super.key,
  });

  final Duration duration;
  final Future<void> Function(String asset)? playIntroSound;
  final WidgetBuilder? homeBuilder;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasPlayedInitAudio = false;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _playIntroAudio();
      unawaited(_navigateToHome());
    });
  }

  Future<void> _playIntroAudio() async {
    if (_hasPlayedInitAudio) return;
    _hasPlayedInitAudio = true;

    final themeProvider = context.read<ThemeProvider>();
    try {
      final playIntroSound = widget.playIntroSound;
      if (playIntroSound != null) {
        await playIntroSound(themeProvider.soundAsset);
      } else {
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer!.play(AssetSource(themeProvider.soundAsset));
      }
    } catch (error, stackTrace) {
      debugPrint('No se pudo reproducir el audio de inicio: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _navigateToHome() async {
    await Future<void>.delayed(widget.duration);
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: widget.homeBuilder ?? (_) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    final audioPlayer = _audioPlayer;
    if (audioPlayer != null) unawaited(audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                themeProvider.iconAsset,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
