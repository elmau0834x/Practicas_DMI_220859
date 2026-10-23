import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/config/theme/app_theme.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';

class ThemeIntroOverlay extends StatefulWidget {
  const ThemeIntroOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<ThemeIntroOverlay> createState() => _ThemeIntroOverlayState();
}

class _ThemeIntroOverlayState extends State<ThemeIntroOverlay>
    with SingleTickerProviderStateMixin {
  static const _introDuration = Duration(milliseconds: 2200);

  late final AppSeason _season;
  late final AnimationController _controller;
  Timer? _dismissTimer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _season = context.read<ThemeProvider>().season;
    _controller = AnimationController(vsync: this, duration: _introDuration)
      ..forward();
    _dismissTimer = Timer(
      _introDuration + const Duration(milliseconds: 350),
      () {
        if (mounted) setState(() => _visible = false);
      },
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _seasonColors(_season);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_visible)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = _controller.value;
                  final fadeOut =
                      (1 - ((progress - 0.78) / 0.22).clamp(0.0, 1.0))
                          .toDouble();
                  final scale = _season == AppSeason.normal
                      ? 0.72 + (0.28 * Curves.easeOutBack.transform(progress))
                      : 0.86 + (0.14 * Curves.easeOutCubic.transform(progress));
                  final shake = _season == AppSeason.halloween
                      ? math.sin(progress * math.pi * 12) * (1 - progress) * 0.1
                      : 0.0;
                  final rotation = _season == AppSeason.christmas
                      ? (1 - progress) * 0.12
                      : shake;

                  return Opacity(
                    opacity: fadeOut,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colors.$1, colors.$2, Colors.black],
                        ),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: rotation,
                          child: Transform.scale(
                            scale: scale,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _seasonIcon(_season),
                                  size: 96,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  _seasonTitle(_season),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  (Color, Color) _seasonColors(AppSeason season) {
    return switch (season) {
      AppSeason.normal => (const Color(0xFF00BFA5), const Color(0xFF7C4DFF)),
      AppSeason.halloween => (const Color(0xFFFF7A00), const Color(0xFF8E24AA)),
      AppSeason.christmas => (const Color(0xFFE53935), const Color(0xFF2E7D32)),
      AppSeason.valentine => (const Color(0xFFFF4081), const Color(0xFFAD1457)),
    };
  }

  IconData _seasonIcon(AppSeason season) {
    return switch (season) {
      AppSeason.normal => Icons.play_circle_fill_rounded,
      AppSeason.halloween => Icons.nightlight_round,
      AppSeason.christmas => Icons.ac_unit,
      AppSeason.valentine => Icons.favorite,
    };
  }

  String _seasonTitle(AppSeason season) {
    return switch (season) {
      AppSeason.normal => 'TokTik',
      AppSeason.halloween => 'Halloween',
      AppSeason.christmas => 'Navidad',
      AppSeason.valentine => 'San Valentín',
    };
  }
}
